local process = require('@lune/process')

return {
	name = 'StompMyFiles',
	executable = 'smf',
	version = '1.0.0-dev',
	developer = 'JordanViknar',
	url = 'https://github.com/JordanViknar/StompMyFiles',
	cacheFolder = process.env.HOME .. '/.cache/StompMyFiles/',
}
