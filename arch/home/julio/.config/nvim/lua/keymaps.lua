
-- must be placed before vim.keymap.set calls
vim.g.mapleader = " "
vim.keymap.set("i", "jk", "<Esc>", {desc="Escape from insert"})

-- https://neovim.io/doc/user/lsp.html
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

