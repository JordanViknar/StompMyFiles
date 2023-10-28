local bannedExtensions = {
	-- Lossy compressed picture formats
	"jpg",
	"jpeg",

	-- Lossy compressed audio formats
	"mp3",
	"opus",
	"aac",

	-- Unsupported compressed files
	"zip",
	"rar",
	"zstd",
	"gz",
	"bz2"
}

local bannedExtensionsDict = {}
for _,i in ipairs(bannedExtensions) do
	bannedExtensionsDict[i] = true
end
return bannedExtensionsDict
