return {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      cmd = "LazyDev",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "LazyVim", words = { "LazyVim" } },
          { path = "snacks.nvim", words = { "Snacks" } },
          { path = "lazy.nvim", words = { "LazyVim" } },
          { path = "nvim-lspconfig", words = { "lspconfig.settings" } },
        },
      },
    },

    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            keymap = {
                preset = "enter",
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
            },
            appearance = { nerd_font_variant = "mono" },
            completion = {
                documentation = { auto_show = true },
                list = { selection = { preselect = true, auto_insert = false } },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
    },
}
