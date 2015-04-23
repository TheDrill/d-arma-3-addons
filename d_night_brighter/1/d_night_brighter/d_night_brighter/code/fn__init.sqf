#include "addon.hpp"
#include "main.hpp"

if (!isDedicated) then
{
	[] call CFUNC(_mainLoop);
};
