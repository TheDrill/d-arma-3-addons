// Made by Drill
disableSerialization;


#include "main.hpp"
#include "settings.hpp"

#define CHECK_DISPLAY(x) (  !(isNull (findDisplay (x))) && {!(isNull ((findDisplay (x)) displayCtrl 51))}  )


#define M_TEMP_MARKER(i) ("_dMapLineMarkerSys_Temp_Marker_" + (str (i)))

#define MARK_SCALE_RELATED_THICKNESS() ( (ctrlMapScale ({if (CHECK_DISPLAY(_x))\
	exitWith{(findDisplay(_x)) displayCtrl 51};} forEach [12, 37, 52, 53])) * 30)


GVAR(UIMousePos) = [0, 0];
GVAR(UILineMarkerChanToType) = LINE_MARKER_CHANNEL_TO_TYPE_AR;


GVAR(UIPoints) = [];















FUNC(UIClearMarkers) =
{
	for "_x" from 0 to ((count GVAR(UIPoints)) - 1) do
	{
		deleteMarkerLocal M_TEMP_MARKER(_x);
	};
	
	GVAR(UIPoints) = [];
};




FUNC(UIUpdateMarkersParams) =
{
	PV(_scale) = MARK_SCALE_RELATED_THICKNESS();
	
	for "_x" from 0 to ((count GVAR(UIPoints)) - 1) do
	{
		M_TEMP_MARKER(_x) setMarkerColorLocal GVAR(UIMarkerColor);
		
		if (_x > 0) then
		{
			M_TEMP_MARKER(_x) setMarkerSizeLocal [ GVAR(UIMarkerThick) * _scale,
				(getMarkerSize M_TEMP_MARKER(_x)) select 1 ];
		};
	};
};













FUNC(UIKeyDown) =
{
	// diag_log text ("UIKeyUp " +  str(_this));
	
	private ["_grp", "_val", "_i", "_mcrd", "_dat", "_crd"];
	
	PV(_force_handled) = false;



// hotkey
	PV(_hotkeyact) = GVAR(UIHotkeysLogic) getVariable [
		(_this call FUNC(UIKeyCombToString)), []];
		
	PV(_send_to_channel) = -1;
	
	if (count _hotkeyact > 0) then
	{
		if (_hotkeyact select 0 == "color") then 
		{
			GVAR(UIMarkerColor) = _hotkeyact select 1;
			[] call FUNC(UIUpdateMarkersParams);
			_force_handled = true;
		};


		if (_hotkeyact select 0 == "send") then 
		{
			_send_to_channel = _hotkeyact select 1;
			_force_handled = true;
		};
		
	};
	
	
	
	
	
	
	// shift (left or right)
	if ((_this select 1) in [42, 54]) then
	{
		GVAR(CMarkerTagNameVisibilityTemporaryOn) = true;
		[] call FUNC(CupdateAllMarkersVisibility);				
	};
	
	
	
	
	
	
	
	// escape
	if (_this select 1 == 1 && count GVAR(UIPoints) > 0) then
	{
		[] call FUNC(UIClearMarkers);
		_force_handled = true;
	};
	
	
	
	
	
	
	// backspace
	if (_this select 1 == 14 && count GVAR(UIPoints) > 0) then
	{
		if (count GVAR(UIPoints) == 1) then
		{		
			[] call FUNC(UIClearMarkers);
		}
		else
		{
			deleteMarkerLocal M_TEMP_MARKER((count GVAR(UIPoints)) - 1);
			GVAR(UIPoints) resize ((count GVAR(UIPoints)) - 1);
		};
	};	






	// enter
	if ((_this select 1 == 28 || _send_to_channel >= 0) && count GVAR(UIPoints) > 0) then
	{
		if (count GVAR(UIPoints) > 1) then
		{
			PV(_chan) = GVAR(UICurrentChannel);
			if (_send_to_channel >= 0) then
			{
				_chan = _send_to_channel;
			};
			
			PV(_scale) = MARK_SCALE_RELATED_THICKNESS();
			
			// check main.hpp for marker array format
			_val = [-1, _chan, _chan call FUNC(UIgetPlayerChanData),
				name player, "", GVAR(UILineMarkerChanToType) select _chan,
				GVAR(UIMarkerColor), GVAR(UIMarkerThick) * _scale, GVAR(UIPoints)];
				
			_val call FUNC(CAddLineMarker_Temporary);				
				
			#define RC_EXEC_ARG _val
			RC_EXEC_S(SAddLineMarker);
		};

		[] call FUNC(UIClearMarkers);

		_force_handled = true;
	};





	
	// delete
	if (_this select 1 == 211) then
	{
		_i = 0;
		
		PV(_ctrl) = {if (CHECK_DISPLAY(_x)) 
			exitWith{(findDisplay(_x)) displayCtrl 51};} forEach [12, 37, 52, 53];
			
		
		_mcrd = GVAR(UIMousePos);
		
		PV(_allmarkers) = [];
		
		{
			PV(_y) = _x;
			{
				 PV(_t) = _y getVariable [str _x, []];
				 if (count _t > 0) then
				 {
					 _allmarkers set [count _allmarkers, _t];
				 };
			} forEach (_y getVariable ["ids", []]);
		} forEach [GVAR(CSideMarkersLogic), GVAR(CCommandMarkersLogic), GVAR(CGroupMarkersLogic),
				   GVAR(CGlobalMarkersLogic), GVAR(CVehicleMarkersLogic)];
				
		
		PV(_stoploop_flag) = false;
		
		{
	
			_crd = _ctrl ctrlMapWorldToScreen (MAR_COORDS(_x) select 0);

			

			
			if ([_mcrd, _crd] call FUNC(distance2Dsqr) < DISTANCE_TO_MARKER_TO_DELETE_SQR) then
			{
				if (_x call FUNC(C_isMarkerVisibleToPlayer)) then
				{ // remove marker globally
					#define RC_EXEC_ARG [MAR_ID(_x), MAR_CHAN(_x), MAR_CHANDATA(_x)]
					RC_EXEC_S(SDelLineMarker);
				};
				
				// remove marker locally
				MAR_ID(_x) call RC_FUNC(CDelLineMarker);
				
				_stoploop_flag = true;
			};
			
			if (_stoploop_flag) exitWith {true};

		} forEach _allmarkers;
	};
	


	
	
	
	// changing color/thickness
	
	if (count GVAR(UIPoints) > 0) then
	{
		// right -- more thickness
		if (_this select 1 == 205) then
		{
			GVAR(UIMarkerThickID) = GVAR(UIMarkerThickID) + 1;
			
			if (GVAR(UIMarkerThickID) >= count GVAR(UIMarkerThicks)) then
			{
				GVAR(UIMarkerThickID) = 0;
			};
			
			GVAR(UIMarkerThick) = GVAR(UIMarkerThicks) select GVAR(UIMarkerThickID);
			[] call FUNC(UIUpdateMarkersParams);
		};

		// left -- less thickness
		if (_this select 1 == 203) then
		{
			GVAR(UIMarkerThickID) = GVAR(UIMarkerThickID) - 1;
			
			if (GVAR(UIMarkerThickID) < 0) then
			{
				GVAR(UIMarkerThickID) = (count GVAR(UIMarkerThicks)) - 1;
			};
			
			GVAR(UIMarkerThick) = GVAR(UIMarkerThicks) select GVAR(UIMarkerThickID);
			[] call FUNC(UIUpdateMarkersParams);
		};
		
		
		
		// down -- cycle color
		if (_this select 1 == 208) then
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
			[] call FUNC(UIUpdateMarkersParams);
		};

		// up -- cycle color
		if (_this select 1 == 200) then
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
			[] call FUNC(UIUpdateMarkersParams);
		};		
	};


	
	
	if (_force_handled ||
		( (count GVAR(UIPoints) > 0) && ((_this select 1) in [200, 208, 203, 205, 14, 28, 1]) )) then
	{
		[] call compile format['GVAR(UIKeyDownCodeHandeled_%1) = true', _this select 1];
		
		true
	}
	else
	{
		false
	};
};
















FUNC(UIKeyUp) =
{
	// shift (left or right)
	if ((_this select 1) in [42, 54]) then
	{
		GVAR(CMarkerTagNameVisibilityTemporaryOn) = false;
		[] call FUNC(CupdateAllMarkersVisibility);
	};

	
	PV(_varname) = format['GVAR(UIKeyDownCodeHandeled_%1)', _this select 1];
	
	if (([] call compile format["isNil ""%1""", _varname]) || !([] call compile _varname)) then
	{
		false;
	}
	else
	{
		[] call compile format["%1 = false;", _varname];
		true;
	};
};







FUNC(UIOnMouseUp) =
{
	private ["_coord", "_ptid", "_lcoord"];

	// diag_log text ("UIOnMouseUp " +  str(_this));

	// left mouse button
	if ((_this select 1) == 0) then
	{
		_coord = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];
			
		if (count GVAR(UIPoints) == 0) then // first point
		{
			// is control down
			if(_this select 5) then
			{
				GVAR(UIPoints) = [_coord];
				
				
				createMarkerLocal [M_TEMP_MARKER(0), _coord];
				M_TEMP_MARKER(0) setMarkerShapeLocal "ICON";
				M_TEMP_MARKER(0) setMarkerTypeLocal "mil_dot";
				M_TEMP_MARKER(0) setMarkerColorLocal GVAR(UIMarkerColor);
				M_TEMP_MARKER(0) setMarkerSizeLocal [2, 2];
				M_TEMP_MARKER(0) setMarkerTextLocal "";
			}
		}
		else // adding new point
		{
			_ptid = count GVAR(UIPoints);
			_lcoord = GVAR(UIPoints) select ( _ptid - 1 );
			GVAR(UIPoints) set [ _ptid, _coord ];
			
			createMarkerLocal [M_TEMP_MARKER(_ptid), [
				((_lcoord select 0) + (_coord select 0)) / 2,
				((_lcoord select 1) + (_coord select 1)) / 2
				] ];
				
			M_TEMP_MARKER(_ptid) setMarkerShapeLocal "RECTANGLE";
			M_TEMP_MARKER(_ptid) setMarkerColorLocal GVAR(UIMarkerColor);
			M_TEMP_MARKER(_ptid) setMarkerBrushLocal  "Solid";
			M_TEMP_MARKER(_ptid) setMarkerSizeLocal [ GVAR(UIMarkerThick),
				( [_lcoord, _coord] call FUNC(distance2D) )/2 ];
			M_TEMP_MARKER(_ptid) setMarkerDirLocal (
				[_lcoord, _coord] call FUNC(dirTo));			
		};
	};
	
	false;
};









FUNC(UIOnMouseMove) =
{
	GVAR(UIMousePos) = [_this select 1, _this select 2];
	
	false;
};



FUNC(UIOnMouseButtonDblClick) =
{
	GVAR(UIMouseMapPosDblClick) = (_this select 0) ctrlMapScreenToWorld [_this select 2, _this select 3];
	
	false;
};








// client might have display 53 here, server - 52
waitUntil{ time > 0 || { CHECK_DISPLAY(52) || {CHECK_DISPLAY(53)} ||
	{CHECK_DISPLAY(37)} } };




if (time <= 0) then
{ 
	{
		if ( CHECK_DISPLAY(_x) ) then
		{
			(findDisplay _x) displayAddEventHandler ["KeyUp", '_this call FUNC(UIKeyUp);'];
			(findDisplay _x) displayAddEventHandler ["KeyDown", '_this call FUNC(UIKeyDown);'];
			((findDisplay _x) displayCtrl 51) ctrlAddEventHandler ["mouseButtonUp", '_this call FUNC(UIOnMouseUp);'];
			((findDisplay _x) displayCtrl 51) ctrlAddEventHandler ["mouseMoving", '_this call FUNC(UIOnMouseMove);'];
			((findDisplay _x) displayCtrl 51) ctrlAddEventHandler ["mouseButtonDblClick", '_this call FUNC(UIOnMouseButtonDblClick);'];
		};	
	} forEach [52, 53, 37];
};

sleep 1;

waitUntil{sleep 1; CHECK_DISPLAY(12) };

(findDisplay 12) displayAddEventHandler  ["KeyUp", 
	'if (visibleMap) then {_this call FUNC(UIKeyUp);};'];
(findDisplay 12) displayAddEventHandler  ["KeyDown", 
	'if (visibleMap) then {_this call FUNC(UIKeyDown);};'];
((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["mouseButtonUp", 
	'if (visibleMap) then {_this call FUNC(UIOnMouseUp);};'];
((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["mouseMoving", 
	'if (visibleMap) then {_this call FUNC(UIOnMouseMove);};'];
((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["mouseButtonDblClick",
	'if (visibleMap) then {_this call FUNC(UIOnMouseButtonDblClick);};'];


while {true} do
{
	waitUntil{sleep 0.25; visibleMap};
	waitUntil{sleep 0.25; !visibleMap};
	[] call FUNC(UIClearMarkers);
	
	if (GVAR(CMarkerTagNameVisibilityTemporaryOn)) then
	{
		GVAR(CMarkerTagNameVisibilityTemporaryOn) = false;
		[] call FUNC(CupdateAllMarkersVisibility);
	};
}
