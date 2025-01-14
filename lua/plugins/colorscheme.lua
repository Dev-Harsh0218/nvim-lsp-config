return {
  -- Kanagawa colorscheme
  "rebelot/kanagawa.nvim",
  lazy = false,  -- Load immediately (no lazy loading)
  priority = 1000,  -- High priority to load it early
  config = function()
    -- Apply the Kanagawa colorscheme directly
    vim.cmd("colorscheme kanagawa")
    gutter =false
    -- Optional additional configurations
    vim.g.kanagawa_style = "dragon"  -- Set style (wave, lotus, dragon, etc.)
    vim.g.kanagawa_transparent_background = true  -- Enable transparent background
    vim.g.kanagawa_enable_bold = true  -- Enable bold text
    vim.g.kanagawa_underline_comment = true  -- Underline comments
  end
}

