
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-lua/plenary.nvim",
    "BurntSushi/ripgrep",
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  opts = {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
},
  config = function(args)
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('flutter')
  end,
}
