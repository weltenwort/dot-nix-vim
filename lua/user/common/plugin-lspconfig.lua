-- efficient filetype fallback
local old_ft_fallback = require('lze').h.lsp.get_ft_fallback()
local new_ft_fallback = function(name)
  local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    if not ok then
      ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end
require('lze').h.lsp.set_ft_fallback(new_ft_fallback)

-- buffer-local lsp mappings
local on_attach_lsp = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>cn', vim.lsp.buf.rename, 'rename symbol')
  nmap('<leader>ca', vim.lsp.buf.code_action, 'show code actions')
  nmap('<leader>cd', vim.lsp.buf.definition, 'go to definition')
  nmap('<leader>ct', vim.lsp.buf.type_definition, 'go to type definition')

  nmap('<leader>cr', function() require('telescope.builtin').lsp_references() end, 'list references')
  nmap('<leader>ci', function() require('telescope.builtin').lsp_implementations() end, 'list implementations')
  nmap('<leader>cs', function() require('telescope.builtin').lsp_document_symbols() end, 'list symbols in file')
  nmap('<leader>cS', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, 'list symbols in workspace')
  nmap('<leader>cD', function() require('telescope.builtin').diagnostics() end, 'list diagnostics')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

-- lspconfig
require('lze').load({
  "nvim-lspconfig",
  lsp = function(plugin)
    vim.lsp.config(plugin.name, plugin.lsp or {})
    vim.lsp.enable(plugin.name)
  end,
  before = function(plugin)
    vim.lsp.config('*', {
      on_attach = on_attach_lsp,
    })
  end,
})
