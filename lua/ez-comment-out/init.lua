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

--- This function reads json file data and returns it
---@param path string
---@return any
function ReadJsonFile(path)
	local script_dir = debug.getinfo(1).source:match("@?(.*/)")
	local full_path = script_dir .. path
	local f = assert(io.open(full_path, "r"))
	local content = f:read("*a")
	f:close()
	return content
end

--- This function decods json data
function DecodeJsonData(content)
	local data = vim.json.decode(content)
	return data
end

--- This function handle <ctrl + _> command
local function handle_command()
	local fileType = GetFileType()
	local content = ReadJsonFile("comments_symbols.json")
	local decodedContent = DecodeJsonData(content)
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
