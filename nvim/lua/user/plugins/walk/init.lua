local api = vim.api
local ts = vim.treesitter
local parsers = require('nvim-treesitter.parsers')
local ts_utils = require('nvim-treesitter.ts_utils')
-- package.loaded.hydra = nil
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

local function node_is_leaf(args)
  local node = args.node
  return node:child_count() == 0
end

local function get_first_leaf(args)
  local node = args.node
  if node_is_leaf({ node = node }) then
    return node
  end
  return get_first_leaf({ node = node:child(0) })
end

local function get_last_leaf(args)
  local node = args.node
  if node_is_leaf({ node = node }) then
    return node
  end
  return get_last_leaf({ node = node:child(node:child_count() - 1) })
end

local function node_starts_at_pos(args)
  local pos = args.pos
  local node = args.node
  local srow, scol = node:start()
  return srow == pos.row and scol == pos.col
end

local function node_starts_after_pos(args)
  local pos = args.pos
  local node = args.node
  local srow, scol = node:start()
  return srow > pos.row or (srow == pos.row and scol > pos.col)
end

local function get_last_node_at_pos(args)
  local pos = args.pos
  local node = args.node

  if node_is_leaf({ node = node }) then
    return node
  end
  local child = node:child(0)
  if node_starts_after_pos({ pos = pos, node = child }) then
    return node
  end
  node = child
  child = child:next_sibling()
  while child do
    if node_starts_after_pos({ pos = pos, node = child }) then
      return get_last_node_at_pos({ pos = pos, node = node })
    end
    node = child
    child = child:next_sibling()
  end
  return get_last_node_at_pos({ pos = pos, node = node })
end

local function walk_back(args)
  local node = args.node
  local prev_sibling = node:prev_sibling()
  if prev_sibling then
    return get_last_leaf({ node = prev_sibling })
  end
  return node:parent()
end

local function walk_forward(args)
  local node = args.node
  if not node_is_leaf({ node = node }) then
    return get_first_leaf({ node = node })
  end
  local next_sibling = node:next_sibling()
  if next_sibling then
    return next_sibling
  end
  local parent = node:parent()
  while parent do
    next_sibling = parent:next_sibling()
    if next_sibling then
      return next_sibling
    end
    node = parent
    parent = parent:parent()
  end
end

local function walk_left(args)
  local node = args.node
  return node:prev_sibling()
end

local function walk_right(args)
  local node = args.node
  return node:next_sibling()
end

local function walk_up(args)
  local node = args.node
  return node:parent()
end

local function walk_down(args)
  local node = args.node
  local child = node:child(0)
  if child then
    return child
  end
  return node:next_sibling()
end

local current_lang
local current_node

local function init_walk(args)
  if current_lang and current_node then
    vim.print('-- init using context', { lang = current_lang, node = inspect_node(current_node) })
    return current_node, current_lang
  end

  local bufnr = args.bufnr or 0
  local pos = args.pos

  local root_lang_tree = parsers.get_parser(bufnr)
  if not root_lang_tree then
    return
  end
  local root, _, lang_tree = ts_utils.get_root_for_position(pos.row, pos.col, root_lang_tree)
  if not root or not lang_tree then
    return
  end
  local node = root:descendant_for_range(pos.row, pos.col, pos.row, pos.col)
  if not node then
    return
  end
  local last_node = get_last_node_at_pos({ pos = pos, node = node })
  current_lang = lang_tree:lang()
  current_node = last_node
  return current_node, current_lang
end

local function reset_walk()
  vim.print('== reset walk')
  current_lang = nil
  current_node = nil
end

local function move_to_node_start(args)
  local node = args.node
  local line, col = node:start()
  api.nvim_win_set_cursor(0, { line + 1, col })
  current_node = node
end

local function do_walk(fn)
  local cursor = api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  local pos = { row = row, col = col }

  local node, lang = init_walk({ pos = pos })
  if not node then
    vim.print('-- node not found', { pos = pos })
    return
  end
  return fn({ pos = pos, lang = lang, node = node })
end

local function move_back(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node

  if not node_starts_at_pos({ pos = pos, node = node }) then
    vim.print('== move to start', { pos = pos, lang = lang, node = inspect_node(node) })
    move_to_node_start({ node = node })
    return
  end
  local prev = walk_back({ node = node })
  if not prev then
    vim.print('-- prev not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  vim.print('== move to prev', { pos = pos, lang = lang, node = inspect_node(node), prev = inspect_node(prev) })
  move_to_node_start({ node = prev })
end

local function move_forward(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node

  local next_ = walk_forward({ node = node })
  if not next_ then
    vim.print('-- next not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  vim.print('== move to next', { pos = pos, lang = lang, node = inspect_node(node), next_ = inspect_node(next_) })
  move_to_node_start({ node = next_ })
end

local function move_left(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node

  local prev = walk_left({ node = node })
  if not prev then
    vim.print('-- prev not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  vim.print('== move to prev', { pos = pos, lang = lang, node = inspect_node(node), prev = inspect_node(prev) })
  move_to_node_start({ node = prev })
end

local function move_right(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node

  local next_ = walk_right({ node = node })
  if not next_ then
    vim.print('-- next_ not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  vim.print('== move to next_', { pos = pos, lang = lang, node = inspect_node(node), next_ = inspect_node(next_) })
  move_to_node_start({ node = next_ })
end

local function move_up(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node

  local parent = walk_up({ node = node })
  if not parent then
    vim.print('-- parent not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  vim.print('== move to parent', { pos = pos, lang = lang, node = inspect_node(node), parent = inspect_node(parent) })
  move_to_node_start({ node = parent })
end

local function move_down(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node

  local child = walk_down({ node = node })
  if not child then
    vim.print('-- child not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  vim.print('== move to child', { pos = pos, lang = lang, node = inspect_node(node), child = inspect_node(child) })
  move_to_node_start({ node = child })
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
    { ",", function()
      do_walk(move_back)
    end, { desc = "Move to previous node" } },
    { ".", function()
      do_walk(move_forward)
    end, { desc = "Move to next node" } },
    { "<left>", function()
      do_walk(move_left)
    end, { desc = "Move to previous sibling" } },
    { "<right>", function()
      do_walk(move_right)
    end, { desc = "Move to next sibling" } },
    { "<up>", function()
      do_walk(move_up)
    end, { desc = "Move to parent" } },
    { "<down>", function()
      do_walk(move_down)
    end, { desc = "Move to first child" } },
  },
})

return M
