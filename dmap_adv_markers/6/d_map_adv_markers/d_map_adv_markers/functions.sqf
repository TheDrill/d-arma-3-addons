#include "main.hpp"

// based on BIS_fnc_dirTo
FUNC(dirTo) =
{
	private ["_pos1","_pos2","_ret"];

	_pos1 = _this select 0;
	_pos2 = _this select 1;

	//get compass heading from _pos1 to _pos2
	_ret = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));
	_ret = _ret % 360; //ensure return is 0-360
	_ret
};



// based on BIS_fnc_distance2Dsqr
FUNC(distance2Dsqr) =
{
	private ["_pos1","_pos2"];

	_pos1 = _this select 0;
	_pos2 = _this select 1;

	//if objects, not positions, were passed in, then get their positions
	if(typename _pos1 == "OBJECT") then {_pos1 = getpos _pos1};
	if(typename _pos2 == "OBJECT") then {_pos2 = getpos _pos2};

	//return SQUARED distance between _pos1 and _pos2
	(
		((_pos1 select 0) - (_pos2 select 0))^2 +
		((_pos1 select 1) - (_pos2 select 1))^2
	)
};


// based on BIS_fnc_distance2Dsqr
FUNC(distance2D) =
{
	sqrt(_this call FUNC(distance2Dsqr))
};

