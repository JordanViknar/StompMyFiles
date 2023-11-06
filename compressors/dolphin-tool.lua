-- Custom modules
local logSystem = require("modules.logSystem")
local Compressor = require("modules.compressorObject")
local compressorManager = require("modules.compressorManager")
local fsUtils = require("modules.fsUtils")

-- Definitions
local compressorName = "dolphin-tool"
local localVersion = nil

local function checkFunction()
	if (os.execute("which "..compressorName.." > /dev/null 2>&1") == true and ARGUMENTS.settings.ignoreSystemLibs == false) then
		return "system"
	else
		return "unavailable"
	end
end

local function compressFunction(input)
	logSystem.log("info", "Compressing "..input.." using dolphin-tool.")
	os.execute(compressorManager.selectCompressionTool("dolphin-tool").." convert -f rvz -c lzma2 -l 9 -b 2097152 -i '"..input.."' -o '"..fsUtils.getDirectory(input).."/"..fsUtils.getFileNameNoExt(input)..".rvz'")
	os.execute("rm '"..input.."'")
	return "success"
end

local function decompressFunction(input)
	logSystem.log("info", "Decompressing "..input.." using dolphin-tool.")
	os.execute(compressorManager.selectCompressionTool("dolphin-tool").." convert -f iso -i '"..input.."' -o '"..fsUtils.getDirectory(input).."/"..fsUtils.getFileNameNoExt(input)..".iso'")
	os.execute("rm '"..input.."'")
	return "success"
end


return Compressor:new(compressorName, checkFunction, compressFunction, decompressFunction)
