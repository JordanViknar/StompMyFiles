local stdio = require('@lune/stdio')

type Color = 'black' | 'blue' | 'cyan' | 'green' | 'purple' | 'red' | 'reset' | 'white' | 'yellow'
type LogType = 'info' | 'warn' | 'error' | 'debug' | 'data' | 'speed' | 'special' | 'success'

local Console = {}

function Console.color(color: Color, text: string): string
	return stdio.color(color) .. text .. stdio.color('reset')
end

function Console.log(type: LogType, message: string | number)
	local time = os.date('%H:%M:%S')

	local logFunctions = {
		info = function(text)
			print(time .. ' - [' .. Console.color('blue', 'Info') .. '] : ' .. text)
		end,
		warn = function(text)
			print(time .. ' - [' .. Console.color('yellow', 'Warn') .. '] : ' .. Console.color('yellow', text))
		end,
		error = function(text)
			print(time .. ' - ' .. Console.color('red', '[Error] : ' .. text))
		end,
		debug = function(text)
			print(time .. ' - [' .. Console.color('white', 'Debug') .. '] : ' .. Console.color('white', text))
		end,
		data = function(text)
			print(time .. ' - [' .. Console.color('purple', 'Data') .. '] : ' .. text)
		end,
		speed = function(startTime)
			print(time .. ' - [' .. Console.color('white', 'Speed') .. '] : ' .. 'Done in ' .. os.clock() - startTime .. ' seconds.')
		end,
		success = function(text)
			print(time .. ' - [' .. Console.color('green', 'Success') .. '] : ' .. text)
		end,
	}

	logFunctions[type](message)
end

function Console.separator()
	print('---------------------------------------------------------------')
end

function Console.visibleError(text: string): any
	Console.log('error', text)
	error(text)
end

return Console
