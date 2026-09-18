local M = {}

local vscode = require("vscode")

-- ============================================================================
-- Accept Completion + Complete Function Call
--
-- VS Code Suggestion:
--
--     Foo
--      ↓ Enter
--     Foo(|)
--
-- Generic:
--
--     LazyQuery
--        ↓ Enter
--     LazyQuery<|, >()
--
-- Native snippets:
--
--     for
--      ↓ Enter
--     for (...)
--     {
--         ...
--     }
--
-- 原生 snippet 不做额外处理，因此保留 VS Code snippet session，
-- 后续 Tab / Shift+Tab 可以正常切换 placeholder。
-- ============================================================================

local function complete()
    vscode.eval([[
        // ================================================================
        // 0. 先让 VS Code 原生接受当前 Completion
        //
        // 非常重要：
        //
        // 这里和后面的 post-processing 都发生在同一次 vscode.eval()
        // 中间不会再发送一个 Neovim keypress。
        //
        // 因此：
        //
        // for / foreach / snippet
        //
        // 建立起来的 snippet session 不会被额外的 <C-y> 打断。
        // ================================================================

        await vscode.commands.executeCommand(
            "acceptSelectedSuggestion"
        );

        // 让 VS Code / C# extension 完成 completion/snippet 更新。
        await new Promise(
            resolve => setTimeout(resolve, 0)
        );


        // ================================================================
        // Editor
        // ================================================================

        const editor =
            vscode.window.activeTextEditor;

        if (!editor) {
            return;
        }

        const document =
            editor.document;

        const position =
            editor.selection.active;


        // ================================================================
        // Helper
        // ================================================================

        function escapeRegex(text) {
            return text.replace(
                /[.*+?^${}()|[\]\\]/g,
                "\\$&"
            );
        }


        // ================================================================
        // C#
        //
        // 根据 Definition Provider 判断：
        //
        //     identifier
        //
        // 是否是：
        //
        //     Foo(...)
        //
        // 或：
        //
        //     Foo<T, TR>(...)
        //
        // 返回：
        //
        // {
        //     callable: true,
        //     genericCount: 2
        // }
        // ================================================================

        async function resolveCSharpCallable(
            document,
            position,
            identifier
        ) {
            const symbolPosition =
                new vscode.Position(
                    position.line,
                    Math.max(
                        0,
                        position.character - 1
                    )
                );

            let definitions = null;

            try {
                definitions =
                    await vscode.commands.executeCommand(
                        "vscode.executeDefinitionProvider",
                        document.uri,
                        symbolPosition
                    );
            }
            catch {
                return {
                    callable: false,
                    genericCount: 0
                };
            }

            if (
                !definitions ||
                definitions.length === 0
            ) {
                return {
                    callable: false,
                    genericCount: 0
                };
            }


            const escapedIdentifier =
                escapeRegex(identifier);


            for (const definition of definitions) {
                let uri = null;
                let range = null;


                // --------------------------------------------------------
                // Location
                // --------------------------------------------------------

                if (definition.uri) {
                    uri =
                        definition.uri;

                    range =
                        definition.range;
                }


                // --------------------------------------------------------
                // LocationLink
                // --------------------------------------------------------

                else if (definition.targetUri) {
                    uri =
                        definition.targetUri;

                    range =
                        definition.targetSelectionRange ??
                        definition.targetRange;
                }


                if (!uri || !range) {
                    continue;
                }


                // --------------------------------------------------------
                // 打开定义所在文件
                // --------------------------------------------------------

                let targetDocument = null;

                try {
                    targetDocument =
                        await vscode.workspace.openTextDocument(
                            uri
                        );
                }
                catch {
                    continue;
                }


                // ========================================================
                // Definition range 通常只覆盖 identifier：
                //
                // public static TR LazyQuery<T, TR>(...)
                //                  ^^^^^^^^^
                //
                // 所以从 identifier 开始继续向后读取几行。
                // ========================================================

                const start =
                    range.start;

                const endLine =
                    Math.min(
                        targetDocument.lineCount - 1,
                        start.line + 8
                    );

                const end =
                    new vscode.Position(
                        endLine,
                        targetDocument
                            .lineAt(endLine)
                            .text.length
                    );

                const text =
                    targetDocument.getText(
                        new vscode.Range(
                            start,
                            end
                        )
                    );


                // ========================================================
                // Generic Method
                //
                // LazyQuery<T, TR>(
                // Foo<T>(
                // ========================================================

                const genericRegex =
                    new RegExp(
                        "^" +
                        escapedIdentifier +
                        "\\s*<([^>]*)>\\s*\\("
                    );

                const genericMatch =
                    text.match(
                        genericRegex
                    );

                if (genericMatch) {
                    const parameters =
                        genericMatch[1]
                            .split(",")
                            .map(
                                x => x.trim()
                            )
                            .filter(
                                x => x.length > 0
                            );

                    return {
                        callable: true,
                        genericCount:
                            parameters.length
                    };
                }


                // ========================================================
                // Normal Method
                //
                // Foo(
                // ========================================================

                const methodRegex =
                    new RegExp(
                        "^" +
                        escapedIdentifier +
                        "\\s*\\("
                    );

                if (
                    methodRegex.test(text)
                ) {
                    return {
                        callable: true,
                        genericCount: 0
                    };
                }
            }


            return {
                callable: false,
                genericCount: 0
            };
        }


        // ================================================================
        // 非 C#
        //
        // 继续使用 CompletionItemKind 判断 callable。
        // ================================================================

        async function resolveCompletionCallable(
            document,
            position,
            identifier
        ) {
            let list = null;

            try {
                list =
                    await vscode.commands.executeCommand(
                        "vscode.executeCompletionItemProvider",
                        document.uri,
                        position
                    );
            }
            catch {
                return false;
            }


            if (!list) {
                return false;
            }


            for (const item of list.items) {
                const label =
                    typeof item.label === "string"
                        ? item.label
                        : item.label?.label ?? "";

                if (
                    label !== identifier
                ) {
                    continue;
                }


                if (
                    item.kind ===
                        vscode.CompletionItemKind.Method ||

                    item.kind ===
                        vscode.CompletionItemKind.Function ||

                    item.kind ===
                        vscode.CompletionItemKind.Constructor
                ) {
                    return true;
                }
            }


            return false;
        }


        // ================================================================
        // 创建 Generic Snippet
        //
        // count = 1
        //
        //     <${1}>(${2})
        //
        // count = 2
        //
        //     <${1}, ${2}>(${3})
        // ================================================================

        function createGenericSnippet(count) {
            let snippet = "<";


            for (
                let i = 1;
                i <= count;
                ++i
            ) {
                if (i > 1) {
                    snippet += ", ";
                }

                snippet +=
                    "${" + i + "}";
            }


            snippet += ">";


            snippet +=
                "(${" +
                (count + 1) +
                "})";


            return snippet;
        }


        // ================================================================
        // 1. 找刚刚补全出来的 identifier
        //
        // 普通 method：
        //
        //     Foo|
        //
        // 可以找到 Foo。
        //
        // VS Code 原生 snippet：
        //
        //     for (int i = ...)
        //              |
        //
        // 通常这里不会匹配到 completion identifier，
        // 因而直接 return，不再碰原生 snippet。
        // ================================================================

        const line =
            document
                .lineAt(position.line)
                .text;

        const before =
            line.substring(
                0,
                position.character
            );

        const match =
            before.match(
                /[A-Za-z_][A-Za-z0-9_]*$/
            );


        if (!match) {
            return;
        }


        const identifier =
            match[0];


        // ================================================================
        // 2. 如果 completion 本身已经带：
        //
        //     (
        //
        // 或：
        //
        //     <
        //
        // 就完全不处理。
        //
        // 这也可以避免重复：
        //
        //     Foo()()
        // ================================================================

        const after =
            line.substring(
                position.character
            );


        if (
            /^\s*[<(]/.test(after)
        ) {
            return;
        }


        // ================================================================
        // 3. 判断 Callable
        // ================================================================

        let callable = false;
        let genericCount = 0;


        if (
            document.languageId === "csharp"
        ) {
            // ------------------------------------------------------------
            // C#
            //
            // 使用 Definition Provider。
            // ------------------------------------------------------------

            const result =
                await resolveCSharpCallable(
                    document,
                    position,
                    identifier
                );


            callable =
                result.callable;

            genericCount =
                result.genericCount;
        }
        else {
            // ------------------------------------------------------------
            // 其他语言
            //
            // 使用 Completion Provider。
            // ------------------------------------------------------------

            callable =
                await resolveCompletionCallable(
                    document,
                    position,
                    identifier
                );
        }


        if (!callable) {
            return;
        }


        // ================================================================
        // 4. Definition / Completion 查询是异步的。
        //
        // 查询完成以后重新检查：
        //
        //     editor
        //     cursor
        //     identifier
        //
        // 避免用户已经继续输入或者移动光标时，
        // 我们又把 () 插到旧位置。
        // ================================================================

        if (
            vscode.window.activeTextEditor !==
            editor
        ) {
            return;
        }


        const currentPosition =
            editor.selection.active;


        if (
            currentPosition.line !==
                position.line ||

            currentPosition.character !==
                position.character
        ) {
            return;
        }


        const currentLine =
            document
                .lineAt(
                    currentPosition.line
                )
                .text;


        const currentBefore =
            currentLine.substring(
                0,
                currentPosition.character
            );


        if (
            !currentBefore.endsWith(
                identifier
            )
        ) {
            return;
        }


        const currentAfter =
            currentLine.substring(
                currentPosition.character
            );


        if (
            /^\s*[<(]/.test(
                currentAfter
            )
        ) {
            return;
        }


        // ================================================================
        // 5. 插入 Function Call Snippet
        // ================================================================

        if (
            genericCount > 0
        ) {
            // ------------------------------------------------------------
            // Generic Method
            //
            // Foo<T>
            //
            //     →
            //
            // Foo<|>()
            //
            //
            // Foo<T, TR>
            //
            //     →
            //
            // Foo<|, >()
            // ------------------------------------------------------------

            const snippet =
                createGenericSnippet(
                    genericCount
                );


            await editor.insertSnippet(
                new vscode.SnippetString(
                    snippet
                ),
                currentPosition
            );
        }
        else {
            // ------------------------------------------------------------
            // Normal Method
            //
            // Foo
            //
            //     →
            //
            // Foo(|)
            // ------------------------------------------------------------

            await editor.insertSnippet(
                new vscode.SnippetString(
                    "($1)"
                ),
                currentPosition
            );
        }

    ]], {timeout = 2000})
end

-- ============================================================================
-- Setup
-- ============================================================================

function M.setup()
    vim.keymap.set("i", "<C-y>", complete, {
        silent = true,
        desc = "Accept completion / complete function call"
    })
end

return M
