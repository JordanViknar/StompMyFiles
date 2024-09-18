local fs = require('@lune/fs')

local Filesystem = {}

function Filesystem.getFileExtension(path: string): string?
	return path:match('[^/]+%.([^.]+)$')
end

function Filesystem.getFileName(path: string): string?
	return path:match('([^/]+)$')
end

return Filesystem
