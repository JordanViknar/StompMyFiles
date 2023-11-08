-- External Modules
local lfs = require("lfs")

-- Module
local fsUtils = {}

--- Check if a file or directory exists
function fsUtils.exists(path)
	local attributes, err = lfs.attributes(path)
	if attributes then
		return true
	else
		return false, err
	end
end

-- Get the file extension
function fsUtils.getExtension(path)
	return path:match(".+%.(.+)")
end

-- Check if it's a folder
function fsUtils.isDirectory(path)
	local attributes, err = lfs.attributes(path)
	if attributes and attributes.mode == "directory" then
		return true
	else
		return false, err
	end
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
	return filename:match("(.+)%..+") or filename
end

-- Grab directory
function fsUtils.getDirectory(path)
	local directory = path:match("^(.+)/[^/]+$")
	return directory or "."
end

return fsUtils
