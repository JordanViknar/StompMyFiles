local help = NAME.." Help Page\
\
Usage : "..EXECUTABLE.." [OPTIONS]... FILES\
(Yes, that's it. It's that simple.)\
\
Arguments :\
	--help : Displays this help page.\
	--verbose : Enable debug messages.\
	--version : Displays the version of the program.\
	--ignore-system : Ignore system executables.\
\
	--normal-iso : Treat ISOs as normal files.\
	--wii-gc : Treat ISOs as Wii/GameCube games.\
"

print(help)
