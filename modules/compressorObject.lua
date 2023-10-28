-- Custom modules
local logSystem = require("modules.logSystem")

Compressor = {
	metatable = {
		__index = Compressor
	}
}
function Compressor:new (name, checkCommand, compressCommand, decompressCommand)
	return setmetatable({
		name = name,
		compress = compressCommand or function()
			logSystem.log("warning","No compression command defined for "..name..". Skipping...")
			return "notDefined"
		end,
		check = checkCommand or function()
			logSystem.log("warning","No avaibility checks defined for "..name..". Attempting operation anyways...")
			return "notDefined"
		end,
		decompress = decompressCommand or function()
			logSystem.log("warning","No decompression command defined for "..name..". Skipping...")
			return "notDefined"
		end,
	}, Compressor.metatable)
end

return Compressor
