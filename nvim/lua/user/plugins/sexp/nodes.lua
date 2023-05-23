local ts = vim.treesitter

local M = {}

function M.inspect_node(node)
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

function M.pos_gt(a, b)
  return a.row > b.row or (a.row == b.row and a.col > b.col)
end

function M.pos_lt(a, b)
  return a.row < b.row or (a.row == b.row and a.col < b.col)
end

function M.node_end_pos(args)
  local node = args.node
  local row, col = node:end_()
  return { row = row, col = col }
end

function M.node_start_before_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local srow, scol = node:start()
  return srow < pos.row or (srow == pos.row and scol < pos.col)
end

function M.node_start_at_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local srow, scol = node:start()
  return srow == pos.row and scol == pos.col
end

function M.node_start_after_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local srow, scol = node:start()
  return srow > pos.row or (srow == pos.row and scol > pos.col)
end

function M.node_end_before_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local erow, ecol = node:end_()
  return erow < pos.row or (erow == pos.row and ecol < pos.col + 1)
end

function M.node_end_at_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local erow, ecol = node:end_()
  return erow == pos.row and ecol == pos.col + 1
end

function M.node_end_after_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local erow, ecol = node:end_()
  return erow > pos.row or (erow == pos.row and ecol > pos.col + 1)
end

function M.node_contains_pos(args)
  local node = args.node
  if not node then return false end

  local pos = args.pos
  local srow, scol, erow, ecol = node:range()
  return (srow < pos.row or (srow == pos.row and scol <= pos.col)) and
      (erow > pos.row or (erow == pos.row and ecol >= pos.col))
end

return M
