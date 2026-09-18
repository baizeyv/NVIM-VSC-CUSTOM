-- npm install -g tree-sitter-cli
return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    cmd = {"TSUpdate", "TSInstall", "TSLog", "TSUninstall"},
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
            event = "VeryLazy"
        }
    },
    opts = {
        indent = {enable = true},
        highlight = {enable = true},
        folds = {enable = true},
        ensure_installed = {
            "bash", "c_sharp", "c", "diff", "html", "javascript", "jsdoc",
            "json", "lua", "luadoc", "luap", "markdown", "markdown_inline",
            "printf", "python", "query", "regex", "toml", "tsx", "typescript",
            "vim", "vimdoc", "xml", "yaml"
        },
        install_dir = vim.fn.stdpath("data") .. "/treesitter"
    },
    config = function(_, opts)
        local tree = require("nvim-treesitter")
        -- 全局让 git 和 curl 下载走镜像代理
        -- （也可以仅针对 treesitter 设置）
        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.install").command_extra_args = {
            curl = {"--proxy", "http://127.0.0.1:7890"} -- 让 treesitter 内置下载直接走 Clash
        }
        tree.setup(opts)
        tree.install(opts.ensure_installed, {summary = true})
    end
}
