local Console = require('@Utilities/Console')

local Tool = {}
Tool.metatable = {
	__index = Tool,
}

function Tool.new(name: string, compress: (string) -> (), decompress: (string) -> ())
	return setmetatable({
		name = name,
		compress = compress,
		decompress = decompress,
	}, Tool.metatable)
end

return Tool
