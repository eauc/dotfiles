local hooks = require("ibl.hooks")

local highlight = {
    "RainbowRed",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ff4d5b" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#51b1ff" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ff9938" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#63dd0a" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d65afb" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#1ae4fe" })
end)

vim.g.rainbow_delimiters = { highlight = highlight, blacklist = {'zig'} }

require("ibl").setup({ scope = { highlight = highlight } })

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
