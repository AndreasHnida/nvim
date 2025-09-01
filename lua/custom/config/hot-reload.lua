-- lua/custom/config/hot-reload.lua
--
-- Watches lua/custom/**/*.lua and reloads them on save.
-- Adds <leader>rr to trigger a manual reload.

local M = {}

local function unload(module)
  package.loaded[module] = nil
  _G[module] = nil
end

function M.reload_all()
  for name, _ in pairs(package.loaded) do
    if name:match '^custom' then
      unload(name)
    end
  end

  vim.notify('🔄 Custom config reloaded', vim.log.levels.INFO, { title = 'hot-reload' })
end

function M.setup()
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'lua/custom/**/*.lua',
    callback = function(args)
      M.reload_all()
      vim.notify('Reloaded ' .. vim.fn.fnamemodify(args.file, ':~:.'), vim.log.levels.INFO, { title = 'hot-reload' })
    end,
    desc = 'Hot reload custom lua modules',
  })

  vim.keymap.set('n', '<leader>rr', function()
    M.reload_all()
  end, { desc = 'Reload entire custom config' })
end

M.setup()

return M
