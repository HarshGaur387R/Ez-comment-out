local Debug_log = require("ez-comment-out.Debug_log")
local M = {}

--- This function returns the file type
--- @return string | nil
function GetFileType()
	local buf = vim.api.nvim_get_current_buf();
	local ft = vim.bo[buf].filetype
	local result = ft or nil
	return result
end

--- This function handle <ctrl + _> command
local function handle_command()
	print(GetFileType())
	Debug_log(GetFileType() or "")
end

--- Config the plugin
---@param opts table
function M.setup(opts)
	opts = opts or {}

	vim.keymap.set({ 'v', 'n' }, '<C-_>', function()
		handle_command()
	end, { desc = "command to comment out selected lines" })
end

return M
