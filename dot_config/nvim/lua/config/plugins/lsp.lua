-- Shared LSP keymaps applied on attach for all language servers
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to Definition")
        map("gD", vim.lsp.buf.declaration, "Go to Declaration")
        map("gr", vim.lsp.buf.references, "Go to References")
        map("gi", vim.lsp.buf.implementation, "Go to Implementation")
        map("K", vim.lsp.buf.hover, "Hover Docs")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>d", vim.diagnostic.open_float, "Show Diagnostics")
    end,
})

return {

    { "neovim/nvim-lspconfig" },

    {
        "williamboman/mason.nvim",
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
        opts = {
            ensure_installed = { "clangd", "rust_analyzer", "pyright" },
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(vim.tbl_extend("force", opts, {
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,

                    ["pyright"] = function()
                        require("lspconfig").pyright.setup({
                            settings = {
                                python = {
                                    analysis = {
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                        diagnosticMode = "openFilesOnly",
                                    },
                                },
                            },
                        })
                    end,
                },
            }))
        end,
    },

    -- Basic Syntax Highlighting --
    {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "vim", "javascript", "html", "css", "rust", "cpp", "c", "python" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

}
