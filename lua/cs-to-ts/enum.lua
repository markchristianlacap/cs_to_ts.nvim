local M = {}

-- Define the Lua function to convert C# enum to TypeScript enum
function M.convertCsToTSEnum(csharpEnum)
	local output = csharpEnum:gsub("public", "export")
	return output
end

return M
