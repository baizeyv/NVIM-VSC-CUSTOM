local M = {}

local vscode = require('vscode')

local previous_mode = 'n'

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
        local current_mode = vim.fn.mode()
        if previous_mode == 'V' and current_mode == 'n' then
            -- 从 visual-line 模式 切换到 normal mode
            vim.keymap.set({ "n", "x", "o" }, "e", function()
                vim.cmd("normal! j")
                vim.keymap.set({ "n", "x", "o" }, "e", "gj", { remap = true, silent = true })
            end, { remap = false, silent = true, desc = "Move Down" })

            vim.keymap.set({ "n", "x", "o" }, "u", function()
                vim.cmd("normal! k")
                vim.keymap.set({ "n", "x", "o" }, "u", "gk", { remap = true, silent = true })
            end, { remap = false, silent = true, desc = "Move Down" })

            vim.keymap.set({ "n", "x", "o" }, "E", function()
                vim.cmd("normal! 5j")
                vim.keymap.set({ "n", "x", "o" }, "E", "5gj", { remap = true, silent = true })
            end, { remap = false, silent = true, desc = "Move Down" })

            vim.keymap.set({ "n", "x", "o" }, "U", function()
                vim.cmd("normal! 5k")
                vim.keymap.set({ "n", "x", "o" }, "U", "5gk", { remap = true, silent = true })
            end, { remap = false, silent = true, desc = "Move Down" })
        end
        previous_mode = current_mode
    end
})

-- lhs = {rhs, modes, opts}
M.Generic = {
    ["~"] = { "~", { "n", "x" }, { silent = true, desc = "Toggle Case" } },
    ["`"] = { "`", { "n", "x" }, { silent = true, desc = "Goto Mark" } },
    ["@"] = { "@", "n", { desc = "Play Macro" } },
    ["#"] = { "#", { "n", "x", "o" }, { desc = "Goto Previous Identifier (under cursor)" } },
    ["I"] = { "$", { "n", "x", "o" }, { desc = "Goto End Of Line (eol)" } },
    ["%"] = { "%", { "n", 'x', "o" }, { desc = "Goto brackets Match" } },
    ["N"] = { "^", { "n", "x", "o" }, { desc = "Goto Soft Begin Of Line (s-bol)" } },
    ["&"] = { "&", "n", { desc = "Repeat Subsititute" } }, -- 重复上一次的 :s 替换命令
    ["*"] = { "*", { "n", 'x', 'o' }, { desc = "Goto Next Identifer (under cursor)" } },
    ["("] = { "(", { "n", "x", "o" }, { desc = "Goto Begin Of Sentence" } },
    [")"] = { ")", { "n", "x", "o" }, { desc = "Goto End Of Sentence" } },
    ["0"] = { "0", { "n", "x", "o" }, { desc = "Goto Hard Begin Of Line (bol)" } },
    ["_"] = { "_", { "n", 'x', "o" }, { desc = "Goto Begin Of Current Line (soft)" } },
    ["-"] = { "-", { "n", 'x', "o" }, { desc = "Goto Begin Of Previous Line (soft)" } },
    ["+"] = { "+", { "n", 'x', "o" }, { desc = "Goto Begin Of Next Line (soft)" } },
    ["="] = { "=", { "n" }, { desc = "Auto Format" } },
    ["Q"] = { "Q", { "n" }, { desc = "Enter Ex Mode" } },
    ["q"] = { "q", { "n" }, { desc = "Record Macro" } },
    ["w"] = { "w", { "n", 'x', "o" }, { desc = "Goto Next Begin Of Word" } },
    ["W"] = { "W", { "n", 'x', "o" }, { desc = "Goto Next Begin Of Word (symbol)" } },
    ["h"] = { "e", { "n", 'x', "o" }, { desc = "Goto Next End Of Word" } },
    ["H"] = { "E", { "n", 'x', "o" }, { desc = "Goto Next End Of Word (symbol)" } },
    ["r"] = { "r", "n", { desc = "Replace Char" } },
    ["R"] = { "R", "n", { desc = "Replace Word Until" } },
    ["t"] = { "t", { "n", "x", "o" }, { desc = "Goto Next Char Until" } },
    ["T"] = { "T", { "n", "x", "o" }, { desc = "Goto Previous Char Until" } },
    ["y"] = { "y", { "n", 'x' }, { desc = "Yank" } },
    ["Y"] = { "Y", { "n", 'x' }, { desc = "Yank Line" } },
    ["l"] = { "u", "n", { desc = "Undo" } },
    ["L"] = { "U", "n", { desc = "Undo Line" } },
    ["k"] = { "i", "n", { desc = "Enter Insert Mode" } },
    ["K"] = { "I", { "n", "x", "o" }, { desc = "Insert At Begin Of Line" } },
    ["o"] = { "o", { "n" }, { desc = "Insert At Next Line (new line)" } },
    ["O"] = { "O", { "n" }, { desc = "Insert At Previous Line (new line)" } },
    ["p"] = { "p", "n", { desc = "Paste After Cursor" } },
    ["P"] = { "P", "n", { desc = "Paste Before Cursor" } },
    ["{"] = { "{", { "n", "x", "o" }, { desc = "Goto Begin Of Paragraph" } },
    ["}"] = { "}", { "n", "x", "o" }, { desc = "Goto Previous Of Paragraph" } },
    ["["] = { "[", { "n" }, { desc = "Misc Left" } },
    ["]"] = { "]", { "n" }, { desc = "Misc Right" } },
    ["a"] = { "a", { "n" }, { desc = "Append After Cursor" } },
    ["A"] = { "A", { "n" }, { desc = "Append End Of Line" } },
    ["s"] = { "s", { "n", "x" }, { desc = "Subst Char" } },
    ["S"] = { "S", { "n", "x" }, { desc = "Subst Line" } },
    ["d"] = { "d", { "n", "x" }, { desc = "Delete" } },
    ["D"] = { "D", { "n", "x" }, { desc = "Delete To End Of Line" } },
    ["f"] = { "f", { "n", "x", "o" }, { desc = "Find Next Char" } },
    ["F"] = { "F", { "n", "x", "o" }, { desc = "Find Previous Char" } },
    ["g"] = { "g", { "n", "x", "o" }, { desc = "Misc g" } },
    ["G"] = { "G", { "n", "x", "o" }, { desc = "Goto End Of File" } },
    ["n"] = { "h", { "n", "x", "o" }, { desc = "Move Left" } },
    ["gu"] = { "H", { "n", "x", "o" }, { desc = "Goto Top Screen" } },
    --["e"] = { "j", { "n", "x", "o" }, { desc = "Move Down" } },
    ["J"] = { "J", { "n", "x" }, { desc = "Join Line" } },
    --["u"] = { "k", { "n", "x", "o" }, { desc = "Move Up" } },
    ["<leader>h"] = { function()
        vscode.call('editor.action.showDefinitionPreviewHover')
    end, { "n", "x" }, { desc = "Man Page Identifier" } },
    ["i"] = { "l", { "n", "x", "o" }, { desc = "Move Right" } },
    ["ge"] = { "L", { "n", "x", "o" }, { desc = "Goto Bottom Screen" } },
    [";"] = { ";", { "n", "x" }, { desc = "Repeat tfTF" } },
    ['"'] = { '"', { "n", "x" }, { desc = "Register" } },
    ["'"] = { "'", { "n", "x", "o" }, { desc = "Goto Mark Begin Of Line" } },
    ["|"] = { "|", { "n", "x", "o" }, { desc = "Goto Column Number" } },
    ["Z"] = { "Z", "n", { desc = "Quit" } }, -- ZZ->quit ZQ->quit without save
    ["z"] = { "z", { "n", "x" }, { desc = "Misc z" } },
    ["x"] = { "x", { "n", "x" }, { desc = "Delete Char" } },
    ["X"] = { "X", { "n", "x" }, { desc = "Delete Char Backspace" } },
    ["v"] = { "v", { "n" }, { desc = "Select Chars" } },
    ["V"] = { "V", { "n" }, { desc = "Select Lines" } },
    ["b"] = { "b", { "n", "x", "o" }, { desc = "Goto Previous Begin Of Word" } },
    ["B"] = { "B", { "n", "x", "o" }, { desc = "Goto Previous Begin Of Word (symbol)" } },
    ['<C-.>'] = { "n", { "n", "x", "o" }, { desc = "Find Next" } },
    ['<C-,>'] = { "N", { "n", "x", "o" }, { desc = "Find Previous" } },
    ['m'] = { "m", { "n" }, { desc = "Set Mark" } },
    ['gm'] = { "M", { "n", "x", "o" }, { desc = "Goto Middle Screen" } },
    [','] = { ",", { "n", "x", "o" }, { desc = "Reverse ftFT" } },
    ['.'] = { ".", { "n" }, { desc = "Repeat Cmd" } },
    ["e"] = { "gj", { "n", "x", "o" }, { remap = true, silent = true, desc = "Move Down" } },
    ["u"] = { "gk", { "n", "x", "o" }, { remap = true, silent = true, desc = "Move Down" } },
    ["E"] = { "5gj", { "n", "x", "o" }, { remap = true, silent = true, desc = "Move Down" } },
    ["U"] = { "5gk", { "n", "x", "o" }, { remap = true, silent = true, desc = "Move Down" } },
}

M.Other1 = {
    ["<C-v>"] = { "<C-v>", { "n", "x" }, { desc = "Visual Block" } },
    -----------------------------------------------------------------------------------------------
    ["zu"] = { "zt", { "n" }, { desc = "Cursor Top" } },
    ["ze"] = { "zb", { "n" }, { desc = "Cursor Bottom" } },
    ["zz"] = { "zz", { "n" }, { desc = "Cursor Middle" } },
    -----------------------------------------------------------------------------------------------
    ['<C-f>'] = { "<C-f>", { "n", "x" }, { desc = "Scroll Down Whole" } },
    ['<C-b>'] = { "<C-b>", { "n", "x" }, { desc = "Scroll Up Whole" } },
    ['<C-e>'] = { "<C-e>", { "n", "x" }, { desc = "Scroll Down Line" } },
    ['<C-u>'] = { "<C-y>", { "n", "x" }, { desc = "Scroll Up Line" } },
    ['<C-S-e>'] = { "<C-d>", { "n", "x" }, { desc = "Scroll Down Half" } },
    ['<C-S-u>'] = { "<C-u>", { "n", "x" }, { desc = "Scroll Up Half" } },
    -----------------------------------------------------------------------------------------------
    ["<C-r>"] = { "<C-r>", "n", { desc = "Redo" } },
    -----------------------------------------------------------------------------------------------
    --["<leader>ws"] = { "<cmd>call VSCodeNotify('workbench.action.splitEditorDown')<cr>", "n", { desc = "Split Window Horizontal" } },
    ["<leader>ws"] = { function()
        vscode.call('workbench.action.splitEditorDown')
    end, "n", { desc = "Split Window Horizontal" } },
    --["<leader>wv"] = { "<cmd>call VSCodeNotify('workbench.action.splitEditorRight')<cr>", "n", { desc = "Split Window Vertical" } },
    ["<leader>wv"] = { function()
        vscode.call('workbench.action.splitEditorRight')
    end, "n", { desc = "Split Window Vertical" } },
    --["<leader>ww"] = { "<cmd>call VSCodeNotify('workbench.action.navigateEditorGroups')<cr>", "n", { desc = "Toggle Window" } },
    ["<leader>ww"] = { function()
        vscode.call('workbench.action.navigateEditorGroups')
    end, "n", { desc = "Toggle Window" } },
    --["<leader>wq"] = { "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>", "n", { desc = "Close Window" } },
    ["<leader>wq"] = { function()
        vscode.call('workbench.action.closeActiveEditor')
    end, "n", { desc = "Close Window" } },
    --["<leader>wI"] = { "<cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupRight')<cr>", "n", { desc = "Swap Window" } },
    ["<leader>wI"] = { function()
        vscode.call('workbench.action.moveActiveEditorGroupRight')
    end, "n", { desc = "Swap Window" } },
    --["<leader>wN"] = { "<cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupLeft')<cr>", "n", { desc = "Swap Window" } },
    ["<leader>wN"] = { function()
        vscode.call('workbench.action.moveActiveEditorGroupLeft')
    end, "n", { desc = "Swap Window" } },
    --["<leader>wU"] = { "<cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupUp')<cr>", "n", { desc = "Swap Window" } },
    ["<leader>wU"] = { function()
        vscode.call('workbench.action.moveActiveEditorGroupUp')
    end, "n", { desc = "Swap Window" } },
    --["<leader>wE"] = { "<cmd>call VSCodeNotify('workbench.action.moveActiveEditorGroupDown')<cr>", "n", { desc = "Swap Window" } },
    ["<leader>wE"] = { function()
        vscode.call('workbench.action.moveActiveEditorGroupDown')
    end, "n", { desc = "Swap Window" } },
    --["<leader>wn"] = { "<cmd>call VSCodeNotify('workbench.action.navigateLeft')<cr>", "n", { desc = "Switch To Left Window" } },
    ["<leader>wn"] = { function()
        vscode.call('workbench.action.navigateLeft')
    end, "n", { desc = "Switch To Left Window" } },
    --["<leader>wi"] = { "<cmd>call VSCodeNotify('workbench.action.navigateRight')<cr>", "n", { desc = "Switch To Right Window" } },
    ["<leader>wi"] = { function()
        vscode.call('workbench.action.navigateRight')
    end, "n", { desc = "Switch To Right Window" } },
    --["<leader>we"] = { "<cmd>call VSCodeNotify('workbench.action.navigateDown')<cr>", "n", { desc = "Switch To Down Window" } },
    ["<leader>we"] = { function()
        vscode.call('workbench.action.navigateDown')
    end, "n", { desc = "Switch To Down Window" } },
    --["<leader>wu"] = { "<cmd>call VSCodeNotify('workbench.action.navigateUp')<cr>", "n", { desc = "Switch To Up Window" } },
    ["<leader>wu"] = { function()
        vscode.call('workbench.action.navigateUp')
    end, "n", { desc = "Switch To Up Window" } },
    --["<leader>w="] = { "<cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<cr>", "n", { desc = "Window Same Width Height" } },
    ["<leader>w="] = { function()
        vscode.call('workbench.action.evenEditorWidths')
    end, "n", { desc = "Window Same Width Height" } },
    -----------------------------------------------------------------------------------------------
    ['o'] = { "o", "x", { desc = "Visual Block Change" } },
    ['O'] = { "O", "x", { desc = "Visual Block Corner" } },
    -----------------------------------------------------------------------------------------------
    ['>'] = { ">", "x", { desc = "Visual Indent" } },
    ['<'] = { "<", "x", { desc = "Visual Undent" } },
    ['y'] = { "y", "x", { desc = "Visual Yank" } },
    ['d'] = { "d", "x", { desc = "Visual Delete" } },
    ['~'] = { "~", "x", { desc = "Visual Caps" } },
    ['l'] = { "u", "x", { desc = "Visual Lowercase" } },
    ['L'] = { "U", "x", { desc = "Visual Uppercase" } },

    ["=="] = { function()
        vscode.call('editor.action.formatSelection')
    end, "x", { desc = "Format Selection Document" } }
}


M.Other2 = {
    ["<C-h>"] = { "<BS>", "i", { desc = "Insert Backspace" } },
    ['<C-w>'] = { "<C-w>", "i", { desc = "Delete Previous Word" } },
    ['<C-j>'] = { "<C-j>", "i", { desc = "Insert CR" } },
    ['<C-t>'] = { "<C-t>", "i", { desc = "Indent" } },
    ['<C-d>'] = { "<C-d>", "i", { desc = "Undent" } },
    ['<C-r>'] = { "<C-r>", "i", { desc = "Insert Register" } },
    ['<C-o>'] = { "<C-o>", "i", { desc = "Temporary Normal" } },
}

M.Extra = {
    ["<esc>"] = { "<cmd>noh<cr><esc>", { "i", "n" }, { desc = "Escape And Clear hlsearch" } },
    -----------------------------------------------------------------------------------------------
    -- Add undo break-points
    [","] = { ",<c-g>u", "i", {} },
    ["."] = { ".<c-g>u", "i", {} },
    [";"] = { ";<c-g>u", "i", {} },
    ["<C-s>"] = { "<cmd>w<cr><esc>", { "i", "x", "n", "s" }, { desc = "Save File" } },
    -- better indent/undent (will override default indent/undent)
    ["<<"] = { "<gv", "v", { desc = "Better Undent" } },
    [">>"] = { ">gv", "v", { desc = "Better Indent" } },
    -- jump list
    ["zn"] = { function()
        vscode.call('workbench.action.navigateBack')
    end, { "n" }, { desc = "Previous Position" } },
    ["zi"] = { function()
        vscode.call('workbench.action.navigateForward')
    end, { "n" }, { desc = "Next Position" } },
    ["=="] = { function()
        vscode.call('editor.action.formatDocument')
    end, "n", { desc = "Format Document" } }
}

M.Tabs = {
    --["<leader>ti"] = { "<cmd>call VSCodeNotify('workbench.action.nextEditor')<cr>", "n", { desc = "Next Tab" } },
    ["<leader>ti"] = { function()
        vscode.call('workbench.action.nextEditor')
    end, "n", { desc = "Next Tab" } },
    --["<leader>tn"] = { "<cmd>call VSCodeNotify('workbench.action.previousEditor')<cr>", "n", { desc = "Previous Tab" } },
    ["<leader>tn"] = { function()
        vscode.call('workbench.action.previousEditor')
    end, "n", { desc = "Previous Tab" } },
    --["<leader>tI"] = { "<cmd>call VSCodeNotify('workbench.action.lastEditorInGroup')<cr>", "n", { desc = "Last Tab" } },
    ["<leader>tI"] = { function()
        vscode.call('workbench.action.lastEditorInGroup')
    end, "n", { desc = "Last Tab" } },
    --["<leader>tN"] = { "<cmd>call VSCodeNotify('workbench.action.openEditorAtIndex1')<cr>", "n", { desc = "First Tab" } },
    ["<leader>tN"] = { function()
        vscode.call('workbench.action.openEditorAtIndex1')
    end, "n", { desc = "First Tab" } },
    --["<leader>tx"] = { "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>", "n", { desc = "Close Tab" } },
    ["<leader>tx"] = { function()
        vscode.call('workbench.action.closeActiveEditor')
    end, "n", { desc = "Close Tab" } },
    --["<leader>tA"] = { "<cmd>call VSCodeNotify('workbench.action.closeAllEditors')<cr>", "n", { desc = "Close All Tabs" } },
    ["<leader>tA"] = { function()
        vscode.call('workbench.action.closeAllEditors')
    end, "n", { desc = "Close All Tabs" } },
    --["<leader>ta"] = { "<cmd>call VSCodeNotify('workbench.action.closeEditorsInGroup')<cr>", "n", { desc = "Close All Tabs In Group" } },
    ["<leader>ta"] = { function()
        vscode.call('workbench.action.closeEditorsInGroup')
    end, "n", { desc = "Close All Tabs In Group" } },
    --["<leader>to"] = { "<cmd>call VSCodeNotify('workbench.action.closeOtherEditors')<cr>", "n", { desc = "Close Other Tabs" } },
    ["<leader>to"] = { function()
        vscode.call('workbench.action.closeOtherEditors')
    end, "n", { desc = "Close Other Tabs" } },
    ["<leader>tt"] = { function()
        vscode.call('workbench.action.files.newUntitledFile')
    end, "n", { desc = "New Tab" } },
}

M.LSP = {
    ["gd"] = { function()
        vscode.call('editor.action.revealDefinition')
    end, { "n" }, { desc = "Goto Definition" } },
    ["gr"] = { function()
        vscode.call('editor.action.goToReferences')
    end, { "n" }, { desc = "Goto References" } },
    ["gi"] = { function()
        vscode.call('editor.action.goToImplementation')
    end, { "n" }, { desc = "Goto Impleementation" } },
    ["gy"] = { function()
        vscode.call('editor.action.goToTypeDefinition')
    end, { "n" }, { desc = "Goto Type Definition" } },
    ["gD"] = { function()
        vscode.call('editor.action.revealDeclaration')
    end, { "n" }, { desc = "Goto Declaration" } },
    ["<leader>h"] = { function()
        vscode.call('editor.action.showDefinitionPreviewHover')
    end, { "n" }, { desc = "Show Definition Hover" } },
    ["<leader>H"] = { function()
        vscode.call('editor.action.triggerParameterHints')
    end, { "n" }, { desc = "Trigger Parameter Hints" } },
    ["<C-k>"] = { function()
        vscode.call('editor.action.triggerParameterHints')
    end, { "i" }, { desc = "Trigger Parameter Hints (Insert Mode)" } },
    ["<leader>cr"] = { function()
        vscode.call('editor.action.rename')
    end, { "n" }, { desc = "Rename Symbols" } },
    ["<leader>ca"] = { function()
        vscode.call('editor.action.codeAction')
    end, { "n" }, { desc = "Show Code Action" } },
    ["<leader>cq"] = { function()
        vscode.call('keyboard-quickfix.openQuickFix')
    end, { "n" }, { desc = "Show QuickFix" } },
    ["<leader>cA"] = { function()
        vscode.call('editor.action.sourceAction')
    end, { "n" }, { desc = "Source Action" } },
    ["<leader>cR"] = { function()
        vscode.call('editor.action.refactor')
    end, { "n" }, { desc = "Refactor" } },
    ["<C-e>"] = { function()
        vscode.call('selectNextCodeAction')
    end, { "n" }, { desc = "Select Next Code Action" } },
    ["<C-u>"] = { function()
        vscode.call('selectPrevCodeAction')
    end, { "n" }, { desc = "Select Previous Code Action" } },
    ["<CR>"] = { function()
        vscode.call('editor.action.inlineSuggest.accept')
    end, { "n" }, { desc = "Accept Inline Suggestion" } }, -- 确认内联编辑框的修改  <CR>
}

M.CMP = {
    ["<C-e>"] = { function()
        vscode.call('selectNextSuggestion')
    end, { "i" }, { desc = "Select Next Suggestion" } },
    ["<C-u>"] = { function()
        vscode.call('selectPrevSuggestion')
    end, { "i" }, { desc = "Select Previous Suggestion" } },
    ["<S-Tab>"] = { function()
        vscode.call('jumpToPrevSnippetPlaceholder')
    end, { "i" }, { desc = "Jump To Previous Snippet Placeholder" } },
    ["<C-i>"] = { function()
        vscode.call('editor.action.triggerSuggest')
    end, { "i" }, { desc = "Trigger Suggestion" } },
}

M.Search = {
    ["<leader>/"] = { function()
        vscode.call("workbench.action.findInFiles")
    end, "n", { desc = "Vscode Find In Files" } },
    ["<leader><space>"] = { "<cmd>Find<CR>", "n", { desc = "Find Files" } },
    ["<leader>ss"] = { function()
        vscode.call("workbench.action.gotoSymbol")
    end, "n", { desc = "Search Symbol" } }
}

M.Fold = {
    ["zc"] = { function()
        vscode.call("editor.fold")
    end, "n", { desc = "Fold Block" } },
    ["zo"] = { function()
        vscode.call("editor.unfold")
    end, "n", { desc = "Unfold Block" } },
    ["za"] = { function()
        vscode.call("editor.unfoldAll")
    end, "n", { desc = "Unfold All Block" } },
    ["zm"] = { function()
        vscode.call("editor.foldAll")
    end, "n", { desc = "Fold All Block" } },
    ["ze"] = { function()
        vscode.call("editor.gotoNextFold")
    end, "n", { desc = "Goto Next Fold" } },
    ["zu"] = { function()
        vscode.call("editor.gotoPreviousFold")
    end, "n", { desc = "Goto Pervious Fold" } },
}

M.Bookmark = {
    ["]m"] = {
        function()
            vscode.call("bookmarks.jumpToNext")
        end, "n", {
        desc = "Goto Next Bookmark"
    }
    },
    ["[m"] = {
        function()
            vscode.call("bookmarks.jumpToPrevious")
        end, "n", {
        desc = "Goto Previous Bookmark"
    }
    },
    ["mm"] = {
        function()
            vscode.call("bookmarks.toggle")
        end,
        "n", { desc = "Toggle Bookmark" }
    },
    ["ma"] = {
        function()
            vscode.call("bookmarks.toggleLabeled")
        end, "n", { desc = "Toggle Labeled Bookmark" }
    },
    ["mx"] = {
        function()
            vscode.call("bookmarks.clear")
        end, "n", { desc = "Remove all bookmarks in the current file" }
    },
    ["mX"] = {
        function()
            vscode.call("bookmarks.clearFromAllFiles")
        end, "n", { desc = "Remove all bookmarks from all files" }
    },
    ["<leader>sm"] = {
        function()
            vscode.call("bookmarks.list")
        end, "n", { desc = "List all bookmarks in the current file" }
    },
    ["<leader>sM"] = {
        function()
            vscode.call("bookmarks.listFromAllFiles")
        end, "n", { desc = "List all bookmarks from all files" }
    }
}

return M
