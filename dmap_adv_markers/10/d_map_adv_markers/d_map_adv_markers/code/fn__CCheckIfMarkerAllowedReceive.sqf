// receives [marker, additional data]

// if time == 0, this function won't be called (assummed to return true always)

#include "main.hpp"

PV(_mark) = _this select 0;

/*
if (MAR_CHAN(_mark) in [CHAN_SIDE, CHAN_COMMAND] ) exitWith 
{
	if ([] call TFAR_fnc_haveLRRadio) then
	{
		true;
	}
	else
	{
		((getPosASL player) vectorDistance (getPosASL (_this select 1))) <
			MAX_DISTANCE_FOR_DIRECT;
	};
};

if (MAR_CHAN(_mark) == CHAN_GROUP ) exitWith 
{
	if ([] call TFAR_fnc_haveSWRadio) then
	{
		((getPosASL player) vectorDistance (getPosASL (_this select 1))) <
			MAX_DISTANCE_FOR_GROUP;
	}
	else
	{
		((getPosASL player) vectorDistance (getPosASL (_this select 1))) <
			MAX_DISTANCE_FOR_DIRECT;
	};
};

if (MAR_CHAN(_mark) == CHAN_DIRECT ) exitWith
{
	((getPosASL player) vectorDistance (getPosASL (_this select 1))) <
		MAX_DISTANCE_FOR_DIRECT;
};
*/

true;
