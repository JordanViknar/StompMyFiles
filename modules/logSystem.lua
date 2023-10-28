local logSystem = {}

local function color(color, message)
	local colorList = {
		["red"] = "\27[31m",
		["green"] = "\27[32m",
		["yellow"] = "\27[33m",
		["blue"] = "\27[34m",
		["magenta"] = "\27[35m",
		["cyan"] = "\27[36m",
		["white"] = "\27[37m",
		["grey"] = "\27[90m",
		["orange"] = "\27[91m",
		["reset"] = "\27[0m"
	}

	return colorList[color]..message..colorList["reset"]
end

function logSystem.log(type, message)
	local logReactions = {
		["info"] = function(message)
			print("["..color("blue","Info").."] "..message)
		end,
		["warning"] = function(message)
			print("["..color("yellow","Warning").."] "..color("yellow",message))
		end,
		["error"] = function(message)
			print(color("red","[Error]").." "..color("red",message))
		end,
		["debug"] = function(message)
			if ARGUMENTS and ARGUMENTS.settings.verboseEnabled == true then
				print("["..color("grey","Debug").."] "..color("grey",message))
			end
		end,
		["switch"] = function (message)
			print(color("green","[Output Switch] "..message))
			print("--------------------------")
		end,
		["switchEnd"] = function (message)
			print("--------------------------")
		end,
		["download"] = function (message)
			print("["..color("green","Download").."] "..message)
		end
	}

	if (logReactions[type]) then
		logReactions[type](message)
	else
		error("Unknown log type : "..type)
	end
end

return logSystem
