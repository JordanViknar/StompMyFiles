local process = require('@lune/process')

local Console = require('@Utilities/Console')
local System = require('@Utilities/System')
local Tool = require('@Classes/Tool')

-- Variables
local allowedRAM = math.floor((System.getRAM() / 1024) * 0.6)

-- Properties

local name = 'xz'

local function compress(executable: string, file: string)
	Console.log('info', 'Compressing ' .. file .. ' using "' .. executable .. '" with ' .. allowedRAM .. 'GB of RAM.')
	local xz = process.spawn(executable, {
		'-z9e',
		'--threads=0',
		'--memlimit=' .. allowedRAM .. 'GB',
		file,
	})

	if not xz.ok then
		Console.visibleError('"xz" encountered an error : ' .. xz.stderr)
	end
end

local function decompress(executable: string, file: string)
	Console.log('info', 'Decompressing ' .. file .. ' using "' .. executable .. '" with ' .. allowedRAM .. 'GB of RAM.')
	local xz = process.spawn(executable, {
		'-d',
		'--threads=0',
		'--memlimit=' .. allowedRAM .. 'GB',
		file,
	})

	if not xz.ok then
		Console.visibleError('"xz" encountered an error : ' .. xz.stderr)
	end
end

return Tool.new(name, compress, decompress)
