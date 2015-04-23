#include "addon.hpp"
#include "main.hpp"

#define RECOIL_SCALE 3
#define RECOIL_FADING_COEF 0.25

#define RECOIL_MAX_COEF 5

GVAR(last_player) = objNull;
GVAR(last_eh) = objNull;

GVAR(last_rec_coef) = 1;
GVAR(cur_rec_level) = 0;

GVAR(last_time) = 0;


[] spawn
{
	while {true} do 
	{
		if (GVAR(last_player) != player && !isNull player && {alive player}) then
		{
			if (!isNull GVAR(last_player) && {alive GVAR(last_player)}) then
			{
				GVAR(last_player) removeEventHandler ["Fired", GVAR(last_eh)];
			};
			
			GVAR(last_player) = player;
			
			GVAR(last_rec_coef) = 1;
			GVAR(cur_rec_level) = 0;
			
			
			GVAR(last_eh) = player addEventHandler ["Fired", {
				GVAR(cur_rec_level) = GVAR(cur_rec_level) * POW(RECOIL_FADING_COEF, time - GVAR(last_time))
					+ 1;
				GVAR(last_time) = time;
				
				PV(_coef) = (0 max (GVAR(cur_rec_level)-1)) / RECOIL_SCALE
					* ((random 2) - 1);
				
				_coef = (1+RECOIL_MAX_COEF) min ((1-RECOIL_MAX_COEF) max (1 - _coef));
				
				(_this select 0) setUnitRecoilCoefficient ( (unitRecoilCoefficient (_this select 0)) *
					_coef / GVAR(last_rec_coef) );
					
					
				GVAR(last_rec_coef) = _coef;
				
				//~ hintSilent format ["%1\n%2\n%3\n%4",
					//~ (GVAR(cur_rec_level) - 1), (GVAR(cur_rec_level) - 1) / RECOIL_SCALE,
					//~ GVAR(last_rec_coef), unitRecoilCoefficient (_this select 0)];
				
			}];
		};
		
		sleep 1;
	};
};
