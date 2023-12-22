
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function(args)
    local wk = require("which-key")
    local harpoon = require("harpoon")

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
        ["="] = { "<C-w>=", "Equally high and wide" },
        ["<"] = { "<C-w><", "Decrease width" },
        [">"] = { "<C-w>>", "Increase width" },
      },
      cc = { "<cmd>gcc<cr>", "Toggle current line with linewise comment" },
      bc = { "<cmd>gbc<cr>", "Toggle current line with blocks comment"},
      cf = { "<cmd>Telescope flutter commands<cr>", "Telescope Flutter" },
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
  end
}

