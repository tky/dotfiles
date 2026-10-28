-- Scala は coc ではなく nvim-metals で扱う。設定はこのバッファの中だけに効かせる
local map = vim.keymap.set

-- coc の補完と診断は、このバッファでは止める（nvim-cmp と二重にならないように）
vim.b.coc_suggest_disable = 1
vim.b.coc_diagnostic_disable = 1

vim.opt_local.completeopt = { "menuone", "noinsert", "noselect" }

map("n", "gd", vim.lsp.buf.definition, { buffer = true })

local cmp = require("cmp")
cmp.setup.buffer({
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- スニペットを使っているので select = true にできる
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-j>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<C-k>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
})

local metals_config = require("metals").bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

require("metals").initialize_or_attach(metals_config)
