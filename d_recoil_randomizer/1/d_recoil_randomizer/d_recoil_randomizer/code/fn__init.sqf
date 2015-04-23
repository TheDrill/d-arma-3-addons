#include "addon.hpp"
#include "main.hpp"

[] spawn
{
	if (!isDedicated) then
	{
		sleep 0.1;

		[] call CFUNC(_mainLoop);
	};
};
