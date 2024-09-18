local ProgramMetadata = require('@Metadata/Program')

return ProgramMetadata.name
	.. ' Help Page\
\
Usage : '
	.. ProgramMetadata.executable
	.. ' [OPTIONS]... FILES\
\
Arguments :\
	--help : Displays this help page.\
	--version : Displays the version of the program.\
	--ignore-system : Ignore system executables.\
	--wii-gc : Treat ISOs as Wii/GameCube games.\
'
