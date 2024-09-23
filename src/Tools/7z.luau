local fs = require('@lune/fs')

local Console = require('@Utilities/Console')
local Filesystem = require('@Utilities/Filesystem')
local System = require('@Utilities/System')
local Tool = require('@Classes/Tool')

-- Properties

local name = '7z'

local function compress(executable: string, path: string)
	Console.log('debug', 'Getting number of CPU threads for 7z...')
	local cores = System.getCoreCount()
	Console.log('debug', 'Got ' .. cores .. ' threads.')

	Console.log('info', 'Compressing "' .. path .. '" using 7z with ' .. cores .. ' threads.')
	System.runExecutable(executable, {
		'-sdel',
		'-mx9',
		'-ms=on',
		'-mmt' .. cores,
		'a',
		path .. '.7z', -- Temporary
		path,
	})
end

local function decompress(executable: string, file: string)
	Console.log('info', 'Decompressing "' .. file .. '" using 7z.')
	System.runExecutable(executable, {
		'x',
		file,
		'-o' .. (Filesystem.getParent(file) or '.'),
		'-sdel',
	})
	fs.removeFile(file)
end

return Tool.new(name, compress, decompress)
