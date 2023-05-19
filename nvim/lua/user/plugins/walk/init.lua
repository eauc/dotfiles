local api = vim.api
local ts = vim.treesitter
local parsers = require('nvim-treesitter.parsers')
local ts_utils = require('nvim-treesitter.ts_utils')
package.loaded.hydra = nil
local Hydra = require('hydra')

local M = {}

local function inspect_node(node)
  if not node then
    return { 'N/A' }
  end
  return {
    type = node:type(),
    named = node:named(),
    children = node:child_count(),
    text = ts.get_node_text(node, 0),
    range = { node:range() },
  }
end

local function init_node_at_pos(args)
  local bufnr = args.bufnr or 0
  local cursor = args.cursor

  local root_lang_tree = parsers.get_parser(bufnr)
  if not root_lang_tree then
    return
  end
  local root, _, lang_tree = ts_utils.get_root_for_position(cursor.line, cursor.col, root_lang_tree)
  if not root or not lang_tree then
    return
  end
  local node = root:descendant_for_range(cursor.line, cursor.col, cursor.line, cursor.col)
  if not node then
    return
  end
  return node, lang_tree:lang()
end

local function walk()
  local cursor = api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local col = cursor[2]
  cursor = { line = line, col = col }

  local node, lang = init_node_at_pos({ cursor = cursor })
  if not node then
    vim.print('-- node not found', { cursor = cursor })
    return
  end
  vim.print('== walk', { cursor = cursor, lang = lang, node = inspect_node(node) })
end

local function reset_walk()
  vim.print('== reset walk')
end

Hydra({
  name = "Walk",
  mode = 'n',
  body = 'g.',
  config = {
    invoke_on_body = true,
    on_exit = reset_walk,
  },
  heads = {
    { ".", function()
      walk()
    end, { desc = "Move to next node" } },
  },
})

return M
