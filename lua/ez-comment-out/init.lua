local M = {}

--- Config the plugin
---@param opts table
function M.setup(opts)
	opts = opts or {}

	vim.keymap.set({ 'v', 'n' }, '<C-_>', function()
		print("testing!")
	end, { desc = "command to comment out selected lines" })
end

return M
