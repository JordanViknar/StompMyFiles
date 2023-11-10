-- External modules
local socket = require("socket.http")
local lfs = require("lfs")

-- Custom modules
local logSystem = require("modules.logSystem")
local Compressor = require("modules.compressorObject")
local compressorManager = require("modules.compressorManager")
local fsUtils = require("modules.fsUtils")
local systemUtils = require("modules.systemUtils")

-- Definitions
local compressorName = "7z"
local localVersion = "2301"

local function checkFunction()
	if (os.execute("which "..compressorName.." > /dev/null 2>&1") == true and ARGUMENTS.settings.ignoreSystemLibs == false) then
		return "system"
	else
		logSystem.log("warning", "7z can't be provided by your system. Checking local cache...")

		-- Make 7z folder in cache if missing
		if (not fsUtils.exists(CACHE_FOLDER..compressorName)) then
			logSystem.log("debug", "Creating 7z folder in cache...")
			lfs.mkdir(CACHE_FOLDER.."7z")
		end

		-- Check if the local version is present or updated
		if (fsUtils.exists(CACHE_FOLDER.."7z/version.txt")) then
			local f = io.open(CACHE_FOLDER.."7z/version.txt", "r")
			if (f) then
				local version = f:read("*a")
				f:close()
				if (version == localVersion.."\n") then
					logSystem.log("download", "7z is already installed into the local cache.")
					return "local"
				else
					logSystem.log("download", "7z is installed into the local cache, but it's outdated.")
				end
			end
		else
			logSystem.log("warning", "7z is unavailable from system and local cache.")
		end

		-- Check if we have internet
		if (not systemUtils.isInternetAvailable()) then
			return "unavailable"
		end

		-- First we set what processor platform we're on
		local platform = systemUtils.checkPlatform()
		if (not platform) then
			return "unavailable"
		end

		-- Download 7zip and put its executable in the local cache
		logSystem.log("download", "Downloading 7z into local cache...")
		local response, status, headers = socket.request("https://www.7-zip.org/a/7z"..localVersion.."-linux-"..platform..".tar.xz")
		if status == 200 then
			-- If we succeed, we save the downloaded content to a file
			local file = io.open(CACHE_FOLDER..compressorName.."/7z-linux-"..platform..".tar.xz", "wb")

			if file then
				file:write(response)
				file:close()
				logSystem.log("debug", "Downloaded 7z.")
			else
				logSystem.log("error", "Failed to save the downloaded content to a file.")
				return "unavailable"
			end
		else
			logSystem.log("error", "Failed to download 7z : HTTP status code " .. status)
			return "unavailable"
		end

		-- Extract the archive
		logSystem.log("debug", "Extracting 7z...")
		local extractCommand = string.format("tar -xf '%s' -C '%s' '%s'",
			CACHE_FOLDER..compressorName.."/"..compressorName.."-linux-"..platform..".tar.xz",
			CACHE_FOLDER..compressorName,
			"7zz"
		)
		logSystem.log("debug", "Running command : "..extractCommand)
		os.execute(extractCommand)

		-- Remove the archive
		logSystem.log("debug", "Removing 7z archive...")
		os.remove(CACHE_FOLDER..compressorName.."/7z-linux-"..platform..".tar.xz")

		-- Rename 7zz executable into 7z
		logSystem.log("debug", "Renaming 7zz executable into 7z...")
		os.execute("mv '"..CACHE_FOLDER.."7z/7zz' '"..CACHE_FOLDER.."7z/7z'")

		-- Make the executable executable
		logSystem.log("debug", "Making 7z executable...")
		os.execute("chmod +x '"..CACHE_FOLDER.."7z/7z'")

		-- Add a text file with the version
		logSystem.log("debug", "Adding version information...")
		os.execute("echo '"..localVersion.."' > '"..CACHE_FOLDER.."7z/version.txt'")

		logSystem.log("download", "7z was downloaded and installed into the local cache.")
		return "local"
	end
end

local function compressFunction(input)
	--Get number of CPU threads
	logSystem.log("debug", "Getting number of CPU threads for 7z...")
	local threads = systemUtils.grabThreads()
	logSystem.log("debug", "Got "..threads.." threads.")

	-- Compression Command
	logSystem.log("info", "Compressing "..input.." using 7z with "..threads.." threads.")
	local command = string.format("%s -sdel -mx9 -ms=on -mmt%s a '%s.7z' '%s' ",
		compressorManager.selectCompressionTool("7z"),
		threads,
		input:gsub("'", "'\\''"),
		input:gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)

	logSystem.log("switch", "Passing output to 7z...")
	local result = os.execute(command)
	logSystem.log("switchEnd")
	
	if result == true then
		return "success"
	else
		logSystem.log("error", "7z returned an error code.")
		return "error"
	end
end

local function decompressFunction(input)
	-- Decompress
	logSystem.log("info", "Decompressing "..input.." using 7z.")
	local command = string.format("%s x '%s' -o'%s'",
		compressorManager.selectCompressionTool("7z"),
		input:gsub("'", "'\\''"),
		fsUtils.getDirectory(input):gsub("'", "'\\''")
	)
	logSystem.log("debug", "Running command : "..command)

	logSystem.log("switch", "Passing output to 7z...")
	local result = os.execute(command)
	logSystem.log("switchEnd")

	if result == true then
		logSystem.log("debug", "Removing archive...")
		os.remove(input:gsub("'", "'\\''"))
		return "success"
	else
		logSystem.log("error", "7z returned an error code. Archive file won't be removed.")
		return "error"
	end
end


return Compressor:new(compressorName, checkFunction, compressFunction, decompressFunction)
