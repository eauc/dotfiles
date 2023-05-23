local cs = require('user.plugins.sexp.captures')
local ls = require('user.plugins.sexp.langs')
local ns = require('user.plugins.sexp.nodes')

local M = {}

function M.get_first_element(args)
  local form = args.form
  return form and form:named_child(0)
end

function M.get_parent_form_at_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.parent_capture_at_pos({
        root = root,
        pos = pos,
        query = ls.form_query({ lang = lang }),
      }) or root
end

function M.get_form_starting_at_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_starting_at_pos({
    root = root,
    pos = pos,
    query = ls.form_query({ lang = lang }),
  })
end

function M.get_form_starting_before_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_starting_before_pos({
        root = root,
        pos = pos,
        query = ls.form_query({ lang = lang }),
      }) or root
end

function M.get_form_starting_after_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_starting_after_pos({
    root = root,
    pos = pos,
    query = ls.form_query({ lang = lang }),
  })
end

function M.get_form_ending_at_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_ending_at_pos({
    root = root,
    pos = pos,
    query = ls.form_query({ lang = lang }),
  })
end

function M.get_form_ending_before_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_ending_before_pos({
        root = root,
        pos = pos,
        query = ls.form_query({ lang = lang }),
      }) or root
end

function M.get_form_ending_after_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_ending_after_pos({
    root = root,
    pos = pos,
    query = ls.form_query({ lang = lang }),
  })
end

function M.get_element_starting_before_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_starting_before_pos({
    root = root,
    pos = pos,
    query = ls.element_query({ lang = lang }),
  })
end

function M.get_element_starting_after_pos(args)
  local lang = args.lang
  local root = args.root
  local pos = args.pos

  return cs.capture_starting_after_pos({
    root = root,
    pos = pos,
    query = ls.element_query({ lang = lang }),
  })
end

function M.get_prev_sibling_element(args)
  local form = args.form
  local pos = args.pos

  local prev_element
  local element = M.get_first_element({ form = form })
  while element do
    if not ns.node_start_before_pos({ node = element, pos = pos }) then
      return prev_element
    end
    prev_element = element
    element = element:next_named_sibling()
  end
end

function M.get_next_sibling_element(args)
  local form = args.form
  local pos = args.pos

  local element = M.get_first_element({ form = form})
  while element do
    if ns.node_start_after_pos({ node = element, pos = pos }) then
      return element
    end
    element = element:next_named_sibling()
  end
end

return M
