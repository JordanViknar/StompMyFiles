local systemUtils = {}

-- Custom modules
local logSystem = require("modules.logSystem")

function systemUtils.checkPlatform()
	if (os.execute("uname -m | grep 'x86_64' > /dev/null 2>&1") == true) then
		return "x64"
	elseif (os.execute("uname -m | grep 'x86' > /dev/null 2>&1") == true) then
		return "x86"
	elseif (os.execute("uname -m | grep 'aarch64' > /dev/null 2>&1") == true) then
		return "arm64"
	elseif (os.execute("uname -m | grep 'arm' > /dev/null 2>&1") == true) then
		return "arm"
	else
		logSystem.log("error", "Could not determine processor platform... Can't use local install method.")
		return nil
	end
end

function systemUtils.isInternetAvailable()
	local internetTest = os.execute("ping -q -c 1 1.1.1.1")
	if internetTest == true then
		logSystem.log("debug", "Internet connection is available.")
		return true
	else
		logSystem.log("warning", "Internet connection is not available.")
		return false
	end
end

return systemUtils
