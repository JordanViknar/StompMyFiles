local fs = require('@lune/fs')
local process = require('@lune/process')
local stdio = require('@lune/stdio')

local Console = require('@Utilities/Console')
local Program = require('@Metadata/Program')

export type Setup = {
	paths: { string },
	settings: {
		ISOHandling: 'Wii/GC' | 'Normal',
		ignoreSystemLibs: boolean,
	},
}

local Arguments = {}

function Arguments.detect(): Setup
	-- Defaults
	local ISOHandling: 'Wii/GC' | 'Normal' = 'Normal'
	local ignoreSystemLibs: boolean = false

	-- Arguments
	local arguments = {
		['--ignore-system'] = function()
			ignoreSystemLibs = true
		end,
		['--help'] = function()
			print(require('@Metadata/Help'))
			process.exit(0)
		end,
		['--wii-gc'] = function()
			Console.separator()
			print(
				Console.color('red', 'WARNING !\n')
					.. 'StompMyFiles aims for pure brute strength, not performance !\nWii/GameCube games compressed with it may not perform well or malfunction under Dolphin until decompression.'
			)
			Console.separator()
			if stdio.prompt('confirm', 'Is this what you want ?') then
				Console.log('info', 'ISOs will be treated as Wii/GameCube games.')
				ISOHandling = 'Wii/GC'
			else
				process.exit(1)
			end
		end,
		['--version'] = function()
			print(
				string.format(
					'%s\nUniversal file compression utility, aiming for brute strength and ease of use.message\n(Also useful if you\'re freezing, since it may set your CPU or RAM on fire)\n\n%s\n%s',
					Console.color('red', Program.name .. ' version ' .. Program.version),
					'Developped by ' .. Console.color('yellow', Program.developer),
					Console.color('blue', Program.url)
				)
			)
			process.exit(0)
		end,
	}

	-- And the argument management
	local paths = {}
	for _, argument in ipairs(process.args) do
		local sequence: () -> () | nil = arguments[argument]
		if sequence then
			-- Argument exists
			sequence()
		else
			-- Argument doesn't exist, we assume the user is trying to open a file.
			if fs.metadata(argument).exists then
				if not table.find(paths, argument) then
					table.insert(paths, argument)
				else
					Console.log('info', 'File ' .. argument .. ' is already in the list. Skipping...')
				end
			else
				Console.log('warn', 'File or flag ' .. argument .. ' does not exist. Skipping...')
			end
		end
	end

	if #paths == 0 then
		Console.log('error', 'No valid input path specified.')
		process.exit(1)
	end

	return {
		paths = paths,
		settings = {
			ISOHandling = ISOHandling,
			ignoreSystemLibs = ignoreSystemLibs,
		},
	}
end

return Arguments
