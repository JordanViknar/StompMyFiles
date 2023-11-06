local fsUtils = {}

--- Check if a file or directory exists
function fsUtils.exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			return true
		end
	end
	return ok, err
end

-- Get the file extension
function fsUtils.getExtension(path)
	return path:match(".+%.(.+)")
end

-- Check if it's a folder
function fsUtils.isDirectory(path)
	return fsUtils.exists(path.."/")
end

-- Grab file name
function fsUtils.getFileName(path)
	local filename = path:match("^.+/(.+)$")
	if filename then
		return filename
	else
		return path
	end
end

-- Grab file name without extension
function fsUtils.getFileNameNoExt(path)
	local filename = fsUtils.getFileName(path)
	local filenameWithoutExtension = filename:match("(.+)%..+")
	if filenameWithoutExtension then
		return filenameWithoutExtension
	else
		return filename
	end
end

-- Grab directory
function fsUtils.getDirectory(path)
	local directory = path:match("^(.+)/[^/]+$")
	if directory then
		return directory
	else
		return "."
	end
end

return fsUtils
