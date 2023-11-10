-- Custom Modules
local logSystem = require("modules.logSystem")
local fsUtils = require("modules.fsUtils")

-- Variables

-- Determines how ISOs are treated. nil = not specified, "iso" = normal ISO, "wii_gc" = Wii/GameCube ISO
local isoMode = nil

local ignoreSystemLibs = false -- Determines whether or not to ignore system libraries.
local verboseEnabled = false -- Determines whether or not to print debug messages.
local enableSwitchSupport = false -- Determines whether or not to enable Nintendo Switch support.

-- First, we give each argument an action.
local arguments = {
	["--enable-switch"] = function ()
		if fsUtils.exists(os.getenv("HOME").."/.switch/prod.keys") then
			if enableSwitchSupport == false then
				logSystem.log("info", "Nintendo Switch production keys successfully located.")
				print()
				print("----------------------------------------------------------------------------")
				print("WARNING ! Nintendo Switch game support is still experimental !")
				print("Expect the operation to use A TON of memory.")
				print("Do not proceed if you do not think your computer can handle it.")
				print("Tip : zRAM can help with the operation. Enable it if possible.")
				print("----------------------------------------------------------------------------")
				io.write("Press Enter to confirm you've read this prompt.")
				io.read()
				print()

				print("Are you sure ? This compression system is very memory intensive and may take a long time to complete.")
				print("Even a computer with 16 GB of RAM and 16 GB of zRAM can run out of memory.")
				io.write("Press Enter if you're certain you want to continue.")
				io.read()
				print()
				
				enableSwitchSupport = true
				logSystem.log("warning", "Nintendo Switch game support enabled. Good luck !")
			end
		else
			logSystem.log("error", "Nintendo Switch keys not found. Please put them as ~/.switch/prod.keys and try again.")
			os.exit(1)
		end
	end,
	["--ignore-system"] = function ()
		ignoreSystemLibs = true
	end,
	["--help"] = function ()
		require("extra.help")
		os.exit(0)
	end,
	["--iso"] = function()
		if isoMode == nil then
			logSystem.log("info", "ISOs will be treated normally.")
			isoMode = "iso"
		elseif isoMode ~= "iso" then
			logSystem.log("error", "ISOs are already treated as something else.")
			os.exit(1)
		end
	end,
	["--wii-gc"] = function()
		if isoMode == nil then
			print()
			print("----------------------------------------------------------------------------")
			print("WARNING ! StompMyFiles aims for pure brute strength, not performance !")
			print("Wii/GameCube games compressed with it may not perform well or malfunction until decompression.")
			print("----------------------------------------------------------------------------")
			io.write("Press Enter to confirm you've read this prompt.")
			io.read()
			print()

			logSystem.log("info", "ISOs will be treated as Wii/GameCube games.")
			isoMode = "wii_gc"
		elseif isoMode ~= "wii_gc" then
			logSystem.log("error", "ISOs are already treated as something else.")
			os.exit(1)
		end
	end,
	["--verbose"] = function ()
		verboseEnabled = true
	end,
	["--version"] = function ()
		print("\27[33m"..NAME.." version "..VERSION.."\27[0m")
		print("Universal file compression utility, aiming for brute strength (at the cost of time) and ease of use.")
		print("(Also useful if you're freezing, since it may set your CPU or RAM on fire)")
		print("")
		print("Developed by \27[91m"..DEVELOPER.."\27[0m")
		print("\27[34m"..URL.."\27[0m")
		os.exit(0)
	end
}

-- And finally, the argument management
local toBeCompressed = {}
for _,i in ipairs(arg) do
	local f = arguments[i]
	if (f) then
		-- If the argument exists, we execute it.
		f()
	else
		if (i:sub(1,1) == "-") then
			logSystem.log("error", "Unknown argument "..i)
			os.exit(1)
		end

		-- Else we assume the user is trying to open a file.
		if fsUtils.exists(i) then
			-- We check that it isn't already in the table
			local checkIfInTable = function ()
				for _,j in ipairs(toBeCompressed) do
					if (j == i) then
						return true
					end
				end
				return false
			end

			if (not checkIfInTable()) then
				table.insert(toBeCompressed, i)
			else
				logSystem.log("info", "File "..i.." is already in the list. Skipping...")
			end
		elseif (i ~= "") then --Workaround around Bash shenanigans
			logSystem.log("warning", "File "..i.." does not exist. Skipping...")
		end
	end
end
if (#toBeCompressed == 0) then
	logSystem.log("error", "No valid input file specified.")
	os.exit(1)
end

return {toBeCompressed = toBeCompressed, settings = {
	isoMode = isoMode,
	ignoreSystemLibs = ignoreSystemLibs,
	verboseEnabled = verboseEnabled,
	switchSupport = enableSwitchSupport
}}
