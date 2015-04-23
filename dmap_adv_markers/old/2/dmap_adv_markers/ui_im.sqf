// Made by Drill
disableSerialization;


#include "main.hpp"
#include "settings.hpp"




FUNC(UIUpdateIMMarker) = 
{
	_c = (findDisplay 54) displayCtrl 102;
	
	_c ctrlSetText (getText (configFile >> "CfgMarkers" >> GVAR(UIMarkerType) >> "icon"));
	_c ctrlSetTextColor getArray(configFile >> "CfgMarkerColors" >> GVAR(UIMarkerColor) >> "color");
	
};






FUNC(UIInitIM) =
{
	[] call FUNC(UIUpdateIMMarker);
};











FUNC(IMOnKeyDown) =
{
	// hotkey
	PV(_hotkeyact) = GVAR(UIHotkeysLogic) getVariable [
		(_this call FUNC(UIKeyCombToString)), []];
		
	PV(_send_to_channel) = -1;
	
	if (count _hotkeyact > 0) then
	{
		if (_hotkeyact select 0 == "marker") then 
		{
			GVAR(UIMarkerType) = _hotkeyact select 1;
			[] call FUNC(UIUpdateIMMarker);
		};


		if (_hotkeyact select 0 == "color") then 
		{
			GVAR(UIMarkerColor) = _hotkeyact select 1;
			[] call FUNC(UIUpdateIMMarker);
		};


		if (_hotkeyact select 0 == "send") then 
		{
			_send_to_channel = _hotkeyact select 1;
		};
	};
	
	
	
	// alt (left or right)
	if ((_this select 1) in [56, 184]) then
	{
		GVAR(CMarkerTagNameVisibilityTemporaryOn) = true;
		[] call FUNC(CupdateAllMarkersVisibility);				
	};
		
	
	
	// up --- change marker type ++
	if (_this select 1 == 200 && !(_this select 2)) then
	{
		if (GVAR(UIMarkerType) in GVAR(UIMarkerTypes)) then
		{
			PV(_i) = 0;
			while {GVAR(UIMarkerType) != GVAR(UIMarkerTypes) select _i  &&
				_i < count GVAR(UIMarkerTypes)} do
			{
				_i = _i + 1;
			};
			
			GVAR(UIMarkerTypeID) = _i + 1;
			if (GVAR(UIMarkerTypeID) >= count GVAR(UIMarkerTypes)) then
			{
				GVAR(UIMarkerTypeID) = 0;
			};
		};

		GVAR(UIMarkerType) = GVAR(UIMarkerTypes) select GVAR(UIMarkerTypeID);
		[] call FUNC(UIUpdateIMMarker);
	};
	


	// down --- change marker type --
	if (_this select 1 == 208 && !(_this select 2)) then
	{
		if (GVAR(UIMarkerType) in GVAR(UIMarkerTypes)) then
		{
			PV(_i) = 0;
			while {GVAR(UIMarkerType) != GVAR(UIMarkerTypes) select _i  &&
				_i < count GVAR(UIMarkerTypes)} do
			{
				_i = _i + 1;
			};
			
			GVAR(UIMarkerTypeID) = _i - 1;
			if (GVAR(UIMarkerTypeID) < 0) then
			{
				GVAR(UIMarkerTypeID) = (count GVAR(UIMarkerTypes)) - 1;
			};
		};
		
		GVAR(UIMarkerType) = GVAR(UIMarkerTypes) select GVAR(UIMarkerTypeID);
		[] call FUNC(UIUpdateIMMarker);
	};
	





	// shift+up -- cycle color ++
	if (_this select 1 == 200 && (_this select 2)) then
	{
		if (GVAR(UIMarkerColor) in GVAR(UIMarkerColors)) then
		{
			PV(_i) = 0;
			while {GVAR(UIMarkerColor) != GVAR(UIMarkerColors) select _i  &&
				_i < count GVAR(UIMarkerColors)} do
			{
				_i = _i + 1;
			};
			
			GVAR(UIMarkerColorID) = _i + 1;
			if (GVAR(UIMarkerColorID) >= count GVAR(UIMarkerColors)) then
			{
				GVAR(UIMarkerColorID) = 0;
			};
		};
		
		GVAR(UIMarkerColor) = GVAR(UIMarkerColors) select GVAR(UIMarkerColorID);
		[] call FUNC(UIUpdateIMMarker);
	};




	// shift+down -- cycle color--
	if (_this select 1 == 208 && (_this select 2)) then
	{
		if (GVAR(UIMarkerColor) in GVAR(UIMarkerColors)) then
		{
			PV(_i) = 0;
			while {GVAR(UIMarkerColor) != GVAR(UIMarkerColors) select _i  &&
				_i < count GVAR(UIMarkerColors)} do
			{
				_i = _i + 1;
			};
			
			GVAR(UIMarkerColorID) = _i - 1;
			if (GVAR(UIMarkerColorID) < 0) then
			{
				GVAR(UIMarkerColorID) = (count GVAR(UIMarkerColors)) - 1;
			};
		};
		
		GVAR(UIMarkerColor) = GVAR(UIMarkerColors) select GVAR(UIMarkerColorID);
		[] call FUNC(UIUpdateIMMarker);
	};
	
	
	
	
	// enter --- place the marker
	if (_this select 1 == 28 || _send_to_channel >= 0) then
	{
		PV(_chan) = GVAR(UICurrentChannel);
		if (_send_to_channel >= 0) then
		{
			_chan = _send_to_channel;
		};
		
		PV(_text) = ctrlText ((findDisplay 54) displayCtrl 101);
		PV(_val) = [ -1, _chan, _chan call FUNC(UIgetPlayerChanData),
			name player, _text, GVAR(UIMarkerType),
			GVAR(UIMarkerColor), GVAR(UIMarkerThick), [GVAR(UIMouseMapPosDblClick)] ];
				
		_val call FUNC(CAddLineMarker_Temporary);
				
		#define RC_EXEC_ARG _val
		RC_EXEC_S(SAddLineMarker);
		
		(findDisplay 54) closeDisplay 0;		
	};




	
	
	
	!(_this select 1 in [1, 14, 211, 203, 205, 199, 207]) &&
	!(_this select 1 == 46 && !(_this select 2) && (_this select 3) && !(_this select 4)) &&
	!(_this select 1 == 47 && !(_this select 2) && (_this select 3) && !(_this select 4));
};








FUNC(IMOnKeyUp) = 
{
	// alt (left or right)
	if ((_this select 1) in [56, 184]) then
	{
		GVAR(CMarkerTagNameVisibilityTemporaryOn) = false;
		[] call FUNC(CupdateAllMarkersVisibility);
	};


	!(_this select 1 in [1, 14, 211, 203, 205, 199, 207]) &&
	!(_this select 1 == 46 && !(_this select 2) && (_this select 3) && !(_this select 4)) &&
	!(_this select 1 == 47 && !(_this select 2) && (_this select 3) && !(_this select 4));
};











while {true} do
{
	waitUntil {!isNull (findDisplay 54)};
	
	_d = findDisplay 54;
	
	[] call FUNC(UIInitIM);
	_d displayAddEventHandler ["KeyUp", '_this call FUNC(IMOnKeyUp)'];
	_d displayAddEventHandler ["KeyDown", '_this call FUNC(IMOnKeyDown)'];	
	


	//////////////////////////////
	// For tu_markers support
	//////////////////////////////
	
	if (isClass (configFile >> "CfgPatches" >> "tu_markers") &&
		!isNil "c_persistent_markers_markerHandle") then
	{
	
		_d displayAddEventHandler ["KeyDown", '
			if(_this select 1 == 28 && _this select 3) then
			{
				[_this select 0] call c_persistent_markers_markerHandle;
				
				(findDisplay 54) closeDisplay 0;
				
				true;
			}
			else
			{
				false;
			};
		'];
		
	};
	
	//////////////////////////////
	//
	//////////////////////////////


	
	waitUntil {isNull (findDisplay 54)};
};
