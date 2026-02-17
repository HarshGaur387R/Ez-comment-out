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
--- @param content any
--- @return any
function DecodeJsonData(content)
	local data = vim.json.decode(content)
	return data
end

--- This function sets comment symbol before the current line
---@param symbol string
---@param line string
---@return string
local function insert_single_line_comment(symbol, line)
	local result = symbol .. " " .. line
	return result
end


--- This function append and prepend symbols at the given line
---@param starting_symbol string
---@param ending_symbol string
---@param lines table
---@return table
local function insert_multi_line_comment(starting_symbol, ending_symbol, lines)
	local result = {}
	-- TODO : complete this

	return result
end

--- This function handle <ctrl + _> command for normal mode
--- @param content any
local function handle_command_for_normal_mode(content)
	local fileType = GetFileType()
	local temp = content.languages
	local current_line = vim.api.nvim_get_current_line()
	local comment_symbol = temp[fileType]

	if not comment_symbol then return end

	if comment_symbol["single_line"] then
		local result = insert_single_line_comment(comment_symbol["single_line"], current_line)
		vim.api.nvim_set_current_line(result)
		return
	elseif comment_symbol["multi_line"] then
		local starting_symbol, ending_symbol =
		    comment_symbol["multi_line"]["start"],
		    comment_symbol["multi_line"]["end"]

		local result = insert_multi_line_comment(
			starting_symbol,
			ending_symbol,
			{ current_line }
		)

		vim.api.nvim_set_current_line(result[1])
	end
end

local function handle_command_for_visual_mode(content)
	local fileType = GetFileType()
	local temp = content.languages
end

--- Config the plugin
---@param opts table
function M.setup(opts)
	opts = opts or {}

	local content = ReadJsonFile("comments_symbols.json")
	local decodedContent = DecodeJsonData(content)

	vim.keymap.set({ 'n' }, '<C-_>', function()
		handle_command_for_normal_mode(decodedContent)
	end, { desc = "command to comment out single line normal mode" })

	vim.keymap.set({ "x" }, '<C-_>', function()
		handle_command_for_visual_mode(decodedContent)
	end, { desc = "command to comment out selected line" })
end

return M
