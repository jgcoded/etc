
return {
  "ggandor/leap.nvim",
  dependencies = {
    "tpope/vim-repeat"
  },
  config = function(args)
    require("leap").add_default_mappings(true)
  end
}

