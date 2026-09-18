local M = {}

local vscode = require("vscode")

-- ============================================================================
-- Smart Tab
-- ============================================================================

function M.tab()
    vscode.eval([[
        const editor = vscode.window.activeTextEditor;

        if (!editor) {
            return;
        }

        const selection = editor.selection;
        const position = selection.active;

        // --------------------------------------------------------------------
        // 有 selection：
        // 正常 Tab
        // --------------------------------------------------------------------

        if (!selection.isEmpty) {
            await vscode.commands.executeCommand(
                "tab"
            );

            return;
        }

        // --------------------------------------------------------------------
        // Pair 跳出
        // --------------------------------------------------------------------

        const line =
            editor.document
                .lineAt(position.line)
                .text;

        const nextChar =
            position.character < line.length
                ? line[position.character]
                : "";

        const closingPairs =
            new Set([
                ")",
                "]",
                "\"",
                "'",
                ">",
                "`"
            ]);

        if (closingPairs.has(nextChar)) {
            const nextPosition =
                position.translate(0, 1);

            editor.selection =
                new vscode.Selection(
                    nextPosition,
                    nextPosition
                );

            return;
        }

        // --------------------------------------------------------------------
        // 普通 Tab
        //
        // 不执行 inlineSuggest.commit，
        // 所以 Copilot 不会被 Tab 接受。
        // --------------------------------------------------------------------

        await vscode.commands.executeCommand(
            "tab"
        );
    ]], {timeout = 1000})
end

-- ============================================================================
-- Smart Shift Tab
-- ============================================================================

function M.shift_tab()
    vscode.eval([[
        await vscode.commands.executeCommand(
            "outdent"
        );
    ]], {timeout = 1000})
end

-- ============================================================================
-- Accept Copilot
-- ============================================================================

function M.accept_copilot()
    vscode.eval([[
        const editor =
            vscode.window.activeTextEditor;

        if (!editor) {
            return;
        }

        const before =
            editor.selection.active;


        // ================================================================
        // 尝试 Jump
        // ================================================================

        await vscode.commands.executeCommand(
            "editor.action.inlineSuggest.jump"
        );

        const currentEditor =
            vscode.window.activeTextEditor;

        if (!currentEditor) {
            return;
        }

        const after =
            currentEditor.selection.active;

        const jumped =
            before.line !== after.line ||
            before.character !== after.character;


        // ================================================================
        // NES
        // ================================================================

        if (jumped) {

            // 等 NES 展开
            await new Promise(
                resolve => setTimeout(resolve, 80)
            );

            // 接受
            await vscode.commands.executeCommand(
                "editor.action.inlineSuggest.commit"
            );

            // 等 UI 更新
            await new Promise(
                resolve => setTimeout(resolve, 30)
            );

            // 清除残留,似乎可以不清理了
            //await vscode.commands.executeCommand(
                //"editor.action.inlineSuggest.hide"
            //);

            return;
        }


        // ================================================================
        // 没有 Jump
        //
        // 当作普通 Ghost Text
        // ================================================================

        await vscode.commands.executeCommand(
            "editor.action.inlineSuggest.commit"
        );

    ]], {timeout = 1500})
end

-- ============================================================================
-- Reject Copilot
-- ============================================================================

function M.reject_copilot()
    vscode.eval([[
        // 普通 Inline Suggestion
        await vscode.commands.executeCommand(
            "editor.action.inlineSuggest.hide"
        );

        // NES 的 collapsed marker 之后如果确定了专门的
        // dismiss command，再加在这里。
    ]], {timeout = 1000})
end

-- ============================================================================
-- Setup
-- ============================================================================

function M.setup()

    vim.keymap.set({"n", "i"}, "<C-g>t", M.tab,
                   {silent = true, desc = "Smart Tab"})

    vim.keymap.set({"n", "i"}, "<C-g>T", M.shift_tab,
                   {silent = true, desc = "Smart Shift Tab"})

    vim.keymap.set({"n", "i"}, "<C-g>a", M.accept_copilot,
                   {silent = true, desc = "Accept Copilot"})

    vim.keymap.set({"n", "i"}, "<C-g>r", M.reject_copilot,
                   {silent = true, desc = "Reject Copilot"})
end

return M
