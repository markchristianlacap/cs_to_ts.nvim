local enumConverter = require("cs_to_ts.enum")
local classConverter = require("cs_to_ts.class")
local M = {}

function M.convert(csharpCode)
	local tsCode = ""
	local className = csharpCode:match("class%s+(%w+)")
	local enumName = csharpCode:match("enum%s+(%w+)")

	if className then
		tsCode = classConverter.convertCsToTsInterface(csharpCode)
	elseif enumName then
		tsCode = enumConverter.convertCsToTSEnum(csharpCode)
	else
		return nil, "No valid class or enum found"
	end

	return tsCode
end

function M.getSelectedText()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	return table.concat(lines, "\n")
end

return M
