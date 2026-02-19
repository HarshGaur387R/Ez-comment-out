local M = {}
local utils = require("ez-comment-out.utils")
local comments = require("ez-comment-out.comments")

--- Config the plugin
---@param opts table
function M.setup(opts)
	opts = opts or {}

	local decodedContent = utils.ReadJsonFile("comments_symbols.json")

	vim.keymap.set({ 'n' }, '<C-_>', function()
		local fileType = utils.GetFileType()
		if not fileType then return end
		comments.handle_command_for_normal_mode(fileType, decodedContent)
	end, { desc = "command to comment out single line normal mode" })

	vim.keymap.set({ "x" }, '<C-_>', function()
		vim.cmd('normal! \27') -- or use feedkeys
		local fileType = utils.GetFileType()
		if not fileType then return end
		comments.handle_command_for_visual_mode(fileType, decodedContent)
	end, { desc = "command to comment out selected line" })
end

return M
