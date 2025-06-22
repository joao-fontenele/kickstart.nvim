local lspconfig = require 'lspconfig'

lspconfig.solargraph.setup {
  settings = {
    solargraph = {
      commandPath = '/home/jp/.asdf/shims/solargraph',
    },
  },
}

return {}
