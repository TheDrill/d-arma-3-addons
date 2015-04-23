#include "addon.hpp"
#include "main.hpp"



//#define STAND_TURN_LIMIT (360*3.5)
//#define CROUCH_TURN_LIMIT (360*2)
#define PRONE_TURN_LIMIT (180)

//#define RUN_TURN_LIMIT_COEF (0.7)
//#define SPRINT_TURN_LIMIT_COEF (0.35)

#define NULL_DIR -1000

GVAR(last_dir) = NULL_DIR;
GVAR(last_time) = time;

['GVAR(turn_rate_limit)', "onEachFrame",{
	if ( (!isNull player) && {(alive player) &&
		(player == vehicle player)} ) then
	{
		PV(_cur_time) = time;
		PV(_time_delta) = (_cur_time - GVAR(last_time)) max 0.001;
		GVAR(last_time) = _cur_time;
		
		
		if (GVAR(last_dir) == NULL_DIR) then
		{
			GVAR(last_dir) = getDir player;
		};
		
		PV(_dir_delta) = (getDir player) - GVAR(last_dir);
		
		
		if (_dir_delta <= -180) then
		{	
			_dir_delta = _dir_delta + 360;
		};
		
		if (_dir_delta > 180) then
		{	
			_dir_delta = _dir_delta - 360;
		};
				
		
		PV(_turn_limit) = _time_delta;
		
		switch (stance player) do
		{
			//~ case "STAND": {
					//~ _turn_limit = _turn_limit * STAND_TURN_LIMIT;
				//~ };
			//~ case "CROUCH": {
					//~ _turn_limit = _turn_limit * CROUCH_TURN_LIMIT;
				//~ };
			case "PRONE": {
					_turn_limit = _turn_limit * PRONE_TURN_LIMIT;
				};
				
				
			default {
					_turn_limit = -1;
				};
		};
		
		
		
		//~ hintsilent format["turn_limit: %1, tdelta: %2",
				//~ _turn_limit, _time_delta
			//~ ];
		
		
		if (_turn_limit > 0) then
		{
			if (_dir_delta < -_turn_limit) then
			{
				player setDir (GVAR(last_dir) - _turn_limit);
			};

			if (_dir_delta > _turn_limit) then
			{
				player setDir (GVAR(last_dir) + _turn_limit);
			};
		};

		GVAR(last_dir) = getDir player;
	}
	else
	{
		GVAR(last_dir) = NULL_DIR;
	};
	
}] call BIS_fnc_addStackedEventHandler;
