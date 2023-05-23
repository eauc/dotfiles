local ns = require('user.plugins.sexp.nodes')

local inspect_node = ns.inspect_node

local M = {}

function M.get_capture_id(args)
  local query = args.query
  local capture_name = args.capture_name
  for id, name in pairs(query.captures) do
    if (name == capture_name) then
      vim.print('-- get capture id', { capture_id = id, capture_name = capture_name })
      return id
    end
  end
end

function M.iter_captures(args, fn)
  local root = args.root
  local bufnr = args.bufnr or 0
  local start_line = args.start_line or 0
  local end_line = args.end_line or -1

  local query = args.query
  local capture_id = args.capture_id

  for id, capture in query:iter_captures(root, bufnr, start_line, end_line) do
    if id == capture_id then
      local ret = fn(capture)
      if ret then
        return ret
      end
    end
  end
end

function M.parent_capture_at_pos(args)
  local pos = args.pos
  local query = args.query

  local parent_capture
  return query.iter_captures(args, function(capture)
    if not ns.node_start_before_pos({ node = capture, pos = pos }) then
      vim.print('-- parent capture',
        { pos = args.pos, parent_capture = inspect_node(parent_capture) })
      return parent_capture
    end
    if ns.node_contains_pos({ node = capture, pos = pos }) then
      parent_capture = capture
    end
  end)
end

function M.capture_starting_at_pos(args)
  local pos = args.pos
  local query = args.query

  return query.iter_captures(args, function(capture)
    if ns.node_start_at_pos({ node = capture, pos = pos }) then
      vim.print('-- capture start at pos', { pos = args.pos, capture = inspect_node(capture) })
      return capture
    end
  end)
end

function M.capture_starting_before_pos(args)
  local pos = args.pos
  local query = args.query

  local last_capture
  return query.iter_captures(args, function(capture)
    if not ns.node_start_before_pos({ node = capture, pos = pos }) then
      vim.print('-- capture starting before',
        { pos = args.pos, last_capture = inspect_node(last_capture), capture = inspect_node(capture) })
      return last_capture
    end
    last_capture = capture
  end)
end

function M.capture_starting_after_pos(args)
  local pos = args.pos
  local query = args.query

  return query.iter_captures(args, function(capture)
    if ns.node_start_after_pos({ pos = pos, node = capture }) then
      vim.print('-- capture starting after', { pos = pos, first_capture = inspect_node(capture) })
      return capture
    end
  end)
end

function M.capture_ending_at_pos(args)
  local pos = args.pos
  local query = args.query

  return query.iter_captures(args, function(capture)
    if ns.node_end_at_pos({ node = capture, pos = pos }) then
      vim.print('-- capture end at pos', { pos = args.pos, capture = inspect_node(capture) })
      return capture
    end
  end)
end

function M.capture_ending_before_pos(args)
  local pos = args.pos
  local query = args.query

  local current_capture
  local current_end_pos
  query.iter_captures(args, function(capture)
    if ns.node_end_before_pos({ pos = pos, node = capture }) then
      local end_pos = ns.node_end_pos({ node = capture })
      if not current_capture or ns.pos_gt(end_pos, current_end_pos) then
        current_capture = capture
        current_end_pos = end_pos
      end
    end
  end)
  return current_capture
end

function M.capture_ending_after_pos(args)
  local pos = args.pos
  local query = args.query

  local current_capture
  local current_end_pos
  query.iter_captures(args, function(capture)
    if ns.node_end_after_pos({ pos = pos, node = capture }) then
      local end_pos = ns.node_end_pos({ node = capture })
      if not current_capture or ns.pos_lt(end_pos, current_end_pos) then
        current_capture = capture
        current_end_pos = end_pos
      end
    end
  end)
  return current_capture
end

return M
