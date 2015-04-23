#include "addon.hpp"
#include "main.hpp"



#define CHECK_PREREQ (sunOrMoon <= 0.001 /*&& moonIntensity * (1 - (overcast + 0.1)) <= 0.35*/ && !isNull player && {alive player})
#define DEAD (isNull player || {!alive player})

#define ADDON_ENABLED (!(missionNamespace getVariable ["d_night_brighter__disable", false]))

#define BRIGHTNESS_STEP (0.2 / 60)
#define MAX_BRIGHTNESS 0.2


// light on/off managing thread
[] spawn
{
	_oef_fnc =
	{
		if (currentVisionMode player == 0) then
		{
			if (GVAR(br) != GVAR(last_br)) then
			{
				GVAR(lo) setLightBrightness GVAR(br);
				GVAR(last_br) = GVAR(br);
			};
		}
		else
		{
			if (GVAR(last_br) != 0) then
			{
				GVAR(lo) setLightBrightness 0;
				GVAR(last_br) = 0;
			};
		};
	};
	
	
	
	sleep 0.01;
	
	GVAR(lo) = objNull;
	GVAR(br) = 0;
	
	// it's dark at start of mission --- turn on the light fully at the beginning
	if (CHECK_PREREQ) then
	{
		GVAR(br) = MAX_BRIGHTNESS;
	};
	
	while {ADDON_ENABLED} do
	{
		
		if (!CHECK_PREREQ) then
		{
			waitUntil {
				sleep 2; 
//				hintSilent str ["_off", GVAR(br)];
				CHECK_PREREQ || !ADDON_ENABLED};
		};
		
		if (!ADDON_ENABLED) exitWith {};
		
		GVAR(lo) = "#lightpoint" createVehicleLocal [0,0,0];

		GVAR(lo) lightAttachObject [player, [0,0,0]];
		GVAR(lo) setLightAmbient [0.25,0.25,1];
		GVAR(lo) setLightAttenuation [0,100,10,0.01];
		
		GVAR(lo) setLightBrightness GVAR(br);
		GVAR(last_br) = GVAR(br);
		
		_last_player = player;
		
		_cp = CHECK_PREREQ;
		
		_l_time = diag_tickTime;
		
		['GVAR(OEF)', "onEachFrame", _oef_fnc, []] call BIS_fnc_addStackedEventHandler;
		
		while {ADDON_ENABLED && (GVAR(br) > 0 || _cp)} do
		{
			_t_delta = diag_tickTime - _l_time;
			_l_time = diag_tickTime;
			
//			hintSilent str ["_on", GVAR(br)];
			
			if (DEAD) then {
				GVAR(br) = 0
			}
			else
			{
				if (_last_player != player) then
				{
					_last_player = player;
					GVAR(lo) lightAttachObject [player, [0,0,0]];
				};
			};
			
			if (_cp) then
			{
				GVAR(br) = 0 max (MAX_BRIGHTNESS min (GVAR(br) + BRIGHTNESS_STEP * _t_delta));
			}
			else
			{
				GVAR(br) = 0 max (MAX_BRIGHTNESS min (GVAR(br) - BRIGHTNESS_STEP * _t_delta));
			};
			
			/////

			sleep 0.25;
			_cp = CHECK_PREREQ;
		};
		
		['GVAR(OEF)', "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		
		deleteVehicle GVAR(lo);
		GVAR(lo) = objNull;
	};
};
