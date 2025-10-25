vim.lsp.config('solargraph', {
  cmd = { '/home/jp/.asdf/shims/solargraph', 'stdio' },
})

vim.lsp.enable('solargraph')

return {}
