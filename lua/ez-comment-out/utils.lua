local M = {}

--- This function returns the file type
--- @return string | nil
function M.GetFileType()
	local buf = vim.api.nvim_get_current_buf();
	local ft = vim.bo[buf].filetype
	local result = ft or nil
	return result
end

--- This function reads and decodes a JSON file
--- @param path string
--- @return any
function M.ReadJsonFile(path)
	local script_dir = debug.getinfo(1).source:gsub("^@", ""):match("(.*[/\\])")
	if not script_dir then
		error("Could not determine script directory")
	end

	local full_path = script_dir .. path
	local f = io.open(full_path, "r")

	if not f then
		error(string.format("Could not open file: %s", full_path))
	end

	local content = f:read("*a")
	f:close()

	if not content or content == "" then
		error(string.format("File is empty: %s", full_path))
	end

	local data = vim.json.decode(content)
	return data
end

return M
