local fs = require('@lune/fs')
local process = require('@lune/process')

local Console = require('@Utilities/Console')
local Filesystem = require('@Utilities/Filesystem')
local Tool = require('@Classes/Tool')

-- Properties

local name = 'dolphin-tool'

local function compress(executable: string, file: string)
	Console.log('info', 'Compressing "' .. file .. '" using "' .. executable .. '".')

	local dolphin_tool = process.spawn(executable, {
		'convert',
		'-f',
		'rvz',
		'-c',
		'lzma2',
		'-l',
		'9',
		'-b',
		'2097152',
		'-i',
		file,
		'-o',
		(Filesystem.stripExtension(file) or file) .. '.rvz',
	})

	if dolphin_tool.ok then
		fs.removeFile(file)
	else
		Console.visibleError('"dolphin-tool" encountered an error : ' .. dolphin_tool.stderr)
	end
end

local function decompress(executable: string, file: string)
	Console.log('info', 'Decompressing "' .. file .. '" using "' .. executable .. '".')

	local dolphin_tool = process.spawn(executable, {
		'convert',
		'-f',
		'iso',
		'-i',
		file,
		'-o',
		(Filesystem.stripExtension(file) or file) .. '.iso',
	})

	if dolphin_tool.ok then
		fs.removeFile(file)
	else
		Console.visibleError('"dolphin-tool" encountered an error : ' .. dolphin_tool.stderr)
	end
end

return Tool.new(name, compress, decompress)
