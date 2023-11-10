-- Custom modules
local logSystem = require("modules.logSystem")
local Compressor = require("modules.compressorObject")
local compressorManager = require("modules.compressorManager")
local fsUtils = require("modules.fsUtils")
local systemUtils = require("modules.systemUtils")

-- Definitions
local compressorName = "nsz"
--local localVersion = nil

local function checkFunction()
	if (os.execute("which "..compressorName.." > /dev/null 2>&1") == true and ARGUMENTS.settings.ignoreSystemLibs == false and ARGUMENTS.settings.switchSupport == true) then
		return "system"
	else
		logSystem.log(
			"error",
			"nsz can't be provided by your system or locally. Nintendo Switch game support won't be available."
		)
		return "unavailable"
	end
end

local function compressFunction(input)
	--Get number of CPU threads
	logSystem.log("debug", "Getting number of CPU threads for nsz...")
	local threads = systemUtils.grabThreads()
	logSystem.log("debug", "Got "..threads.." threads.")

	-- Compression Command
	logSystem.log("info", "Compressing "..input.." using nsz with "..threads.." threads.")

	local command = string.format("%s -C -LSQK -l 22 -t %s --rm-source '%s'",
		compressorManager.selectCompressionTool("nsz"),
		threads,
		input:gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)

	logSystem.log("switch", "Passing output to nsz...")
	local result = os.execute(command)
	logSystem.log("switchEnd")

	if result == true then
		return "success"
	else
		logSystem.log("error", "nsz returned an error code. Uncompressed Nintendo Switch game won't be removed.")
		return "error"
	end
end

local function decompressFunction(input)
	--Get number of CPU threads
	logSystem.log("debug", "Getting number of CPU threads for nsz...")
	local threads = systemUtils.grabThreads()
	logSystem.log("debug", "Got "..threads.." threads.")

	-- Decompression Command
	logSystem.log("info", "Decompressing "..input.." using nsz with "..threads.." threads.")

	local command = string.format("%s -D -t %s --rm-source '%s'",
		compressorManager.selectCompressionTool("nsz"),
		threads,
		input:gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)

	logSystem.log("switch", "Passing output to nsz...")
	local result = os.execute(command)
	logSystem.log("switchEnd")

	if result == true then
		return "success"
	else
		logSystem.log("error", "nsz returned an error code. Compressed Nintendo Switch game won't be removed.")
		return "error"
	end
end

return Compressor:new(compressorName, checkFunction, compressFunction, decompressFunction)
