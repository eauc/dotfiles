local parpar = require("parpar")

-- vim.g.codeium_manual = true
vim.g.codeium_disable_bindings = 1

vim.g.codeium_filetypes = {
  clojure = false,
}

local accept = function()
  -- pause paredit/parinfer curing codeium completion
  vim.schedule(parpar.pause())
  return vim.fn["codeium#Accept"]()
end

vim.keymap.set('i', '<A-->', accept, { expr = true })
vim.keymap.set('i', '<A-=>', accept, { expr = true })
vim.keymap.set('i', '<A-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
vim.keymap.set('i', '<A-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
vim.keymap.set('i', '<A-g>', function() return vim.fn['codeium#Clear']() end, { expr = true })
