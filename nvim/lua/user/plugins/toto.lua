local api = vim.api
local ts = vim.treesitter
local parsers = require('nvim-treesitter.parsers')
local ts_utils = require('nvim-treesitter.ts_utils')
local Hydra = require('hydra')

local M = {}

function table.includes(t, v)
  for _, vv in ipairs(t) do
    if vv == v then
      return true
    end
  end
  return false
end

local function inspect_node(node)
  if not node then
    return { 'N/A' }
  end
  return {
    node:type(),
    node:named(),
    node:child_count(),
    ts.get_node_text(node, 0),
    node:range(),
  }
end

local function move_to_node_start(node)
  local line, col = node:start()
  api.nvim_win_set_cursor(0, { line + 1, col })
end

local function node_is_leaf(node)
  return node:child_count() == 0
end

local function get_first_leaf(node)
  if not node then
    return
  end
  if node_is_leaf(node) then
    return node
  end
  return get_first_leaf(node:child(0))
end

local function get_last_leaf(node)
  if not node then
    return
  end
  if node_is_leaf(node) then
    return node
  end
  return get_last_leaf(node:child(node:child_count() - 1))
end

local function get_node_at_pos(line, col)
  local root_lang_tree = parsers.get_parser(0)
  if not root_lang_tree then
    return
  end
  local root = ts_utils.get_root_for_position(line, col, root_lang_tree)
  if not root then
    return
  end
  local node = root:descendant_for_range(line, col, line, col)
  if not node then
    return
  end
  return node
end

local function node_start_after_pos(node, line, col)
  local node_start_line, node_start_col = node:start()
  return node_start_line > line or (node_start_line == line and node_start_col > col)
end

local function get_first_leaf_after_pos(node, line, col)
  if node_is_leaf(node) then
    return node
  end
  node = node:child(0)
  while node do
    if node_start_after_pos(node, line, col) then
      return get_first_leaf(node)
    end
    node = node:next_sibling()
  end
end

local function get_last_leaf_before_pos(node, line, col)
  if node_is_leaf(node) then
    return node
  end
  node = node:child(0)
  while node do
    local next_ = node:next_sibling()
    if not next_ or node_start_after_pos(next_, line, col) then
      return get_last_leaf(node)
    end
    node = next_
  end
end

local function get_next_leaf(node)
  local next_ = node:next_sibling()
  if next_ then
    return get_first_leaf(next_)
  end
  local parent = node:parent()
  if parent then
    return get_next_leaf(parent)
  end
end

local function get_previous_leaf(node)
  local prev = node:prev_sibling()
  if prev then
    return get_last_leaf(prev)
  end
  local parent = node:parent()
  if parent then
    return get_previous_leaf(parent)
  end
end

local function node_match(node, match_opts)
  local named = match_opts.named
  local type_ = match_opts.type_
  local text = match_opts.text
  return (named == nil or node:named() == named) and
      (type_ == nil or table.includes(type_, node:type())) and
      (text == nil or table.includes(text, ts.get_node_text(node, 0)))
end

local function get_next_leaf_matching(node, match_opts)
  local next_ = get_next_leaf(node)
  while next_ do
    if node_match(next_, match_opts) then
      return next_
    end
    next_ = get_next_leaf(next_)
  end
end

local function get_previous_leaf_matching(node, match_opts)
  local prev = get_previous_leaf(node)
  while prev do
    if node_match(prev, match_opts) then
      return prev
    end
    prev = get_previous_leaf(prev)
  end
end

local function move_to_next_leaf(node, line, col, match_opts)
  local leaf = get_last_leaf_before_pos(node, line, col)
  if not leaf then
    vim.print({ { line, col }, inspect_node(node), 'leaf not found' })
    return
  end
  local next_ = get_next_leaf_matching(leaf, match_opts)
  if not next_ then
    vim.print({ { line, col }, inspect_node(node), inspect_node(leaf), 'next not found' })
    return
  end
  vim.print({ { line, col }, inspect_node(node), inspect_node(leaf), inspect_node(next_), 'ok' })
  move_to_node_start(next_)
end

local function move_to_previous_leaf(node, line, col, match_opts)
  local leaf = get_first_leaf_after_pos(node, line, col)
  if not leaf then
    vim.print({ { line, col }, inspect_node(node), 'leaf not found' })
    return
  end
  local previous = get_previous_leaf_matching(leaf, match_opts)
  if not previous then
    vim.print({ { line, col }, inspect_node(node), inspect_node(leaf), 'previous not found' })
    return
  end
  vim.print({ { line, col }, inspect_node(node), inspect_node(leaf), inspect_node(previous), 'ok' })
  move_to_node_start(previous)
end

local function exec(fn)
  local cursor = api.nvim_win_get_cursor(0)
  local line = cursor[1] - 1
  local col = cursor[2]

  local node = get_node_at_pos(line, col)
  if not node then
    vim.print({ cursor, 'node not found' })
    return
  end
  return fn(node, line, col)
end

local opening_parenthesis = { "(", "{", "[", "<" }
local expression = { "function", "identifier", "string_start", "true", "false", "number" }

Hydra({
  name = "Combobulate",
  mode = 'n',
  body = 'g.',
  config = {
    invoke_on_body = true,
  },
  heads = {
    { ".", function()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, {}) end)
    end, { desc = "Move to next leaf" } },
    { ",", function()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, {}) end)
    end, { desc = "Move to previous leaf" } },
    { "[", function()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, { type_ = opening_parenthesis }) end)
    end, { desc = "Move to next opening parenthesis" } },
    { "{", function()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, { type_ = opening_parenthesis }) end)
    end, { desc = "Move to previous opening parenthesis" } },
    { "w", function()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, { type_ = expression }) end)
    end, { desc = "Move to next expression" } },
    { "b", function()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, { type_ = expression }) end)
    end, { desc = "Move to previous expression" } },
  },
})

return M
