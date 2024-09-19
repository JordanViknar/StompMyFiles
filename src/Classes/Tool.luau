local Console = require('@Utilities/Console')
local System = require('@Utilities/System')

export type Tool = {
	name: string,
	executable: string?,
	compress: (string) -> (),
	decompress: (string) -> (),
}

local Tool = {}
Tool.Interface = {}

function Tool.Interface.new(name: string, compress: (string, string) -> (), decompress: (string, string) -> ()): Tool
	local executable = nil
	local function checkForExecutable(): string?
		if executable then
			return executable
		end

		-- Check first if accessible from PATH
		if System.isExecutableInPATH(name) then
			executable = name
			return executable
		else
			-- Not accessible, must use cache, download, or give up.
			-- NOT YET IMPLEMENTED.
			return nil
		end
	end

	return {
		name = name,
		compress = function(path: string)
			local exec = checkForExecutable()
			if exec then
				return compress(exec, path)
			else
				Console.visibleError('Can\'t find a valid executable for "' .. name .. '".')
			end
		end,
		decompress = function(path: string)
			local exec = checkForExecutable()
			if exec then
				return decompress(exec, path)
			else
				Console.visibleError('Can\'t find a valid executable for "' .. name .. '".')
			end
		end,
	}
end

return Tool.Interface
