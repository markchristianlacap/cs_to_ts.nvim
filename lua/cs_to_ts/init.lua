local enumConverter = require("cs_to_ts.enum")
local classConverter = require("cs_to_ts.class")
local M = {}

function M.convertToTS(csharpCode)
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

function M.getVisualSelection()
	local orig_reg = vim.fn.getreg('"')
	local orig_regtype = vim.fn.getregtype('"')
	vim.cmd('normal! ""gv"')
	local selected_text = vim.fn.getreg('"')
	vim.fn.setreg('"', orig_reg, orig_regtype)
	return selected_text
end

return M
