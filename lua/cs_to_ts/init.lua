local enumConverter = require("cs_to_ts.enum")
local M = {}

local typeMap = {
	["int"] = "number",
	["float"] = "number",
	["double"] = "number",
	["bool"] = "boolean",
	["string"] = "string",
	["Guid"] = "string",
	["DateTime"] = "Date",
	["DateOnly"] = "Date",
	-- Add more types as needed
}

local function convertType(csharpType)
	local baseType = csharpType:gsub("%?", "")
	local tsType = typeMap[baseType] or baseType
	if csharpType:find("%?") then
		tsType = tsType .. " | null"
	end
	return tsType
end

local function toCamelCase(str)
	return str:sub(1, 1):lower() .. str:sub(2)
end

function M.convertToTS(csharpCode)
	local tsCode = ""
	local className = csharpCode:match("class%s+(%w+)")
	local enumName = csharpCode:match("enum%s+(%w+)")

	if className then
		tsCode = tsCode .. "export interface " .. className .. " {\n"
		for propType, propName in csharpCode:gmatch("public%s+([%w%d_?]+)%s+([%w%d_]+)%s*{ get; set; }") do
			tsCode = tsCode .. "    " .. toCamelCase(propName) .. ": " .. convertType(propType) .. ";\n"
		end
		tsCode = tsCode .. "}\n"
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
