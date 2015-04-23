#include "addon.hpp"
#include "main.hpp"

#define DEFVAL(x,y) x = missionNamespace getVariable ['x', (y)]
#define SQR(x) ((x)*(x))


if (isServer) then {[] spawn
{
	sleep 0.1;
	
	DEFVAL(GVAR(avgWindStr), 1);
	DEFVAL(GVAR(avgWindDir), random 360);
	DEFVAL(GVAR(windVector2Disp), 1);
		
//	diag_log [GVAR(avgWindDir), GVAR(avgWindStr), GVAR(windVector2Disp)];
	
	PV(_cur_dev_vec) = [0, 0];
	PV(_mean_vec) = [0, 0];
	PV(_ux) = 0;
	PV(_uy) = 0;
	PV(_nx) = 0;
	PV(_ny) = 0;
	
	PV(_sig_eps) = 0;
	PV(_ar_par) = 0;
	
	PV(_wind) = [0, 0];
	PV(_last_set_wind) = [0, 0];
	
	PV(_wind_correction) = [0, 0];
	
	PV(_l_time) = diag_tickTime;
	PV(_agr_time) = 0;
	
	while {true} do
	{
		sleep 0.1;
		
		_agr_time = 3 min (_agr_time + diag_tickTime - _l_time);
		_l_time = diag_tickTime;
		
		while {_agr_time >= 1} do
		{
			_agr_time = _agr_time - 1;
		
			if (!(
					missionNamespace getVariable ["d_custom_dyn_wind__disable", false]
				)) then
			{
				_wind_correction = wind vectorDiff (_last_set_wind + [0]);
			
				// recalculating process parameters
				_sig_eps = GVAR(windVector2Disp) / 5;
				
				if (GVAR(windVector2Disp) > 0) then
				{
					_ar_par = sqrt(  1 - SQR( 2*_sig_eps/GVAR(windVector2Disp) )  );
				}
				else
				{
					_ar_par = 0;
				};

				
				_mean_vec = [GVAR(avgWindStr) * (sin GVAR(avgWindDir)),
										 GVAR(avgWindStr) * (cos GVAR(avgWindDir))];
				
				_cur_dev_vec = [(_wind select 0) - (_mean_vec select 0),
												(_wind select 1) - (_mean_vec select 1)];
				
				// generating 2 normal random variables _nx, _ny
				_ux = 1 - random 1;
				_uy = 1 - random 1;
				_nx = (cos (360 * _ux)) * (sqrt (- 2 * (ln _uy) ));
				_ny = (sin (360 * _ux)) * (sqrt (- 2 * (ln _uy)	));
				
				// calculating new wind vector
				_wind = [
					(_mean_vec select 0) + _sig_eps * _nx + _ar_par * (_cur_dev_vec select 0),
					(_mean_vec select 1) + _sig_eps * _ny + _ar_par * (_cur_dev_vec select 1)
				];
				
				_last_set_wind = [
					(_wind select 0) - (_wind_correction select 0),
					(_wind select 1) - (_wind_correction select 1)
				];
				
				setWind (_last_set_wind + [true]);
			
	//			hintSilent format["wds %1\nmv %2\nw %3\nv %4\np %5\ndv %6\ndvm %7\npp %8\nws %9\nwc %10", [sqrt(SQR(_wind select 0) + SQR(_wind select 1)), windDir], _mean_vec, wind, _wind, [_sig_eps, _ar_par], _cur_dev_vec, sqrt(SQR(_cur_dev_vec select 0) + SQR(_cur_dev_vec select 1)), [GVAR(avgWindStr), GVAR(windVector2Disp)], wind vectorDistance [0,0,0], _wind_correction];
			
			};
		};
	};
	
};};
