
-- must be placed before vim.keymap.set calls
vim.g.mapleader = ";"

vim.wo.relativenumber = true


-- plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	--  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
},
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "L3MON4d3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "nvim-lua/plenary.nvim",
  "BurntSushi/ripgrep",
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
     dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end
},
{
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    },
    lazy = false,
},
{
 "folke/trouble.nvim",
 dependencies = { "nvim-tree/nvim-web-devicons" },
 opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 },
 },
{
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
},
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
},
{
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts) require'lsp_signature'.setup(opts) end
},
  { "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat"
    }
  },
  {
    "ThePrimeagen/harpoon", branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
{
  "rmagatti/auto-session",
  opts = {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Downloads", "/"},
  }
},
})
require('leap').add_default_mappings(true)
--require("catppuccin").setup({
 -- flavour = "macchiato", -- latte, frappe, macchiato, mocha
--})

--vim.cmd.colorscheme "catppuccin"

vim.cmd[[colorscheme tokyonight-moon]]

require('lualine').setup()

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local harpoon = require("harpoon")
harpoon:setup()

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }

local wk = require("which-key")

-- whichkey also comes build in with features when you press:
-- Shows a list of your buffer local and global marks when you hit ` or '
-- Shows a list of your buffer local and global registers when you hit " in NORMAL mode, or <c-r> in INSERT mode.
wk.register({
  f = {
    name = "+find", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" }, -- additional options for creating the keymap
    g = { "<cmd>Telescope live_grep<cr>", "Grep Files" },
    b = { "<cmd>Telescope buffers<cr>", "Buffers" },
    h = { "<cmd>Telescope help_tags<cr>", "Help" },
    d = { "<cmd>Telescope lsp_definitions jump_type=vsplit<cr>", "Symbol Definition"},
    D = { "<cmd>Telescope lsp_type_definitions jump_type=vsplit<cr>", "Symbol Type Definition"},
    i = { "<cmd>Telescope lsp_implementations jump_type=vsplit<cr>", "Symbol Implmentation"},
    w = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
    W = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"},
    c = { "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming Calls"},
    C = { "<cmd>Telescope lsp_outgoing_calls<cr>", "Outgoing Calls"},
    p = { "<cmd>Telescope diagnostics<cr>", "Diagnostics"},
    t = { "<cmd>Telescope treesitter<cr>", "Treesitter"},
  },
  t = {
    name = "+trouble",
    x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble List"},
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Toggle Trouble Workspace Diagnostics"},
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Toggle Trouble Document Diagnostics"},
    q = { "<cmd>TroubleToggle quickfix<cr>", "Trouble quickfix"},
    l = { "<cmd>TroubleToggle loclist<cr>", "Trouble loclist"},
    t = { "<cmd>TodoTrouble<cr>", "Open TODO list with Trouble"}
  },
  w = {
    name = "+window",
    h = { "<cmd>split<cr>", "Split horizontally" },
    v = { "<cmd>vsplit<cr>", "Split vertically" },
  },
  cc = { "<cmd>gcc<cr>", "Toggle current line with linewise comment" },
  bc = { "<cmd>gbc<cr>", "Toggle current line with blocks comment"},
  s = { "<Plug>(leap-forward-to)", "Leap search forward" },
  S = { "<Plug>(leap-backward-to)", "Leap search backward" },
  gs = { "<Plug>(leap-from-window)", "Leap search windows" },
  r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"},
  q = { "<cmd>q<cr>", "Quit :q" },
  h = { "<C-W>h", "Focus Window Left" },
  j = { "<C-W>j", "Focus Window Down" },
  k = { "<C-W>k", "Focus Window Up" },
  l = { "<C-W>l", "Focus Window Right" },
  a = { function() harpoon:list():append() end, "Append to harpoon" },
  m = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Toggle quick menu"},
  ["1"] = { function() harpoon:list():select(1) end, "Goto first entry"},
  ["2"] = { function() harpoon:list():select(2) end, "Goto second entry"},
  ["3"] = { function() harpoon:list():select(3) end, "Goto third entry"},
  ["4"] = { function() harpoon:list():select(4) end, "Goto fourth entry"},
  x = { "<cmd>xall<cr>", "Exit"}
  }, { prefix = "<leader>" })
  
wk.register({
  ["<Tab>"] = { "<cmd>Neotree toggle<cr>", "Open cwd in Neotree"},
})
vim.keymap.set("i", "jk", "<Esc>", {desc="Escape from insert"})
--vim.keymap.set("n", "<leader>q", ":q<cr>")
-- https://neovim.io/doc/user/lsp.html
--
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc="Open hover window" })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = args.buf, desc="Find references" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc="Goto definition" })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = args.buf, desc="Goto declaration"})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = args.buf, desc="Goto implementation" })
    vim.keymap.set({'n','v'}, '<C-k>', vim.lsp.buf.code_action, { buffer = args.buf, desc="Perform code action" })
    --vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = args.buf, desc="Rename symbol"})
    vim.keymap.set('n', '<leader>fd', vim.lsp.buf.format, { buffer = args.buf, desc="Format document"})
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({border="single"})<cr>', {buffer=args.buf, desc="Goto prev diagnostic"})
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next({border="single"})<cr>', {buffer=args.buf, desc="Goto next diagnostic"})
  end,
})

require('Comment').setup()

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      --{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

-- https://neovim.io/doc/user/lsp.html
-- Rust LSP
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').rust_analyzer.setup({
  capabilities = capabilities
})

  require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "rounded"
    }
  })

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

