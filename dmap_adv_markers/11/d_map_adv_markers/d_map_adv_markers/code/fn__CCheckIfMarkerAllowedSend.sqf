// receives [marker]

#include "main.hpp"

#define CUT_LAYER 2344223

PV(_mark) = _this select 0;

/*
if (MAR_CHAN(_mark) in [CHAN_VEHICLE, CHAN_DIRECT]) exitWith {true};

if (MAR_CHAN(_mark) == CHAN_GROUP) exitWith
{
	if (time == 0 || {[] call TFAR_fnc_haveSWRadio}) then
	{
		true
	}
	else
	{
		CUT_LAYER cutText [
			localize "STR_Addons__d_map_adv_markers__send_not_allowed_grou_chan", 
			"PLAIN", 0.2, true];

		false;
	};
};

if (MAR_CHAN(_mark) in [CHAN_SIDE, CHAN_COMMAND] ) exitWith 
{
	if (time == 0 || {[] call TFAR_fnc_haveLRRadio}) then
	{
		true
	}
	else
	{
		if (MAR_CHAN(_mark) == CHAN_SIDE) then
		{
			CUT_LAYER cutText [
				localize "STR_Addons__d_map_adv_markers__send_not_allowed_side_chan", 
				"PLAIN", 0.2, true];
		}
		else
		{
			CUT_LAYER cutText [
				localize "STR_Addons__d_map_adv_markers__send_not_allowed_comm_chan",
				"PLAIN", 0.2, true];
		};
		
		false;
	};
};
*/

if (MAR_CHAN(_mark) == CHAN_GLOBAL) exitWith
{
	CUT_LAYER cutText [
		localize "STR_Addons__d_map_adv_markers__send_not_allowed_glob_chan", 
		"PLAIN", 0.2, true];
	false;

};

true;
