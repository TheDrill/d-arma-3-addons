#include "addon.hpp"
#include "main.hpp"

#define DEFVAL(x,y) x = missionNamespace getVariable ['x', (y)]

if (isServer) then
{
	
	// by default randomize initial direction and strength
	
	DEFVAL(GVAR(avgWindStr), 1 + 5 * (overcast));
	DEFVAL(GVAR(avgWindDir), random 360);
	DEFVAL(GVAR(windVector2Disp), 1 + (GVAR(avgWindStr) - 1) / 10);
	
	
	//diag_log [GVAR(avgWindDir), GVAR(avgWindStr), GVAR(windVector2Disp)];
	
	[] call CFUNC(_mainLoop);
};
