local M = {}
local utils = require("ez-comment-out.utils")
local comments = require("ez-comment-out.comments")
local configWindow = require('ez-comment-out.config_window')

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

	vim.api.nvim_create_user_command("EzConfigComments", function()
		local script_dir = debug.getinfo(1).source:gsub("^@", ""):match("(.*[/\\])")
		if not script_dir then
			error("Could not determine script directory")
		end

		local full_path = script_dir .. "comments_symbols.json"
		local win, opts = configWindow.OpenConfigWindow("Customize Config", full_path)
		local custom_config_buf = vim.api.nvim_win_get_buf(win)

		vim.api.nvim_create_autocmd("WinClosed", {
			pattern = tostring(win),
			callback = function()
				if vim.bo[custom_config_buf].modified then
					vim.notify(
						'No write since last change for buffer "' ..
						full_path .. '". Save with :w or discard with :bd!',
						vim.log.levels.WARN
					)
					-- Reopen the window so user can save or explicitly discard
					vim.api.nvim_open_win(custom_config_buf, true, opts)
					return
				end
				vim.api.nvim_buf_delete(custom_config_buf, { force = false })
			end
		})
	end, {
		nargs = 0,
		desc = "This command open a floating window to help on comment configuration"
	})
end

return M
