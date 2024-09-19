local Filesystem = {}

function Filesystem.getFileExtension(path: string): string?
	return path:match('[^/]+%.([^.]+)$')
end

function Filesystem.getFileName(path: string): string?
	return path:match('([^/]+)$')
end

function Filesystem.stripExtension(path: string): string?
	local dotPosition = path:match('^.*()%.%w+$')
	if dotPosition then
		return path:sub(1, dotPosition - 1)
	else
		return nil
	end
end

return Filesystem
