#include "addon.hpp"
#include "main.hpp"

// ang-to-hdr: -14 5.91
// 			   -10 7.39
// 			   - 9 7.54
// 			   - 8 7.70
// 			   - 6 7.80
// 			   - 2 8.00
// 			     0 9.00

#define POW(x,y) (exp ((ln (x)) * (y)));
#define HDR_POW_COEF 5

#define NORMAL_HDR 6.86
#define HDR_EST_TIME 10

#define CHECK_PREREQ (sunOrMoon < 0.35 /*&& moonIntensity * (1 - (overcast + 0.1)) <= 0.35*/ && !isNull player && {alive player})
#define DEAD (isNull player || {!alive player})

#define ADDON_ENABLED (!(missionNamespace getVariable ["d_night_brighter__disable", false]))


#define MAX_BRIGHTNESS 400
#define BRIGHTNESS_STEP (MAX_BRIGHTNESS / 60)


// light on/off managing thread
[] spawn
{
/*	_ang_to_hdr = [
			[-14, 5.91],
			[-10, 7.39],
			[- 9, 7.54],
			[- 8, 7.70],
			[- 6, 7.80],
			[- 2, 8.00],
			[  0, 9.00]
		];*/

	_ang_to_hdr = [
			[-14, 6.86],
			[-10, 7.22],
			[- 9, 7.6],
			[- 8, 8],
			[- 6, 9],
			[- 2, 10],
			[  0, 12]
		];
		
		
	_ang_to_hdr_last = (count _ang_to_hdr) - 1;
		
	GVAR(_cur_hdr_est) = NORMAL_HDR;
	_last_hdr_est_time = -HDR_EST_TIME;
	GVAR(_hdr_updated) = false;
	
/*	_i = 0;
	_nlconf = configFile >> "CfgWorlds" >> worldName >> "Weather" >> "LightingNew";
	
	_aper_mins = [];
	
	_le = 0;
	
	while {_le = _nlconf >> ("Lighting" + (str _i)); isClass _le} do
	{
		_aper_mins pushBack (getNumber (_le >> "apertureMin"));
		_i = _i + 1;
		
		diag_log getNumber (_le >> "apertureMin");
	};
	_aper_mins_l = count _aper_mins;
	
//	diag_log _aper_mins;
	diag_log _aper_mins_l;*/
	
	
	_oef_fnc =
	{
		if (currentVisionMode player == 0) then
		{
			if (GVAR(br) != GVAR(last_br) || GVAR(_hdr_updated)) then
			{
				GVAR(_hdr_updated) = false;
				
				private ["_mult"];
				
				_mult = POW( GVAR(_cur_hdr_est) / NORMAL_HDR, HDR_POW_COEF);
				
				GVAR(lo) setLightIntensity (GVAR(br) * _mult);
				GVAR(last_br) = GVAR(br);
			};
		}
		else
		{
			if (GVAR(last_br) != 0) then
			{
				GVAR(lo) setLightIntensity 0;
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
		GVAR(lo) setLightAmbient [0.5,0.5,1];
		GVAR(lo) setLightAttenuation [0,100,10,0.01];
		
		GVAR(lo) setLightIntensity GVAR(br);
		GVAR(last_br) = GVAR(br);
		
		_last_player = player;
		
		_cp = CHECK_PREREQ;
		
		_l_time = diag_tickTime;
		
		['GVAR(OEF)', "onEachFrame", _oef_fnc, []] call BIS_fnc_addStackedEventHandler;
		
		while {ADDON_ENABLED && (GVAR(br) > 0 || _cp)} do
		{
			_t_delta = diag_tickTime - _l_time;
			_l_time = diag_tickTime;
			
			
			
			
			
			
			
			
			
			
			// recalc HDR estimation
			if (_l_time - _last_hdr_est_time > HDR_EST_TIME) then
			{
				_last_hdr_est_time = _l_time;
				
				_cur_sun_ang_est = ([date, daytime] call CFUNC(_sunangle)) / 2;

				if (((_ang_to_hdr select 0) select 0) >= _cur_sun_ang_est) then
				{
					GVAR(_cur_hdr_est) = (_ang_to_hdr select 0) select 1;
				}
				else
				{	
					if (((_ang_to_hdr select _ang_to_hdr_last) select 0) <= _cur_sun_ang_est) then
					{
						GVAR(_cur_hdr_est) = (_ang_to_hdr select _ang_to_hdr_last) select 1;
					}
					else
					{
						for "_ii" from 1 to _ang_to_hdr_last do
						{
							_x0 = _ang_to_hdr select (_ii - 1);
							_x1 = _ang_to_hdr select _ii;
							
							if ((_x1 select 0) > _cur_sun_ang_est) exitWith
							{
								
								GVAR(_cur_hdr_est) = (_x0 select 1) + 
									((_x1 select 1) - (_x0 select 1)) *
									(_cur_sun_ang_est - (_x0 select 0)) /
									((_x1 select 0) - (_x0 select 0));
							};						
						};
					};
				};
				
				GVAR(_hdr_updated) = true;
//				_mult = POW(GVAR(_cur_hdr_est) / NORMAL_HDR, HDR_POW_COEF);
//				hint str [_mult, GVAR(_cur_hdr_est), _cur_sun_ang_est];
			};
			
			
			
			
			
			
			
			
			
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
