#include "addon.hpp"
#include "main.hpp"

#define DEFVAL(x,y) x = missionNamespace getVariable ['x', (y)]

if (isServer) then
{
	[] spawn {
		// by default randomize initial direction and strength
		
		_world_min = getNumber (configFile >> "CfgWorlds" >> worldName >> "Weather" >> "WindConfig" >> "minForce");
		_world_max = getNumber (configFile >> "CfgWorlds" >> worldName >> "Weather" >> "WindConfig" >> "maxForce");
		
		_world_min = _world_min max 0;
		_world_max = _world_max max 5;
		
		
		DEFVAL(GVAR(avgWindStr), 1 max (_world_min + (_world_max - _world_min) * (overcast)));
		DEFVAL(GVAR(avgWindDir), random 360);
		DEFVAL(GVAR(windVector2Disp), (GVAR(avgWindStr) - 1) / 2 + 1);
		
		
//		diag_log [GVAR(avgWindDir), GVAR(avgWindStr), GVAR(windVector2Disp), overcast, _world_min, _world_max, worldName];
		
		[] call CFUNC(_mainLoop);
	
	};
};
