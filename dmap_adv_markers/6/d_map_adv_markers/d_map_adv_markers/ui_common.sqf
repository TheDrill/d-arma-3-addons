disableSerialization;


#include "main.hpp"
#include "settings.hpp"


GVAR(UICurrentChannel) = CHAN_GROUP;













GVAR(UIMarkerTypes) = [];

_cfgt = configFile >> "CfgMarkers";
for "_i" from 0 to ((count _cfgt) - 1) do
{
	if (getNumber ((_cfgt select _i) >> "scope") > 1) then
	{
		GVAR(UIMarkerTypes) set [count GVAR(UIMarkerTypes), configName (_cfgt select _i)];
	};
};
GVAR(UIMarkerTypeID) = 0;
GVAR(UIMarkerType) = GVAR(UIMarkerTypes) select GVAR(UIMarkerTypeID);







GVAR(UIMarkerColors) = CLIENT_MARKER_COLOR_AR;
/*_cfgt = configFile >> "CfgMarkerColors";
for "_i" from 0 to ((count _cfgt) - 1) do
{
	GVAR(UIMarkerColors) set [count GVAR(UIMarkerColors), configName (_cfgt select _i)];
};*/

GVAR(UIMarkerColorID) = 0;
GVAR(UIMarkerColor) = GVAR(UIMarkerColors) select GVAR(UIMarkerColorID);





GVAR(UIMarkerThicks) = CLIENT_MARKER_THICKNESS_AR;
GVAR(UIMarkerThickID) = CLIENT_MARKER_DEFAULT_THICKNESS;
GVAR(UIMarkerThick) = GVAR(UIMarkerThicks) select GVAR(UIMarkerThickID);













GVAR(UIMouseMapPosDblClick) = [0, 0];













// update current chat channel (see fn__onEachFrameBody.sqf)
GVAR(str_c_gr) = localize "str_channel_group";
GVAR(str_c_si) = localize "str_channel_side";
GVAR(str_c_gl) = localize "str_channel_global";
GVAR(str_c_ve) = localize "str_channel_vehicle";
GVAR(str_c_co) = localize "str_channel_command";
GVAR(str_c_di) = localize "str_channel_direct";

GVAR(str_localized_cur_channel) = GVAR(str_c_gl);






FUNC(UIgetPlayerChanData) =
{
	_retval = objNull;
	if (_this == CHAN_GROUP) then {_retval = group player};
	if (_this == CHAN_SIDE) then {_retval = playerSide};
	if (_this == CHAN_COMMAND) then {_retval = playerSide};
	if (_this == CHAN_GLOBAL) then {_retval = ""};
	if (_this == CHAN_VEHICLE) then {_retval = vehicle player};

	
	_retval;
};









GVAR(UIHotkeysLogic) = "Logic" createVehicleLocal [-10000,-10000,0];



FUNC(UIKeyCombToString) =
{
	PV(_shift) = if (_this select 2) then {1} else {0};
	PV(_ctrl) = if (_this select 3) then {1} else {0};
	PV(_alt) = if (_this select 4) then {1} else {0};
	format["%1_%2%3%4", _this select 1, _shift, _ctrl, _alt];	
};



[] spawn  
{
	PV(_lines) = USERCONFIG_PATH call FUNC(readConfigFile);
	
	{
		
		if (count _x >= 2) then
		{
			PV(_ok) = false;
			PV(_hk) = false;
			
			PV(_type) = _x select 0;
			

			PV(_val) = _x select 1;
			
			if (_type == "markerslist") then
			{
				_ok = true;
				_hk = false;
			
				GVAR(UIMarkerTypes) = [];
				
				for "_i" from 1 to ((count _x) - 1) do
				{
					if (isClass (configFile >> "CfgMarkers" >> (_x select _i) )) then
					{
						GVAR(UIMarkerTypes) set [_i - 1, _x select _i];
					};
				};
				
				GVAR(UIMarkerTypeID) = 0;
				GVAR(UIMarkerType) = GVAR(UIMarkerTypes) select GVAR(UIMarkerTypeID);
			
			
			};
			
			if (_type == "colorslist") then
			{
				_ok = true;
				_hk = false;
			
				GVAR(UIMarkerColors) = [];
				
				for "_i" from 1 to ((count _x) - 1) do
				{
					if (isClass (configFile >> "CfgMarkerColors" >> (_x select _i) )) then
					{
						GVAR(UIMarkerColors) set [_i - 1, _x select _i];
					};
				};
				
				GVAR(UIMarkerColorID) = 0;
				GVAR(UIMarkerColor) = GVAR(UIMarkerColors) select GVAR(UIMarkerColorID);
			
			};
			
			if (_type == "send") then
			{ 
				_hk = true;
				_ok = true;
			
				PV(_t) = "";
				if (_val == "global") then {_t = CHAN_GLOBAL};
				if (_val == "side") then {_t = CHAN_SIDE};
				if (_val == "command") then {_t = CHAN_COMMAND};
				if (_val == "group") then {_t = CHAN_GROUP};
				if (_val == "vehicle") then {_t = CHAN_VEHICLE};
				if (_val == "direct") then {_t = CHAN_VEHICLE}; // not implemented
				
				if (typeName _t != "SCALAR") then
				{
					_ok = false;
				}
				else
				{
					_val = _t;
				};
			};
			
			
			if (_type == "marker" && {isClass(configFile >> "CfgMarkers" >> _val)}) then
			{
				_hk = true;
				_ok = true;
			};

			if (_type == "color" && {isClass(configFile >> "CfgMarkerColors" >> _val)}) then
			{
				_hk = true;
				_ok = true;
			};
			
			
			
			if (_ok && _hk && (count _x >= 3)) then
			{
				
				PV(_keycode) = parseNumber (_x select 2); // call FUNC(StringToNumber);
				
				if (typeName _keycode != "SCALAR") then
				{
					_ok = false;
				};
				
				PV(_shift) = false;
				PV(_ctrl) = false;
				PV(_alt) = false;
				
				for "_i" from 3 to ((count _x) - 1) do
				{
					if (_x select _i == "shift") then {_shift = true;};
					if (_x select _i == "ctrl") then {_ctrl = true;};
					if (_x select _i == "alt") then {_alt = true;};
				};
		
				GVAR(UIHotkeysLogic) setVariable [
					[0, _keycode, _shift, _ctrl, _alt] call FUNC(UIKeyCombToString),
					[_type, _val] ];
			};
		};
		
		
	} forEach _lines;
	
};







