--[[
						INITIALIZATION
]]
require("extra.programMetadata") -- Constants used throughout the program.

--[[
	First, we grab the most important part of the program.
	This table allows us to easily manage compressors
]]
local compressors = {
	-- Common but strong compressors
	["7z"] = require("compressors.7z"),
	["xz"] = require("compressors.xz"),

	-- Less common, but advantaged when used right.
	-- ["upx"] = require("compressors.upx"),
	["dolphin-tool"] = require("compressors.dolphin-tool")
	-- ["nsz"] = require("compressors.nsz")
}
local bannedExtensions = require("extra.bannedExtensions")

-- Custom Modules
local fsUtils = require("modules.fsUtils")
local logSystem = require("modules.logSystem")

-- Now we can start listening to the user.
ARGUMENTS = require("modules.argumentManager")

-- Variables
local filesSkipped = 0
local checkedCompressors = {}

-- Cache folder
if (not fsUtils.exists(CACHE_FOLDER)) then
	logSystem.log("debug", "Creating stomp-my-files folder in cache...")
	os.execute("mkdir '"..CACHE_FOLDER.."'")
end

-- Checks
local function checkForCompressor(compressorType)
	-- If the compressor wasn't already checked
	if (not checkedCompressors[compressorType]) then
		-- We check it through its provided function, and if we succeed, it's added to the list.
		checkedCompressors[compressorType] = compressors[compressorType].check()
	end
	-- We return its status.
	return checkedCompressors[compressorType]
end

local function attemptOperation(name, type, input)
	local availability = checkForCompressor(name)
	if (availability == "system" or availability == "local" or availability == "notDefined") then
		if type == "compress" then
			return compressors[name].compress(input)
		elseif type == "decompress" then
			return compressors[name].decompress(input)
		else
			error("Unknown operation type "..type..".")
		end
	else 
		logSystem.log("warning", "Could not provide "..name.." for \""..input.."\". Skipping...")
		filesSkipped = filesSkipped + 1
		return "failed"
	end
end

--[[
						MAIN PROGRAM
]]
logSystem.log("debug", "Beginning main function...")

for _,input in ipairs(ARGUMENTS.toBeCompressed) do
	-- We get rid of the possibly present unnecessary / character on folders.
	if (input:sub(-1) == "/") then
		input = input:sub(1,-2)
	end

	if (fsUtils.isDirectory(input)) then
		logSystem.log("debug", "File "..input.." is a directory. Using 7z...")

		-- For now, we only use 7z for folders.
		if (not attemptOperation("7z", "compress", input)) then
			filesSkipped = filesSkipped + 1
		end
	else
		-- The extension is our current way to determine which tool to use.
		local extension = fsUtils.getExtension(input)
		if extension == nil then
			logSystem.log("info", "File "..input.." has no extension. Assuming it's a compiled executable...")
		else
			logSystem.log("debug", "File "..input.." uses extension "..extension.." .")
		end

		-- We check the file isn't banned.
		if (bannedExtensions[extension]) then
			logSystem.log("warning", "File "..input.." will not compress well. Skipping...")
			filesSkipped = filesSkipped + 1
			break
		end

		-- We use a switch to determine which compressor to use.
		local switch = {
			["7z"] = function()
				attemptOperation("7z", "decompress", input)
			end,
			["xz"] = function()
				attemptOperation("xz", "decompress", input)
			end,
			["iso"] = function()
				if ARGUMENTS.settings.isoMode == "wii_gc" then
					attemptOperation("dolphin-tool", "compress", input)
				elseif ARGUMENTS.settings.isoMode == "iso" then
					attemptOperation("xz", "compress", input)
				else
					logSystem.log("warning", "No behavior specified for ISOs. Skipping...")
					filesSkipped = filesSkipped + 1
				end
			end,
			["rvz"] = function()
				attemptOperation("dolphin-tool", "decompress", input)
			end
		}
		local f = switch[extension]
		if (f) then
			f()
		else
			-- We rely on xz as a fallback to unsupported extensions.
			if extension ~= nil then
				logSystem.log("debug", "No particular behavior defined for "..extension..". Relying on default compression behavior...")
			else
				logSystem.log("debug", "No particular behavior defined for files without extension (yet). Relying on default compression behavior...")
			end
			attemptOperation("xz", "compress", input)
		end
	end
end


if (filesSkipped ~= 0) then
	if (filesSkipped == #ARGUMENTS.toBeCompressed) then
		logSystem.log("warning", "ATTENTION ! All files/folders were skipped.")
	else
		logSystem.log("warning", "ATTENTION ! One or more files/folders were skipped.")
	end
end

logSystem.log("debug", "Main function ended. Exiting program...")
