// Made by Drill


#define PATH_PREFIX "\xx\addons\dmap_adv_markers\"

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
};


