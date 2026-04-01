return {

    {
        'neovim/nvim-lspconfig'
    },

    -- Basic Syntax Highlighting --
    {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "vim", "javascript", "html", "css", "rust", "cpp", "c" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- Rust Support --
    {
        'mrcjkb/rustaceanvim',
        version = '^8',
        lazy = false,
    }

}
