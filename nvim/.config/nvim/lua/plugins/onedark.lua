local ok, desktop_colors = pcall(require, "desktop-theme")

return {
  -- One Dark theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        -- Main options --
        style = "dark", -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = true, -- Show/hide background
        term_colors = true, -- Change terminal color as per the selected theme style
        ending_tildes = false, -- Show the end-of-buffer tildes
        cmp_itemkind_reverse = false, -- Reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = "<leader>ts", -- Default keybinding to toggle
        toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

        -- Change code style ---
        code_style = {
          comments = "italic",
          keywords = "none",
          functions = "none",
          strings = "none",
          variables = "none",
        },

        -- Custom Highlights --
        colors = ok and desktop_colors or {}, -- Generated from themes/<name>/theme.conf
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
          darker = true, -- darker colors for diagnostic
          undercurl = true, -- use undercurl instead of underline for diagnostics
          background = true, -- use background color for virtual text
        },
      })

      vim.cmd([[colorscheme onedark]])
    end,
  },

  -- Configure LazyVim to use onedark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
