local fs = require('@lune/fs')

local Arguments = require('@Utilities/Arguments')
local BannedExtensions = require('@Metadata/BannedExtensions')
local Console = require('@Utilities/Console')
local Filesystem = require('@Utilities/Filesystem')
local Program = require('@Metadata/Program')
local Tools = require('@Tools/')

local Application = {}

function Application.start()
	-- Check cache folder
	if not fs.metadata(Program.cacheFolder).exists then
		Console.log('debug', 'Creating StompMyFiles folder in cache...')
		fs.writeDir(Program.cacheFolder)
	end

	local setup = Arguments.detect()

	Console.log('debug', 'Beginning main function...')

	local filesSkipped = 0

	for _, path in ipairs(setup.paths) do
		if not Application.handlePath(path) then
			filesSkipped += 1
		end
	end

	if filesSkipped ~= 0 then
		if filesSkipped == #setup.paths then
			Console.log('error', 'All files/folders were skipped.')
		else
			Console.log('warn', 'One or more files/folders were skipped.')
		end
	end
end

function Application.handlePath(path: string) : boolean
	if fs.isDir(path) then
		-- For now, SMF only compresses the folder without recursively travelling it to compress files.
		Console.log('debug', 'Path ' .. path .. ' is a directory. Using 7z...')

		return true
	elseif fs.isFile(path) then
		-- The extension is our current way to determine which tool to use.
		local extension = Filesystem.getFileExtension(path)
		if extension == nil then
			Console.log('info', 'File "' .. path .. '" has no extension. Assuming it\'s a compiled executable...')
		else
			Console.log('debug', 'File "' .. path .. '" uses extension "' .. extension .. '".')
		end

		-- We check the file isn't banned.
		if extension and table.find(BannedExtensions, extension) then
			Console.log('warn', 'File "' .. path .. '" will not compress well. Skipping...')
			return false
		end

		-- Using a switch to determine the tool to use.
		local switch = {
			-- Compress
			['iso'] = nil,

			-- Decompress
			['7z'] = nil,
			['xz'] = nil,
			['rvz'] = nil,
		}
		local func: ((string) -> (boolean))? = switch[extension]
		if func then
			return func(path)
		else
			-- We rely on xz as a fallback to unsupported extensions.
			if extension ~= nil then
				Console.log('debug', 'No particular behavior defined for "' .. extension .. '". Relying on default compression behavior...')
			else
				Console.log('debug', 'No particular behavior defined for files without extension (yet). Relying on default compression behavior...')
			end
			-- Run XZ compression here.

			return false
		end
	else
		Console.log('error', 'Unknown problem with path "' .. path .. '".')
		return false
	end
end

return Application
