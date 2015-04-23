#include "addon.hpp"
#include "main.hpp"

[] spawn
{
	[] call CFUNC(_comm);
};


if (hasInterface) then
{
	[] spawn 
	{
		[] call CFUNC(_conf);
		[] call CFUNC(_mainLoop);
	};
};


