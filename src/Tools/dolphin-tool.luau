local process = require('@lune/process')

local Console = require('@Utilities/Console')
local Filesystem = require('@Utilities/Filesystem')
local System = require('@Utilities/System')
local Tool = require('@Classes/Tool')

-- Variables
local allowedRAM = math.floor((System.getRAM() / 1024) * 0.6)

-- Properties

local name = 'dolphin-tool'

local function compress(executable: string, file: string)
	Console.log('info', 'Compressing ' .. file .. ' using "' .. executable .. '".')
	Console.visibleError('Unimplemented...')

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
		'-o', -- Unfinished
	})

	if dolphin_tool.ok then
		print(dolphin_tool.stdout)
	else
		Console.visibleError('"dolphin-tool" encountered an error : ' .. dolphin_tool.stderr)
	end
end

local function decompress(executable: string, file: string)
	Console.log('info', 'Decompressing ' .. file .. ' using "' .. executable .. '".')
	Console.visibleError('Unimplemented...')

	local dolphin_tool = process.spawn(executable, {
		'convert',
		'-f',
		'iso',
		'-i',
		file,
		'-o', -- Unfinished
	})

	if dolphin_tool.ok then
		print(dolphin_tool.stdout)
	else
		Console.visibleError('"dolphin-tool" encountered an error : ' .. dolphin_tool.stderr)
	end
end

return Tool.new(name, compress, decompress)
