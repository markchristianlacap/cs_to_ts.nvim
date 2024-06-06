local M = {}

function M.convertToTypeScriptInterface(selectedText)
	-- Mapping C# types to TypeScript types
	local typeMap = {
		["int"] = "number",
		["float"] = "number",
		["double"] = "number",
		["bool"] = "boolean",
		["string"] = "string",
		["Guid"] = "string", -- Guid can be represented as string in TypeScript
		["DateTime"] = "Date",
		["DateOnly"] = "Date",
		-- Add more types as needed
	}

	-- Function to convert a C# type to TypeScript type
	local function convertType(csharpType)
		local baseType = csharpType:gsub("%?", "")
		local tsType = typeMap[baseType] or baseType
		if csharpType:find("%?") then
			tsType = tsType .. " | null"
		end
		return tsType
	end

	-- Function to convert PascalCase to camelCase
	local function toCamelCase(str)
		return str:sub(1, 1):lower() .. str:sub(2)
	end

	-- Function to convert C# class to TypeScript interface
	local function convertToInterface(csharpClass)
		local tsInterface = ""
		local className = csharpClass:match("class%s+(%w+)")
		if not className then
			return nil, "No valid class found"
		end
		tsInterface = tsInterface .. "export interface " .. className .. " {\n"

		-- Match properties
		for propType, propName in csharpClass:gmatch("public%s+([%w%d_?]+)%s+([%w%d_]+)%s*{ get; set; }") do
			tsInterface = tsInterface .. "    " .. toCamelCase(propName) .. ": " .. convertType(propType) .. ";\n"
		end

		tsInterface = tsInterface .. "}\n"
		return tsInterface
	end

	-- Convert the selected text to TypeScript interface
	return convertToInterface(selectedText)
end

-- Function to get the selected text in visual mode
function M.getVisualSelection()
	-- Save the current register contents
	local orig_reg = vim.fn.getreg('"')
	local orig_regtype = vim.fn.getregtype('"')

	-- Copy the visually selected text to the default register
	vim.cmd('normal! ""gv"')

	-- Get the selected text
	local selected_text = vim.fn.getreg('"')

	-- Restore the original register contents
	vim.fn.setreg('"', orig_reg, orig_regtype)

	return selected_text
end

return M
