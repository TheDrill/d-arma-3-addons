#include "addon.hpp"
#include "main.hpp"

if (!isDedicated) then
{
	[] spawn 
	{
		[] call CFUNC(_mainLoop);
	};
};
