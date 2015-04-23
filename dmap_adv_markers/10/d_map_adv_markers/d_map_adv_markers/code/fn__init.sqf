// Made by Drill
#include "main.hpp"

#define PATH_PREFIX "\xx\addons\d_map_adv_markers\"

[] spawn
{

	[] call compile preprocessFileLineNumbers (PATH_PREFIX + "persistentMarkers.sqf");

	if (!isDedicated) then
	{
		[] call compile preprocessFileLineNumbers (PATH_PREFIX + "config_reader.sqf");
		[] call compile preprocessFileLineNumbers (PATH_PREFIX + "ui_common.sqf");
	};

	[] call compile preprocessFileLineNumbers (PATH_PREFIX + "functions.sqf");

	if (isServer) then
	{
		[] call compile preprocessFileLineNumbers (PATH_PREFIX + "server.sqf");
	};

	if (!isDedicated) then
	{
		[] call compile preprocessFileLineNumbers (PATH_PREFIX + "client.sqf");
		execVM (PATH_PREFIX + "ui_map.sqf");
		execVM (PATH_PREFIX + "ui_im.sqf");
		
		['GVAR(oef_main)', "onEachFrame", CFUNC(_onEachFrameBody)] call BIS_fnc_addStackedEventHandler;
	};


};
