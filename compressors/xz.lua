-- Custom modules
local logSystem = require("modules.logSystem")
local Compressor = require("modules.compressorObject")
local compressorManager = require("modules.compressorManager")

-- Functions
local function getMemoryToUse()
	-- Allow xz to use 60% of the available RAM
	logSystem.log("debug", "Getting amount of RAM available for XZ...")
	local f = io.popen("free -m")
	if (not f) then
		error("Could not get the amount of RAM available.")
	end
	local ram = f:read("*a")
	f:close()
	ram = ram:match("Mem:%s+(%d+)")
	ram = math.floor(ram * 0.6)
	logSystem.log("debug", "Got "..ram.."GB of RAM.")

	return ram
end

-- Definitions
local compressorName = "xz"
local localVersion = nil

local function checkFunction()
	if (os.execute("which "..compressorName.." > /dev/null 2>&1") == true and ARGUMENTS.settings.ignoreSystemLibs == false) then
		return "system"
	else
		logSystem.log("error", "XZ is somehow unavailable from your system. Due to it being considered critical, local cache installation will not be used.")
		return "unavailable"
	end
end

local function compressFunction(input)
	local ram = getMemoryToUse()

	logSystem.log("info", "Compressing "..input.." using XZ with "..ram.."GB of RAM.")
	local command = string.format("%s -z9e --threads=0 --memlimit=%sGB '%s'",
		compressorManager.selectCompressionTool("xz"),
		ram,
		input:gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)
	os.execute(command)
	return "success"
end

local function decompressFunction(input)
	local ram = getMemoryToUse()

	logSystem.log("info", "Decompressing "..input.." using XZ with "..ram.."GB of RAM.")
	local command = string.format("%s -d --threads=0 --memlimit=%sGB '%s'",
		compressorManager.selectCompressionTool("xz"),
		ram,
		input:gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)
	os.execute(command)
	return "success"
end


return Compressor:new(compressorName, checkFunction, compressFunction, decompressFunction)
