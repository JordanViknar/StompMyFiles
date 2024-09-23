local process = require('@lune/process')

local Console = require('@Utilities/Console')

local System = {}

function System.runExecutable(process_name: string, arguments: { string }?): string
	local run = process.spawn(process_name, arguments)
	if run.ok then
		return run.stdout
	else
		return Console.visibleError(string.format('"%s" process failed : %s', process_name .. table.concat(arguments or {}, ' '), run.stderr))
	end
end

function System.getRAM(): number
	return tonumber(System.runExecutable('free', { '-m' }):match('Mem:%s+(%d+)'))
		or Console.visibleError('"free -m" process couldn\'t be parsed for RAM count.')
end

function System.isExecutableInPATH(executable: string): boolean
	return process.spawn('which', { executable }).ok
end

function System.getCoreCount(): number
	return tonumber(System.runExecutable('nproc')) or Console.visibleError('"nproc" process couldn\'t be parsed for core count.')
end

return System
