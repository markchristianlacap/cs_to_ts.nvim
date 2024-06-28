local M = {}
local function camelCase(str)
	if #str == 0 then
		return str
	end
	return str:sub(1, 1):lower() .. str:sub(2)
end
-- Utility function to split strings
local function split(str, delim)
	local result = {}
	local pattern = string.format("([^%s]+)", delim)
	string.gsub(str, pattern, function(c)
		result[#result + 1] = c
	end)
	return result
end
function hasNullable(csharpType)
	return string.find(csharpType, "%?$") ~= nil
end

-- Function to map C# types to TypeScript types
local function mapType(csharpType)
	csharpType = csharpType:gsub("%?$", "")
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
	return typeMap[csharpType] or csharpType
end

-- Function to parse a C# class definition
local function parseCSharpClass(csharpClass)
	local lines = split(csharpClass, "\n")
	local className = ""
	local properties = {}

	for _, line in ipairs(lines) do
		line = line:match("^%s*(.-)%s*$") -- Trim whitespace

		if string.find(line, "^public class") then
			className = string.match(line, "public class (%w+)")
		elseif string.find(line, "^public") then
			local isMethod = string.find(line, "%(")
			local isReadOnlyProp = string.find(line, "=>")
			if not isMethod or isReadOnlyProp then
				local propType, propName = string.match(line, "public (%w+) (%w+)")
				propName = camelCase(propName)
				local isNullable = hasNullable(propType)
				propType = mapType(propType)
				if isNullable then
					propName = propName .. "?"
				end
				properties[#properties + 1] = { name = propName, propType = propType, isNullable = isNullable }
			end
		end
	end

	return className, properties
end

-- Function to generate TypeScript interface
local function generateTSInterface(className, properties)
	local tsInterface = "export interface " .. className .. " {\n"

	for _, prop in ipairs(properties) do
		local propType = prop.propType
		if prop.isNullable then
			propType = propType .. " | null"
		end
		tsInterface = tsInterface .. "    " .. prop.name .. ": " .. propType .. ";\n"
	end

	tsInterface = tsInterface .. "}\n"
	return tsInterface
end

-- Main function to convert C# class to TypeScript interface
function M.convertCsToTsInterface(csharpClass)
	local className, properties = parseCSharpClass(csharpClass)
	return generateTSInterface(className, properties)
end

return M
