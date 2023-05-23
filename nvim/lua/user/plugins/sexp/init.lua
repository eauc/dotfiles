local Hydra = require('hydra')

local M = {}

local function on_enter()
  package.loaded['user.plugins.sexp.captures'] = nil
  package.loaded['user.plugins.sexp.forms'] = nil
  package.loaded['user.plugins.sexp.langs'] = nil
  package.loaded['user.plugins.sexp.moves'] = nil
  package.loaded['user.plugins.sexp.nodes'] = nil
  vim.cmd('messages clear')
end

local function on_exit()
end

local h = Hydra({
  name = 'Sexp',
  mode = 'n',
  -- body = 'g.',
  config = {
    invoke_on_body = true,
    on_enter = on_enter,
    on_exit = on_exit,
  },
  heads = {
    { 'b', function()
      require('user.plugins.sexp.moves').move_to_prev_element_start()
    end, { desc = 'Move to prev element start' } },
    { 'w', function()
      require('user.plugins.sexp.moves').move_to_next_element_start()
    end, { desc = 'Move to next element start' } },
    { 'k', function()
      require('user.plugins.sexp.moves').move_to_parent_form_start()
    end, { desc = 'Move to parent form' } },
    { 'j', function()
      require('user.plugins.sexp.moves').move_to_first_element_start()
    end, { desc = 'Move to first element' } },
    { 'h', function()
      require('user.plugins.sexp.moves').move_to_prev_sibling_element_start()
    end, { desc = 'Move to previous sibling element' } },
    { 'l', function()
      require('user.plugins.sexp.moves').move_to_next_sibling_element_start()
    end, { desc = 'Move to next sibling element' } },
    { '[', function()
      require('user.plugins.sexp.moves').move_to_next_form_start()
    end, { desc = 'Move to next form start' } },
    { '{', function()
      require('user.plugins.sexp.moves').move_to_prev_form_start()
    end, { desc = 'Move to previous form start' } },
    { ']', function()
      require('user.plugins.sexp.moves').move_to_next_form_end()
    end, { desc = 'Move to next form end' } },
    { '}', function()
      require('user.plugins.sexp.moves').move_to_prev_form_end()
    end, { desc = 'Move to previous form end' } },
    { '%', function()
      require('user.plugins.sexp.moves').move_to_current_form_begin_end()
    end, { desc = 'Move to previous form start' } },
    { 'm', '<cmd>messages<cr>', { exit = true, desc = 'messages' } },
  },
})

function M.exec()
  h:activate()
end

return M
