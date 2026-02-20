local utils = require("ez-comment-out.utils")
local M = {}

--- This function opens a window containing content of comments_symbols.json
--- @param header string
---@param filepath string
---@return integer, any
function M.OpenConfigWindow(header, filepath)
	-- Load the file into a buffer (creates it if not exists)
	local buf = vim.fn.bufadd(filepath)
	vim.fn.bufload(buf) -- ensure it's loaded into memory

	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.5)
	local height = math.floor(ui.height * 0.3)

	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = header, -- header shown in the border
		title_pos = "center" -- center it
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Optional: enable syntax highlighting, line numbers etc.
	vim.wo[win].number = true
	vim.wo[win].relativenumber = false

	return win, opts
end

return M
