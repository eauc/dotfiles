local cs = require('user.plugins.sexp.captures')
local q = vim.treesitter.query

local lang_definitions = {
  lua = {
    queries = {
      form = { 'parenthesized_expression', 'table_constructor', 'block', 'parameters', 'arguments' }
    }
  }
}

local M = {}

function M.form_query(args)
  local lang = args.lang
  local query_string = '[(' .. table.concat(lang_definitions[lang].queries.form, ') (') .. ')] @form'
  vim.print('-- form query string', { query_string = query_string })
  local query = q.parse(lang, query_string)
  local capture_id = cs.get_capture_id({ query = query, capture_name = 'form' })
  return {
    iter_captures = function(args, fn)
      return cs.iter_captures(vim.tbl_extend('force', args, { query = query, capture_id = capture_id }), fn)
    end
  }
end

function M.element_query(args)
  local lang = args.lang
  local query_string = '((_) @element (#has-parent? @element ' ..
  table.concat(lang_definitions[lang].queries.form, ' ') .. '))'
  vim.print('-- element query_string', { query_string = query_string })
  local query = q.parse(lang, query_string)
  local capture_id = cs.get_capture_id({ query = query, capture_name = 'element' })
  return {
    iter_captures = function(args, fn)
      return cs.iter_captures(vim.tbl_extend('force', args, { query = query, capture_id = capture_id }), fn)
    end
  }
end

return M
