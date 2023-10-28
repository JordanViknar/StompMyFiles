-- Custom Modules
local fsUtils = require("modules.fsUtils")

-- Definitions
local compressorManager = {}

function compressorManager.selectCompressionTool(compressorType)
	local systemTest = os.execute("which "..compressorType.." > /dev/null 2>&1")
	if ((systemTest == 0 or systemTest == true) and ARGUMENTS.settings.ignoreSystemLibs == false) then
		return compressorType
	elseif(fsUtils.exists(CACHE_FOLDER..compressorType.."/"..compressorType)) then
		return CACHE_FOLDER..compressorType.."/"..compressorType
	else
		error("Could not find "..compressorType.." in the system or in the local cache.")
	end
end

return compressorManager
