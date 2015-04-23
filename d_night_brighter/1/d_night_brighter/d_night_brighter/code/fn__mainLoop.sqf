#include "addon.hpp"
#include "main.hpp"



#define CHECK_PREREQ (sunOrMoon <= 0.001 /*&& moonIntensity * (1 - (overcast + 0.1)) <= 0.35*/ && !isNull player && {alive player})
#define DEAD (isNull player || {!alive player})

#define ADDON_ENABLED (!(missionNamespace getVariable ["d_night_brighter__disable", false]))

#define BRIGHTNESS_STEP (0.2 / 60 / 10)
#define MAX_BRIGHTNESS 0.2


// light on/off managing thread
[] spawn
{
	sleep 0.01;
	
	_lo = objNull;
	_br = 0;
	
	// it's dark at start of mission --- turn on the light fully at the beginning
	if (CHECK_PREREQ) then
	{
		_br = MAX_BRIGHTNESS;
	};
	
	while {ADDON_ENABLED} do
	{
		
		if (!CHECK_PREREQ) then
		{
			waitUntil {
				sleep 2; 
//				hintSilent str ["_off", _br];
				CHECK_PREREQ || !ADDON_ENABLED};
		};
		
		if (!ADDON_ENABLED) exitWith {};
		
		_lo = "#lightpoint" createVehicleLocal [0,0,0];

		_lo lightAttachObject [player, [0,0,0]];
		_lo setLightAmbient [0.25,0.25,1];
		_lo setLightAttenuation [0,100,10,0.01];
		
		_lo setLightBrightness _br;
		_last_br = _br;
		
		_last_player = player;
		
		_cp = CHECK_PREREQ;
		while {ADDON_ENABLED && (_br > 0 || _cp)} do
		{
//			hintSilent str ["_on", _br];
			
			if (DEAD) then {
				_br = 0
			}
			else
			{
				if (_last_player != player) then
				{
					_last_player = player;
					_lo lightAttachObject [player, [0,0,0]];
				};
			};
			
			if (_cp) then
			{
				_br = 0 max (MAX_BRIGHTNESS min (_br + BRIGHTNESS_STEP));
			}
			else
			{
				_br = 0 max (MAX_BRIGHTNESS min (_br - BRIGHTNESS_STEP));
			};
			
			if (currentVisionMode player == 0) then
			{
				if (_br != _last_br) then
				{
					_lo setLightBrightness _br;
					_last_br = _br;
				};
			}
			else
			{
				if (_last_br != 0) then
				{
					_lo setLightBrightness 0;
					_last_br = 0;
				};
			};

			sleep 0.1;
			_cp = CHECK_PREREQ;
		};
		
		deleteVehicle _lo;
		_lo = objNull;
	};
};
