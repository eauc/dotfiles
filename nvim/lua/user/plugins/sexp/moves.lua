local api = vim.api
local fs = require('user.plugins.sexp.forms')
local ns = require('user.plugins.sexp.nodes')
local parsers = require('nvim-treesitter.parsers')
local ts_utils = require('nvim-treesitter.ts_utils')

local inspect_node = ns.inspect_node

local M = {}

local function init_sexp_move(args)
  local bufnr = args.bufnr or 0

  local cursor = api.nvim_win_get_cursor(bufnr)
  local row = cursor[1] - 1
  local col = cursor[2]
  local pos = { row = row, col = col }

  local root_lang_tree = parsers.get_parser(bufnr)
  if not root_lang_tree then
    return
  end
  local root, _, lang_tree = ts_utils.get_root_for_position(pos.row, pos.col, root_lang_tree)
  if not root or not lang_tree then
    return
  end
  return pos, root, lang_tree:lang()
end

function M.move_to_prev_element_start()
  local pos, root, lang = init_sexp_move({})

  local prev_element = fs.get_element_starting_before_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to prev element',
    { pos = pos, lang = lang, root = inspect_node(root), prev_element = inspect_node(prev_element) })
  ts_utils.goto_node(prev_element)
end

function M.move_to_next_element_start()
  local pos, root, lang = init_sexp_move({})

  local next_element = fs.get_element_starting_after_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to next element',
    { pos = pos, lang = lang, root = inspect_node(root), next_element = inspect_node(next_element) })
  ts_utils.goto_node(next_element)
end

function M.move_to_prev_form_start()
  local pos, root, lang = init_sexp_move({})

  local prev_form = fs.get_form_starting_before_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to prev form',
    { pos = pos, lang = lang, root = inspect_node(root), prev_form = inspect_node(prev_form) })
  ts_utils.goto_node(prev_form)
end

function M.move_to_next_form_start()
  local pos, root, lang = init_sexp_move({})

  local next_form = fs.get_form_starting_after_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to next form',
    { pos = pos, lang = lang, root = inspect_node(root), next_form = inspect_node(next_form) })
  ts_utils.goto_node(next_form)
end

function M.move_to_prev_form_end()
  local pos, root, lang = init_sexp_move({})

  local prev_form = fs.get_form_ending_before_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to form end before',
    { pos = pos, lang = lang, root = inspect_node(root), prev_form = inspect_node(prev_form) })
  ts_utils.goto_node(prev_form, true)
end

function M.move_to_next_form_end()
  local pos, root, lang = init_sexp_move({})

  local next_form = fs.get_form_ending_after_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to form end after',
    { pos = pos, lang = lang, root = inspect_node(root), next_form = inspect_node(next_form) })
  ts_utils.goto_node(next_form, true)
end

function M.move_to_parent_form_start()
  local pos, root, lang = init_sexp_move({})

  local parent_form = fs.get_parent_form_at_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to parent form',
    { pos = pos, lang = lang, root = inspect_node(root), parent_form = inspect_node(parent_form) })
  ts_utils.goto_node(parent_form)
end

function M.move_to_first_element_start()
  local pos, root, lang = init_sexp_move({})

  local form_at_pos = fs.get_form_starting_at_pos({ root = root, pos = pos, lang = lang })
  local first_element = fs.get_first_element({ form = form_at_pos })
  vim.print('== move to first element',
    { pos = pos, lang = lang, root = inspect_node(root), first_element = inspect_node(first_element) })
  ts_utils.goto_node(first_element)
end

function M.move_to_next_sibling_element_start()
  local pos, root, lang = init_sexp_move({})

  local form_at_pos = fs.get_form_starting_at_pos({ root = root, pos = pos, lang = lang })
  local form
  if ns.node_start_at_pos({ node = fs.get_first_element({ form = form_at_pos }), pos = pos }) then
    form = form_at_pos
  else
    form = fs.get_parent_form_at_pos({ root = root, pos = pos, lang = lang })
  end
  local next_element = fs.get_next_sibling_element({ form = form, pos = pos })
  vim.print('== move to next sibling element',
    { pos = pos, lang = lang, root = inspect_node(root), next_element = inspect_node(next_element) })
  ts_utils.goto_node(next_element)
end

function M.move_to_prev_sibling_element_start()
  local pos, root, lang = init_sexp_move({})

  local form_at_pos = fs.get_form_starting_at_pos({ root = root, pos = pos, lang = lang })
  if ns.node_start_at_pos({ node = fs.get_first_element({ form = form_at_pos }), pos = pos }) then
    return
  end
  local parent_form = fs.get_parent_form_at_pos({ root = root, pos = pos, lang = lang })
  local prev_element = fs.get_prev_sibling_element({ form = parent_form, pos = pos })
  vim.print('== move to prev sibling element',
    { pos = pos, lang = lang, root = inspect_node(root), prev_element = inspect_node(prev_element) })
  ts_utils.goto_node(prev_element)
end

function M.move_to_current_form_begin_end()
  local pos, root, lang = init_sexp_move({})

  local form = fs.get_form_starting_at_pos({ root = root, pos = pos, lang = lang })
  if form then
    vim.print('== move to current form end',
      { pos = pos, lang = lang, root = inspect_node(root), form = inspect_node(form) })
    ts_utils.goto_node(form, true)
    return
  end
  form = fs.get_form_ending_at_pos({ root = root, pos = pos, lang = lang })
  vim.print('== move to current form start',
    { pos = pos, lang = lang, root = inspect_node(root), form = inspect_node(form) })
  ts_utils.goto_node(form, false)
end

return M
