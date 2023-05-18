local api = vim.api
local ts = vim.treesitter
local parsers = require('nvim-treesitter.parsers')
local ts_utils = require('nvim-treesitter.ts_utils')
local Hydra = require('hydra')

local M = {}

local function table_includes(t, v)
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

local function is_named_child(parent, node)
  local child = parent:named_child(0)
  while child do
    if child:equal(node) then
      return true
    end
    child = child:next_named_sibling()
  end
  return false
end

local function node_is_leaf(node)
  return node:child_count() == 0
end

local function node_start_at_pos(node, line, col)
  local node_start_line, node_start_col = node:start()
  return node_start_line == line and node_start_col == col
end

local function node_start_after_pos(node, line, col)
  local node_start_line, node_start_col = node:start()
  return node_start_line > line or (node_start_line == line and node_start_col >= col)
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
      (type_ == nil or table_includes(type_, node:type())) and
      (text == nil or table_includes(text, ts.get_node_text(node, 0)))
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

local function get_parent_matching(node, line, col, match_opts)
  local parent = node:parent()
  if not parent then
    return
  end
  if node_match(parent, match_opts) then
    return parent
  end
  return get_parent_matching(parent, line, col, match_opts)
end

local function get_next_named_child(node, line, col)
  local child = node:named_child(0)
  while child do
    if node_start_after_pos(child, line, col) then
      return child
    end
    child = child:next_named_sibling()
  end
end

local function get_prev_named_child(node, line, col)
  local prev
  local child = node:named_child(0)
  while child do
    if node_start_at_pos(child, line, col) then
      return child
    end
    if node_start_after_pos(child, line, col) then
      return prev
    end
    prev = child
    child = child:next_named_sibling()
  end
  return prev
end

local sexp = {
  "table_constructor",
  "arguments",
  "parameters",
  "block",
  "if_statement",
  "for_statement",
  "while_statement",
  "function_declaration",
}

local function reset_sexp()
  M._parent_sexp = nil
  M._element = nil
end

local function init_sexp(node, line, col, get_element)
  M._parent_sexp = M._parent_sexp or get_parent_matching(node, line, col, { type_ = sexp })
  if not M._parent_sexp then
    vim.print({ { line, col }, inspect_node(node), 'init sexp to root' })
    M._parent_sexp = node:tree():root()
  end
  M._element = M._element or get_element(M._parent_sexp, line, col)
  vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(M._element), 'init sexp' })
end

local function move_to_previous_sibling(node, line, col)
  init_sexp(node, line, col, get_next_named_child)
  if not M._parent_sexp then
    return
  end
  local prev
  if M._element then
    prev = M._element:prev_named_sibling()
  else
    prev = M._parent_sexp:named_child(M._parent_sexp:named_child_count() - 1)
  end
  if not prev then
    vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(M._element),
      'prev not found' })
    return
  end
  vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(M._element),
    inspect_node(prev), 'ok' })
  M._element = prev
  move_to_node_start(prev)
end

local function move_to_next_sibling(node, line, col)
  init_sexp(node, line, col, get_prev_named_child)
  if not M._parent_sexp then
    return
  end
  local next_
  if M._element then
    next_ = M._element:next_named_sibling()
  else
    next_ = M._parent_sexp:named_child(0)
  end
  if not next_ then
    vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(M._element),
      'next_ not found' })
    return
  end
  vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(M._element),
    inspect_node(next_),
    'ok' })
  M._element = next_
  move_to_node_start(next_)
end

local function move_to_parent_sexp(node, line, col)
  init_sexp(node, line, col, get_prev_named_child)
  if not M._parent_sexp then
    return
  end
  if not node_start_at_pos(M._parent_sexp, line, col) then
    vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), 'move to current parent_sexp' })
    M._element = nil
    move_to_node_start(M._parent_sexp)
    return
  end
  local up = get_parent_matching(M._parent_sexp, line, col, { type_ = sexp })
  if not up then
    up = node:tree():root()
  end
  if is_named_child(up, M._parent_sexp) then
    vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(up), 'no move is child' })
    M._element = M._parent_sexp
    M._parent_sexp = up
    return
  end
  vim.print({ { line, col }, inspect_node(node), inspect_node(M._parent_sexp), inspect_node(up), 'ok' })
  M._parent_sexp = up
  M._element = nil
  move_to_node_start(up)
end

local function enter_sexp_at_cursor(node, line, col)
  local new_sexp = get_parent_matching(node, line, col, { type_ = sexp })
  if not new_sexp then
    vim.print({ { line, col }, inspect_node(node), 'parent sexp not found' })
    return
  end
  if not node_start_at_pos(new_sexp, line, col) then
    vim.print({ { line, col }, inspect_node(node), inspect_node(new_sexp), 'not on sexp start' })
    return
  end
  local element = new_sexp:named_child(0)
  if not element then
    vim.print({ { line, col }, inspect_node(node), inspect_node(new_sexp), 'first element not found' })
    return
  end
  vim.print({ { line, col }, inspect_node(node), inspect_node(new_sexp), inspect_node(element), 'ok' })
  M._parent_sexp = new_sexp
  M._element = element
  move_to_node_start(element)
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
local closing_parenthesis = { ")", "}", "]", ">" }
local expression = { "function", "identifier", "string_start", "true", "false", "number" }

Hydra({
  name = "Combobulate",
  mode = 'n',
  body = 'g.',
  config = {
    invoke_on_body = true,
    on_exit = reset_sexp,
  },
  heads = {
    { "h", function()
      exec(function(node, line, col) move_to_previous_sibling(node, line, col) end)
    end, { desc = "Move to previous sibling" } },
    { "l", function()
      exec(function(node, line, col) move_to_next_sibling(node, line, col) end)
    end, { desc = "Move to next sibling" } },
    { "k", function()
      exec(function(node, line, col) move_to_parent_sexp(node, line, col) end)
    end, { desc = "Move to parent sexp" } },
    { "j", function()
      exec(function(node, line, col) enter_sexp_at_cursor(node, line, col) end)
    end, { desc = "Enter sexp under cursor" } },
    { ".", function()
      reset_sexp()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, {}) end)
    end, { desc = "Move to next leaf" } },
    { ",", function()
      reset_sexp()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, {}) end)
    end, { desc = "Move to previous leaf" } },
    { "[", function()
      reset_sexp()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, { type_ = opening_parenthesis }) end)
    end, { desc = "Move to next opening parenthesis" } },
    { "{", function()
      reset_sexp()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, { type_ = opening_parenthesis }) end)
    end, { desc = "Move to previous opening parenthesis" } },
    { "]", function()
      reset_sexp()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, { type_ = closing_parenthesis }) end)
    end, { desc = "Move to next opening parenthesis" } },
    { "}", function()
      reset_sexp()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, { type_ = closing_parenthesis }) end)
    end, { desc = "Move to previous opening parenthesis" } },
    { "w", function()
      reset_sexp()
      exec(function(node, line, col) move_to_next_leaf(node, line, col, { type_ = expression }) end)
    end, { desc = "Move to next expression" } },
    { "b", function()
      reset_sexp()
      exec(function(node, line, col) move_to_previous_leaf(node, line, col, { type_ = expression }) end)
    end, { desc = "Move to previous expression" } },
  },
})

return M
