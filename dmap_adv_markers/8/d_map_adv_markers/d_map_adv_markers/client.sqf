// Made by Drill

#include "main.hpp"
#include "settings.hpp"









waitUntil {!(isNil 'V_SERVER_READY')};



GVAR(CSideMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];
GVAR(CCommandMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];
GVAR(CGroupMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];
GVAR(CGlobalMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];
GVAR(CVehicleMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];


GVAR(CTempMarkers) = [];
GVAR(CTempMarkersCount) = 0;


GVAR(CMarkerChannelToChar) = MARKER_CHANNEL_TO_CHAR_AR;


GVAR(CMarkerTagNameVisibility) = MTAG_DEFAULT_OPTIONS select 0;
GVAR(CMarkerTagChannelVisibility) = MTAG_DEFAULT_OPTIONS select 1;
GVAR(CLineMarkerTagNameVisibility) = MTAG_DEFAULT_OPTIONS select 2;
GVAR(CLineMarkerTagChannelVisibility) = MTAG_DEFAULT_OPTIONS select 3;


GVAR(CActivateAlternativeTagVisibilityModeKey) = MTAG_DEFAULT_KEY;


GVAR(CModKeyForLineMarkers) = DEFAULT_MOD_KEY_FOR_LINE_MARKERS;


if (!isNil "d_uac_fnc_registerParameter") then
{
	PV(_sect_name) = localize "STR_Addons__d_map_adv_markers__uac_section";


	PV(_enum_values_line_markers) = [
			["Shift", 4],
			["Ctrl", 5],
			["Alt", 6]
		];	

	['GVAR(CModKeyForLineMarkers)', _sect_name,
		localize "STR_Addons__d_map_adv_markers__uac_ModForLineMarkers", "",
		_enum_values_line_markers] call d_uac_fnc_registerEnumVariable;






	['GVAR(CActivateAlternativeTagVisibilityModeKey)', _sect_name, 
			localize "STR_Addons__d_map_adv_markers__uac_ActivateAltTagVisKey",
			""
		] call d_uac_fnc_registerKeyBindingVariable;
	
	




	PV(_enum_values) = [
			[localize "STR_Addons__d_map_adv_markers__opt_always_off", MTAG_ALWAYS_OFF],
			[localize "STR_Addons__d_map_adv_markers__opt_off", MTAG_OFF],
			[localize "STR_Addons__d_map_adv_markers__opt_on", MTAG_ON],
			[localize "STR_Addons__d_map_adv_markers__opt_always_on", MTAG_ALWAYS_ON]
		];

	{
		[_x select 0, _sect_name, localize (_x select 1), "", _enum_values] 
			call d_uac_fnc_registerEnumVariable;
	} forEach [
			['GVAR(CMarkerTagNameVisibility)',
				"STR_Addons__d_map_adv_markers__uac_MarkerTagNameVisibility"],
			['GVAR(CMarkerTagChannelVisibility)',
				"STR_Addons__d_map_adv_markers__uac_MarkerTagChannelVisibility"],				
			['GVAR(CLineMarkerTagNameVisibility)',
				"STR_Addons__d_map_adv_markers__uac_LineMarkerTagNameVisibility"],
			['GVAR(CLineMarkerTagChannelVisibility)',
				"STR_Addons__d_map_adv_markers__uac_LineMarkerTagChannelVisibility"]
		];
};


GVAR(CMarkerTagNameVisibilityTemporaryOn) = false;



// args: [marker array, base marker name]
FUNC(CapplyMarkerVisibility) =
{
	PV(_mar) = _this select 0;
	PV(_m) = _this select 1;
	
	PV(_text) = MAR_TEXT(_mar);
	
	// line marker
	if (count MAR_COORDS(_mar) > 1) then
	{
		if (  GVAR(CLineMarkerTagNameVisibility) == MTAG_ALWAYS_ON ||
			( !GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CLineMarkerTagNameVisibility) == MTAG_ON ) ||
			( GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CLineMarkerTagNameVisibility) == MTAG_OFF )
			 ) then
		{
			_text = MAR_NAME(_mar) + " " + _text;
		};


		if (  GVAR(CLineMarkerTagChannelVisibility) == MTAG_ALWAYS_ON ||
			( !GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CLineMarkerTagChannelVisibility) == MTAG_ON ) ||
			( GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CLineMarkerTagChannelVisibility) == MTAG_OFF )
			 ) then
		{
			_text = (GVAR(CMarkerChannelToChar) select MAR_CHAN(_mar)) + " " + _text;
		};
		
		
	}
	else // ordinal marker
	{
		
		if (  GVAR(CMarkerTagNameVisibility) == MTAG_ALWAYS_ON ||
			( !GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CMarkerTagNameVisibility) == MTAG_ON ) ||
			( GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CMarkerTagNameVisibility) == MTAG_OFF )
			 ) then
		{
			_text = MAR_NAME(_mar) + " " + _text;
		};


		if (  GVAR(CMarkerTagChannelVisibility) == MTAG_ALWAYS_ON ||
			( !GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CMarkerTagChannelVisibility) == MTAG_ON ) ||
			( GVAR(CMarkerTagNameVisibilityTemporaryOn) && GVAR(CMarkerTagChannelVisibility) == MTAG_OFF )
			 ) then
		{
			_text = (GVAR(CMarkerChannelToChar) select MAR_CHAN(_mar)) + " " + _text;
		};		
	};
		
		
	_m setMarkerTextLocal _text;
};










FUNC(CupdateProfileSettings) = 
{
	profileNamespace setVariable [PROFILE_MTAG_OPTION_VAR_NAME,
		[
			GVAR(CMarkerTagNameVisibility),
			GVAR(CMarkerTagChannelVisibility),
			GVAR(CLineMarkerTagNameVisibility),
			GVAR(CLineMarkerTagChannelVisibility)
		]];
	saveProfileNamespace;	
};







FUNC(CupdateAllMarkersVisibility) = 
{
	{
		PV(_y) = _x;
		PV(_ids) = _y getVariable ["ids", []];
		
		{
			PV(_mar) = _y getVariable [str _x, []];
			
			if (count _mar > 0) then
			{
				[_mar, M_MARKER(_x, 0)] call FUNC(CapplyMarkerVisibility);
			};
			
		} forEach _ids;
	
	} forEach [GVAR(CSideMarkersLogic), GVAR(CCommandMarkersLogic), GVAR(CGroupMarkersLogic), 
			   GVAR(CGlobalMarkersLogic), GVAR(CVehicleMarkersLogic)];	
};












// takes Marker id as the argument
RC_DEFINE(CDelLineMarker) =
{	
	
	PV(_dat) = [];
	
	{
		
		_dat = _x getVariable [str _this, []];
		
		if (count _dat > 0) then
		{
			for "_y" from 0 to ((count MAR_COORDS(_dat)) - 1) do
			{
				deleteMarkerLocal M_MARKER(_this, _y);
			};
			
			_x setVariable ["ids", (_x getVariable ["ids", []]) - [_this]];
			_x setVariable [str _this, []];
		};
	
	} forEach [GVAR(CSideMarkersLogic), GVAR(CCommandMarkersLogic), GVAR(CGroupMarkersLogic), 
			   GVAR(CGlobalMarkersLogic), GVAR(CVehicleMarkersLogic)];
	
	
	
	
	
	
};
RC_INIT_EH(CDelLineMarker);












FUNC(C_isMarkerVisibleToPlayer) = 
{
	MAR_CHAN(_this) == CHAN_GLOBAL   ||	
		(MAR_CHAN(_this) == CHAN_SIDE  &&  {MAR_CHANDATA(_this) == playerSide})   ||
		(MAR_CHAN(_this) == CHAN_COMMAND  &&  {MAR_CHANDATA(_this) == playerSide})   ||
		(MAR_CHAN(_this) == CHAN_GROUP  &&  {MAR_CHANDATA(_this) == group player})  ||
		(MAR_CHAN(_this) == CHAN_VEHICLE  &&  {MAR_CHANDATA(_this) == vehicle player});
};







FUNC(C_addMarkerToLogic) =
{
	PV(_mid) = _this select 0;
	PV(_dat) = _this select 1;
	PV(_logic) = _this select 2;
	
	_logic setVariable [str _mid, _dat];
	_logic setVariable ["ids", (_logic getVariable ["ids", []]) + [_mid]];	
};








// takes Marker array as the argument
RC_DEFINE(CAddLineMarker) = 
{
	
	
	
	
	private ["_mid", "_crd", "_crdc", "_t"];

	_mid = MAR_ID(_this);
	
	// delete previous marker with the same id if it happens somehow to be there
	_mid call RC_FUNC(CDelLineMarker);
	
	
	if ( _this call FUNC(C_isMarkerVisibleToPlayer) ) then
	{
		_crd = MAR_COORDS(_this);
		_crdc = count _crd;
		
		PV(_col) = MAR_COLOR(_this);
		PV(_th) = MAR_THICKNESS(_this);
		

		createMarkerLocal [M_MARKER(_mid, 0), _crd select 0];		
		M_MARKER(_mid, 0) setMarkerShapeLocal "ICON";
		M_MARKER(_mid, 0) setMarkerTypeLocal MAR_TYPE(_this);
		M_MARKER(_mid, 0) setMarkerColorLocal _col;
		
		[_this, M_MARKER(_mid, 0)] call FUNC(CapplyMarkerVisibility);
		
	/*	if (_crdc > 1) then
		{
			M_MARKER(_mid, 0) setMarkerDirLocal (
				[_crd select 0, _crd select 1] call FUNC(dirTo));
		}
		else
		{*/
		M_MARKER(_mid, 0) setMarkerDirLocal 0;
		//};
		
		
		for "_x" from 1 to (_crdc - 1) do
		{
			createMarkerLocal [M_MARKER(_mid, _x), [
				(((_crd select (_x-1)) select 0) + ((_crd select _x) select 0)) / 2,
				(((_crd select (_x-1)) select 1) + ((_crd select _x) select 1)) / 2
				] ];
				
			M_MARKER(_mid, _x) setMarkerShapeLocal "RECTANGLE";
			M_MARKER(_mid, _x) setMarkerColorLocal _col;
			M_MARKER(_mid, _x) setMarkerBrushLocal "Solid";
			M_MARKER(_mid, _x) setMarkerSizeLocal [ _th,
				( [_crd select (_x - 1), _crd select _x] call FUNC(distance2D) )/2 ];
			M_MARKER(_mid, _x) setMarkerDirLocal (
				[_crd select (_x - 1), _crd select _x] call FUNC(dirTo));
		};
		
		
		
		if (MAR_CHAN(_this) == CHAN_SIDE) then
		{
			[_mid, _this, GVAR(CSideMarkersLogic)] call FUNC(C_addMarkerToLogic);
		};

		if (MAR_CHAN(_this) == CHAN_COMMAND) then
		{
			[_mid, _this, GVAR(CCommandMarkersLogic)] call FUNC(C_addMarkerToLogic);
		};
			
		if (MAR_CHAN(_this) == CHAN_GROUP) then
		{
			[_mid, _this, GVAR(CGroupMarkersLogic)] call FUNC(C_addMarkerToLogic);
		};		
		
		if (MAR_CHAN(_this) == CHAN_GLOBAL) then
		{
			[_mid, _this, GVAR(CGlobalMarkersLogic)] call FUNC(C_addMarkerToLogic);
		};
		
		if (MAR_CHAN(_this) == CHAN_VEHICLE) then
		{
			[_mid, _this, GVAR(CVehicleMarkersLogic)] call FUNC(C_addMarkerToLogic);
		};
		
		
		
		
		
		// check if there's same temporary marker
		
		PV(_stoploop_flag) = false;
		
		{
			PV(_mar) = _x select 0;
			PV(_same) = true;
			
			
			PV(_i) = 0;
			for "_i" from 1 to ((count _this) - 2) do
			{
				if (_this select _i != _mar select _i) then
				{
					_same = false;
				};
				
			};

			PV(_c1) = MAR_COORDS(_this);
			PV(_c2) = MAR_COORDS(_mar);
			
			if (_same && count _c1 == count _c2) then
			{
				PV(_stoploop_flag_1) = false;
			
				for "_i" from 0 to ((count _c1) - 1) do
				{
					if ((_c1 select _i) select 0 != (_c2 select _i) select 0 ||
						(_c1 select _i) select 1 != (_c2 select _i) select 1) then
					{
						_same = false;
						_stoploop_flag_1 = true;
					};
					
					if (_stoploop_flag_1) exitWith {true};
				};
			}
			else
			{
				_same = false;
			};
			
			
			
			if (_same) then
			{
				_forEachIndex call FUNC(CRemoveTemporaryMarker);
				
				_stoploop_flag = true;
			};
			
			if (_stoploop_flag) exitWith {true};
			
		} forEach GVAR(CTempMarkers);
		
	};
	
	
	
	
	
};
RC_INIT_EH(CAddLineMarker);







FUNC(CRemoveTemporaryMarker) =
{
	PV(_mar) = (GVAR(CTempMarkers) select _this) select 0;
	PV(_mid) = -_this - 1;
	
	for "_y" from 0 to ((count MAR_COORDS(_mar)) - 1) do
	{
		deleteMarkerLocal M_MARKER(_mid, _y);
	};
	
	GVAR(CTempMarkers) set [_this, []];
	while {GVAR(CTempMarkersCount) > 0 &&
		{ count ( GVAR(CTempMarkers) select (GVAR(CTempMarkersCount) - 1))  == 0 }} do
	{
		GVAR(CTempMarkersCount) = GVAR(CTempMarkersCount) - 1;
	};
			
};





// takes Marker array as the argument 
FUNC(CAddLineMarker_Temporary) = 
{
	private ["_mid", "_crd", "_crdc", "_t"];

	_mid = - GVAR(CTempMarkersCount) - 1;
	GVAR(CTempMarkers) set [GVAR(CTempMarkersCount), [_this, diag_tickTime]];
	GVAR(CTempMarkersCount) = GVAR(CTempMarkersCount) + 1;
	
	
	
	_crd = MAR_COORDS(_this);
	_crdc = count _crd;
	
	PV(_col) = MAR_COLOR(_this);
	PV(_th) = MAR_THICKNESS(_this);
	

	createMarkerLocal [M_MARKER(_mid, 0), _crd select 0];		
	M_MARKER(_mid, 0) setMarkerShapeLocal "ICON";
	M_MARKER(_mid, 0) setMarkerTypeLocal MAR_TYPE(_this);
	M_MARKER(_mid, 0) setMarkerColorLocal _col;
	
	[_this, M_MARKER(_mid, 0)] call FUNC(CapplyMarkerVisibility);
	
/*	if (_crdc > 1) then
	{
		M_MARKER(_mid, 0) setMarkerDirLocal (
			[_crd select 0, _crd select 1] call FUNC(dirTo));
	}
	else
	{*/
	M_MARKER(_mid, 0) setMarkerDirLocal 0;
	//};
	
	
	for "_x" from 1 to (_crdc - 1) do
	{
		createMarkerLocal [M_MARKER(_mid, _x), [
			(((_crd select (_x-1)) select 0) + ((_crd select _x) select 0)) / 2,
			(((_crd select (_x-1)) select 1) + ((_crd select _x) select 1)) / 2
			] ];
			
		M_MARKER(_mid, _x) setMarkerShapeLocal "RECTANGLE";
		M_MARKER(_mid, _x) setMarkerColorLocal _col;
		M_MARKER(_mid, _x) setMarkerBrushLocal "Solid";
		M_MARKER(_mid, _x) setMarkerSizeLocal [ _th,
			( [_crd select (_x - 1), _crd select _x] call FUNC(distance2D) )/2 ];
		M_MARKER(_mid, _x) setMarkerDirLocal (
			[_crd select (_x - 1), _crd select _x] call FUNC(dirTo));
	};


	

};




// remove temporary markers by timeout
[] spawn 
{
	code = 
	{
		PV(_i) = 0;
		while {_i < GVAR(CTempMarkersCount)} do
		{
			PV(_t) = GVAR(CTempMarkers) select _i;
			if (count _t > 0 && {_t select 1 <
				diag_tickTime - TEMPORARY_MARKERS_TIMEOUT} ) then
			{
				_i call FUNC(CRemoveTemporaryMarker);
			}
			else
			{
				_i = _i + 1;
			};
		};
	};
	
	PV(_lasttick) = diag_tickTime;
	waitUntil
	{
		if (_lasttick + 1 < diag_tickTime) then
		{
			[] call code;
			_lasttick = diag_tickTime;
		};
		
		time > 0;
	};
	
	while {true} do
	{
		[] call code;
		sleep 1;
	};
	
};




// for JIP player
if (!isServer) then
{	
	[] spawn
	{
		waitUntil {!isNull player};

		#define RC_EXEC_ARG player
		RC_EXEC_S(SRequestMarkersForPlayer);
	};
};







