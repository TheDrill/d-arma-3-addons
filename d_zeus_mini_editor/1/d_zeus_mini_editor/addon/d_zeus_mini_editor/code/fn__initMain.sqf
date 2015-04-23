#include "addon.hpp"
#include "main.hpp"

#define PRIORITY -10

GVAR(curatorObj) = objNull;



[] spawn
{
	sleep 1;
	
	
	player addAction ["=====ZME=====", {}, nil,
		PRIORITY, false, false, ""];
	player addAction ["ZME begin", {[] call CFUNC(_activateZME)},
		nil, PRIORITY, false, true, "", 'isNull GVAR(curatorObj)'];
	player addAction ["ZME finalize", {[] call CFUNC(_storeZME)},
		nil, PRIORITY, false, true, "", '!(isNull GVAR(curatorObj))'];



	player addAction ["=============", {}, nil,
		PRIORITY, false, false, ""];




	player addAction ["Make all units playable", {[] call CFUNC(_makeAllPlayable)},
		nil, PRIORITY, false, true, ""];






	player addAction ["=============", {}, nil,
		PRIORITY, false, false, ""];



	player addAction ["Import all objects to ZME (ie add names of form __dzte_* to all objects). Reload of mission is needed to take effect", 
		{[] call CFUNC(_importObjs)}, nil, PRIORITY, false, true, ""];

	player addAction ["Clear all objects from ZME (ie remove names of form __dzte_* from all objects). Reload of mission is needed to take effect", 
		{[] call CFUNC(_unimportObjs)}, nil, PRIORITY, false, true, ""];



	
};
