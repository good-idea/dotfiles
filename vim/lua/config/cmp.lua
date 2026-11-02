vim.o.completeopt = "menuone,noselect"
local cmp = require "cmp"
local luasnip = require "luasnip"

-- Configure LSP capabilities for all servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = capabilities })

-- Check if there are words before cursor (for Tab completion)
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  completion = {},
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" })
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        buffer = "[Buff]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]"
      })[entry.source.name]
      return vim_item
    end
  },
  sources = {
    { name = "nvim_lsp", max_item_count = 4 },
    { name = "buffer", keyword_length = 1, max_item_count = 4 },
    { name = "luasnip", max_item_count = 3 },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "calc" }
  },
  experimental = {
    ghost_text = true
  }
})

-- Keep completion available on demand without suggesting words while writing prose.
cmp.setup.filetype('markdown', {
  completion = { autocomplete = false },
})
