-- Log System
local logSystem = require("modules.logSystem")

-- Variables
local isoMode = nil -- Determines how ISOs are treated. nil = not specified, "iso" = normal ISO, "wii_gc" = Wii/GameCube ISO
local ignoreSystemLibs = false -- Determines whether or not to ignore system libraries.
local verboseEnabled = false -- Determines whether or not to print debug messages.

-- First, we give each argument an action.
local arguments = {
	["--ignore-system"] = function ()
		ignoreSystemLibs = true
	end,
	["--help"] = function ()
		require("extra.help")
		os.exit(0)
	end,
	["--normal-iso"] = function()
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
			print("----------------------------------------------------------------------------")
			print("WARNING ! StompMyFiles aims for pure brute strength, not performance !")
			print("Wii/GameCube games compressed with it may not perform well or disfunction until decompression.")
			print("----------------------------------------------------------------------------")
			io.write("Press Enter to confirm you've read this prompt.")
			io.read()

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
		local f = io.open(i, "r")
		if (f) then
			f:close()

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
	verboseEnabled = verboseEnabled
}}
