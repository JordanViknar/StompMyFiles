-- Custom modules
local logSystem = require("modules.logSystem")
local Compressor = require("modules.compressorObject")
local compressorManager = require("modules.compressorManager")
local fsUtils = require("modules.fsUtils")

-- Definitions
local compressorName = "dolphin-tool"
--local localVersion = nil

local function checkFunction()
	if (os.execute("which "..compressorName.." > /dev/null 2>&1") == true and ARGUMENTS.settings.ignoreSystemLibs == false) then
		return "system"
	else
		logSystem.log(
			"error",
			"dolphin-tool can't be provided by your system or locally. Wii/GameCube disc image support won't be available."
		)
		return "unavailable"
	end
end

local function compressFunction(input)
	logSystem.log("info", "Compressing "..input.." using dolphin-tool.")

	local command = string.format("%s convert -f rvz -c lzma2 -l 9 -b 2097152 -i '%s' -o '%s'",
		compressorManager.selectCompressionTool("dolphin-tool"),
		input:gsub("'", "'\\''"),
		(fsUtils.getDirectory(input).."/"..fsUtils.getFileNameNoExt(input)..".rvz"):gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)

	if os.execute(command) == true then
		logSystem.log("debug", "Removing ISO file...")
		os.remove(input:gsub("'", "'\\''"))
		return "success"
	else
		logSystem.log("error", "dolphin-tool returned an error code. ISO file won't be removed.")
		return "error"
	end
end

local function decompressFunction(input)
	logSystem.log("info", "Decompressing "..input.." using dolphin-tool.")

	local command = string.format("%s convert -f iso -i '%s' -o '%s'",
		compressorManager.selectCompressionTool("dolphin-tool"),
		input:gsub("'", "'\\''"),
		(fsUtils.getDirectory(input).."/"..fsUtils.getFileNameNoExt(input)..".iso"):gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)

	if os.execute(command) == true then
		logSystem.log("debug", "Removing RVZ file...")
		os.remove(input:gsub("'", "'\\''"))
		return "success"
	else
		logSystem.log("error", "dolphin-tool returned an error code. RVZ file won't be removed.")
		return "error"
	end
end

return Compressor:new(compressorName, checkFunction, compressFunction, decompressFunction)
