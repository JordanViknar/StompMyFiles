local process = require('@lune/process')

local Console = require('@Utilities/Console')

local System = {}

function System.getRAM(): number
	local free = process.spawn('free', { '-m' })
	if free.ok then
		local ram = tonumber(free.stdout:match('Mem:%s+(%d+)'))
		if ram then
			return ram
		else
			return Console.visibleError('"free -m" process couldn\'t be parsed for RAM count.')
		end
	else
		return Console.visibleError('"free -m" process failed : ' .. free.stderr)
	end
end

function System.isExecutableInPATH(executable: string): boolean
	return process.spawn('which', { executable }).ok
end

return System
