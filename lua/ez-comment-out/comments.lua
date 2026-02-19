local M = {}

--- This function sets comment symbol before the current line
---@param symbol string
---@param line string
---@return string
function M.insert_single_line_comment(symbol, line)
    local result = symbol .. " " .. line
    return result
end

--- This function append and prepend symbols at the given line
---@param starting_symbol string
---@param ending_symbol string
---@param lines table
---@return table
function M.insert_multi_line_comment(starting_symbol, ending_symbol, lines)
    local result = {}

    table.insert(result, starting_symbol);

    for i = 1, #lines, 1 do
        vim.print("line :" .. i .. " - " .. lines[i])
        table.insert(result, lines[i])
    end

    table.insert(result, ending_symbol);
    return result
end

--- Get selected lines in visual mode
---@return table
function M.get_selected_lines()
    -- Get the start and end positions of the visual selection
    local start_pos  = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos    = vim.api.nvim_buf_get_mark(0, ">")

    local start_line = start_pos[1]
    local end_line   = end_pos[1]

    local buf        = vim.api.nvim_get_current_buf()
    local lines      = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

    return lines
end

--- Replace selected lines with lines table
---@param lines table
function M.set_selected_lines(lines)
    local start_pos  = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos    = vim.api.nvim_buf_get_mark(0, ">")

    local start_line = start_pos[1]
    local end_line   = end_pos[1]

    local buf        = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, lines)
end

--- This function handle <ctrl + _> command for normal mode
---@param fileType string
---@param content any
function M.handle_command_for_normal_mode(fileType, content)
    local languages = content.languages
    local current_line = vim.api.nvim_get_current_line()
    local comment_symbol = languages[fileType]

    if not comment_symbol then return end

    if not (comment_symbol["single_line"] == vim.NIL) then
        local result = M.insert_single_line_comment(comment_symbol["single_line"], current_line)
        vim.api.nvim_set_current_line(result)
        return;
    elseif not (comment_symbol["multi_line"] == vim.NIL) then
        -- Some languages may not have single line comment.
        -- then multiline is required to comment a single line
        local starting_symbol = comment_symbol["multi_line"]["start"]
        local ending_symbol = comment_symbol["multi_line"]["end"]

        local result = M.insert_multi_line_comment(
            starting_symbol,
            ending_symbol,
            { current_line }
        )

        vim.api.nvim_set_current_line(result[1] .. " " .. result[2] .. result[#result])
    end
end

--- This function insert comment in visual mode.
---@param fileType string
---@param content any
function M.handle_command_for_visual_mode(fileType, content)
    local languages = content.languages

    local lines = M.get_selected_lines()
    local language = languages[fileType]

    if not language then return end

    if not (language["multi_line"] == vim.NIL) then
        local updated_lines = M.insert_multi_line_comment(
            language["multi_line"]["start"],
            language["multi_line"]["end"],
            lines
        )

        M.set_selected_lines(updated_lines)
        return;
    elseif not (language["single_line"] == vim.NIL) then
        local updated_lines = {}

        for i = 1, #lines, 1 do
            table.insert(updated_lines, M.insert_single_line_comment(language["single_line"], lines[i]))
        end

        M.set_selected_lines(updated_lines)
        return;
    end
end

return M
