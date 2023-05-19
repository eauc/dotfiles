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

local function node_is_root(args)
  local node = args.node
  return not node:parent()
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

local lang_match_opts = {
  lua = {
    opening_sexp = {
      { type_ = { "arguments", "parameters", "parenthesized_expression", "table_constructor", "block" } },
      { root = true },
    },
    closing_sexp = {
      { type_ = { ")", "}", "]" } },
    },
    word = {
      { type_ = { 'string_start' } },
      {
        leaf = true,
        not_type = { "(", "{", "[", ")", "}", "]", ".", ",", ":", ";", "'", '"', "`",
          "string_content", "string_end", "comment" }
      },
    },
  },
  javascript = {
    opening_sexp = {
      {
        type_ = { "arguments", "formal_parameters", "parenthesized_expression", "statement_block", "object",
          "object_pattern", "array", "array_pattern" }
      },
      { root = true },
    },
    closing_sexp = {
      { type_ = { ")", "}", "]" } },
    },
    word = {
      { type_ = { "string" } },
      {
        leaf = true,
        not_type = { "(", "{", "[", ")", "}", "]", ".", ",", ":", ";", "'", '"', "`",
          "string_fragment", "comment" }
      },
    },
  },
  clojure = {
    opening_sexp = {
      { type_ = { "list_lit", "map_lit", "set_lit", "vec_lit" } },
      { root = true },
    },
    closing_sexp = {
      { type_ = { ")", "}", "]" } }
    },
    word = {
      { type_ = { "sym_lit", "str_lit", "kwd_lit", "number_lit", "bool_lit", "nil_lit" } },
    },
  },
}

local function node_matches(args)
  local node = args.node
  local match_opts = args.match_opts

  return vim.tbl_isempty(match_opts) or not vim.tbl_isempty(
    vim.tbl_filter(
      function(opts)
        local named = opts.named
        local root = opts.root
        local leaf = opts.leaf
        local type_ = opts.type_
        local not_type = opts.not_type
        return (named == nil or named == node:named()) and
            (root == nil or root == node_is_root({ node = node })) and
            (leaf == nil or leaf == node_is_leaf({ node = node })) and
            (type_ == nil or vim.tbl_contains(type_, node:type())) and
            (not_type == nil or not vim.tbl_contains(not_type, node:type()))
      end,
      match_opts
    )
  )
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
    return node:child(0)
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

local walk_fns = {
  back = walk_back,
  forward = walk_forward,
  left = walk_left,
  right = walk_right,
  up = walk_up,
  down = walk_down,
}

local function walk_to_matching(args)
  local node = args.node
  local pos = args.pos
  local match_opts = args.match_opts
  local direction = args.direction
  local walk_fn = walk_fns[direction]

  local next_
  if vim.tbl_contains({ 'back', 'left' }, direction) and not node_starts_at_pos({ pos = pos, node = node }) then
    next_ = node
  else
    next_ = walk_fn({ node = node })
  end
  while next_ do
    if node_matches({ node = next_, match_opts = match_opts }) then
      return next_
    end
    next_ = walk_fn({ node = next_ })
  end
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
  return fn({ pos = pos, lang = lang, node = node, match_opts = lang_match_opts[lang] })
end

local function move_to_matching(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node
  local direction = args.direction
  local match_opts = args.match_opts

  local matching = walk_to_matching({ node = node, pos = pos, direction = direction, match_opts = match_opts })
  if not matching then
    vim.print('-- matching not found',
      { pos = pos, lang = lang, direction = direction, match_opts = match_opts, node = inspect_node(node) })
    return
  end
  vim.print('== move to matching',
    {
      pos = pos,
      lang = lang,
      direction = direction,
      match_opts = match_opts,
      node = inspect_node(node),
      matching = inspect_node(matching)
    })
  move_to_node_start({ node = matching })
end

local function get_last_element_at_pos(args)
  local pos = args.pos
  local sexp = args.sexp

  if node_is_leaf({ node = sexp }) then
    return
  end
  local child = sexp:named_child(0)
  if not child or node_starts_after_pos({ pos = pos, node = child }) then
    return
  end
  local element = child
  child = child:next_sibling()
  while child do
    if node_starts_after_pos({ pos = pos, node = child }) then
      return element
    end
    element = child
    child = child:next_sibling()
  end
  return element
end

local function init_sexp_walk(args)
  local pos = args.pos
  local node = args.node
  local match_opts = args.match_opts

  local sexp
  if node_matches({ node = node, match_opts = match_opts.opening_sexp }) then
    sexp = node
  else
    sexp = walk_to_matching({ node = node, direction = "up", match_opts = match_opts.opening_sexp })
  end
  vim.print('-- init sexp walk', { node = inspect_node(node), sexp = inspect_node(sexp) })
  if not sexp then
    return
  end
  local element = get_last_element_at_pos({ pos = pos, sexp = sexp })
  vim.print('-- init sexp walk', { element = inspect_node(element) })
  return sexp, element
end

local function walk_to_prev_element(args)
  local pos = args.pos
  local sexp = args.sexp
  local element = args.element
  local match_opts = args.match_opts

  if node_starts_at_pos({ pos = pos, node = sexp }) then
    local parent_sexp, parent_element = init_sexp_walk({ pos = pos, node = sexp:parent(), match_opts = match_opts })
    return walk_to_prev_element({ pos = pos, sexp = parent_sexp, element = parent_element, match_opts = match_opts })
  end
  if not element then
    return sexp:named_child(0)
  end
  if not node_starts_at_pos({ pos = pos, node = element }) then
    return element
  end
  return element:prev_named_sibling()
end

local function walk_to_next_element(args)
  local pos = args.pos
  local sexp = args.sexp
  local element = args.element
  local match_opts = args.match_opts

  if node_starts_at_pos({ pos = pos, node = sexp }) then
    local parent_sexp, parent_element = init_sexp_walk({ pos = pos, node = sexp:parent(), match_opts = match_opts })
    return walk_to_next_element({ pos = pos, sexp = parent_sexp, element = parent_element, match_opts = match_opts })
  end
  if not element then
    return sexp:named_child(0)
  end
  return element:next_named_sibling()
end

local function walk_to_parent_sexp(args)
  local pos = args.pos
  local sexp = args.sexp
  local match_opts = args.match_opts

  if node_starts_at_pos({ pos = pos, node = sexp }) then
    return walk_to_matching({ node = sexp, direction = "up", match_opts = match_opts.opening_sexp })
  end
  return sexp
end

local function walk_to_sexp_child(args)
  local pos = args.pos
  local sexp = args.sexp
  local element = args.element
  local match_opts = args.match_opts

  if sexp and not element then
    return sexp:named_child(0)
  end
  while element and node_starts_at_pos({ pos = pos, node = element }) do
    if node_matches({ node = element, match_opts = match_opts.opening_sexp }) then
      return element:named_child(0)
    end
    element = element:named_child(0)
  end
end

local walk_sexp_fns = {
  left = walk_to_prev_element,
  right = walk_to_next_element,
  up = walk_to_parent_sexp,
  down = walk_to_sexp_child,
}

local function move_sexp(args)
  local pos = args.pos
  local lang = args.lang
  local node = args.node
  local direction = args.direction
  local match_opts = args.match_opts

  local sexp, element = init_sexp_walk(args)
  if not sexp then
    vim.print('-- parent sexp not found', { pos = pos, lang = lang, node = inspect_node(node) })
    return
  end
  local target = walk_sexp_fns[direction]({
    pos = pos,
    lang = lang,
    node = node,
    sexp = sexp,
    element = element,
    match_opts = match_opts
  })
  if not target then
    vim.print('-- target element not found',
      {
        pos = pos,
        lang = lang,
        direction = direction,
        node = inspect_node(node),
        sexp = inspect_node(sexp),
        element = inspect_node(element)
      })
    return
  end
  vim.print('== move to target element',
    {
      pos = pos,
      lang = lang,
      direction = direction,
      node = inspect_node(node),
      sexp = inspect_node(sexp),
      element = inspect_node(element),
      target = inspect_node(target)
    })
  move_to_node_start({ node = target })
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
      do_walk(function(args)
        return move_to_matching(vim.tbl_extend("keep", { direction = "back", match_opts = {} }, args))
      end)
    end, { desc = "Move to previous node" } },
    { ".", function()
      do_walk(function(args)
        return move_to_matching(vim.tbl_extend("keep", { direction = "forward", match_opts = {} }, args))
      end)
    end, { desc = "Move to next node" } },
    { "<left>", function()
      do_walk(function(args)
        return move_to_matching(vim.tbl_extend("keep", { direction = "left", match_opts = {} }, args))
      end)
    end, { desc = "Move to previous sibling" } },
    { "<right>", function()
      do_walk(function(args)
        return move_to_matching(vim.tbl_extend("keep", { direction = "right", match_opts = {} }, args))
      end)
    end, { desc = "Move to next sibling" } },
    { "<up>", function()
      do_walk(function(args)
        return move_to_matching(vim.tbl_extend("keep", { direction = "up", match_opts = {} }, args))
      end)
    end, { desc = "Move to parent" } },
    { "<down>", function()
      do_walk(function(args)
        return move_to_matching(vim.tbl_extend("keep", { direction = "down", match_opts = {} }, args))
      end)
    end, { desc = "Move to first child" } },
    { "[", function()
      do_walk(function(args)
        local match_opts = args.match_opts
        return move_to_matching(vim.tbl_extend("keep",
          { direction = "forward", match_opts = match_opts.opening_sexp }, args))
      end)
    end, { desc = "Move to next opening sexp" } },
    { "{", function()
      do_walk(function(args)
        local match_opts = args.match_opts
        return move_to_matching(vim.tbl_extend("keep",
          { direction = "back", match_opts = match_opts.opening_sexp }, args))
      end)
    end, { desc = "Move to next opening sexp" } },
    { "]", function()
      do_walk(function(args)
        local match_opts = args.match_opts
        return move_to_matching(vim.tbl_extend("keep",
          { direction = "forward", match_opts = match_opts.closing_sexp }, args))
      end)
    end, { desc = "Move to next closing sexp" } },
    { "}", function()
      do_walk(function(args)
        local match_opts = args.match_opts
        return move_to_matching(vim.tbl_extend("keep",
          { direction = "back", match_opts = match_opts.closing_sexp }, args))
      end)
    end, { desc = "Move to next closing sexp" } },
    { "w", function()
      do_walk(function(args)
        local match_opts = args.match_opts
        return move_to_matching(vim.tbl_extend("keep",
          { direction = "forward", match_opts = match_opts.word }, args))
      end)
    end, { desc = "Move to first child" } },
    { "b", function()
      do_walk(function(args)
        local match_opts = args.match_opts
        return move_to_matching(vim.tbl_extend("keep",
          { direction = "back", match_opts = match_opts.word }, args))
      end)
    end, { desc = "Move to first child" } },
    { "h", function()
      do_walk(function(args)
        return move_sexp(vim.tbl_extend("keep", { direction = "left" }, args))
      end)
    end, { desc = "Move to previous sexp element" } },
    { "j", function()
      do_walk(function(args)
        return move_sexp(vim.tbl_extend("keep", { direction = "down" }, args))
      end)
    end, { desc = "Move to firt element of sexp" } },
    { "k", function()
      do_walk(function(args)
        return move_sexp(vim.tbl_extend("keep", { direction = "up" }, args))
      end)
    end, { desc = "Move to parent sexp" } },
    { "l", function()
      do_walk(function(args)
        return move_sexp(vim.tbl_extend("keep", { direction = "right" }, args))
      end)
    end, { desc = "Move to previous sexp element" } },
  },
})

return M
