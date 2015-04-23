#include "addon.hpp"
#include "main.hpp"

[] spawn
{

	if (isServer) then
	{
		GVAR(recreateAssembledWeapon) = objNull;
		
		'GVAR(recreateAssembledWeapon)' addPublicVariableEventHandler 
		{
			_weap = _this select 1;
			
			_p = getPosWorld _weap;
			_vd = getDir _weap;
			_vu = vectorUp _weap;
			_m = magazinesAmmo _weap;
			
			_vc =  typeOf _weap;
			
			deleteVehicle _weap;
			
			_nweap = _vc createVehicle [0,0,10000];
			
			_nweap setVectorUp _vu;
			_nweap setDir _vd;
			_nweap setPosWorld _p;
			
			_nweap setVehicleAmmo 0;
			
			{
				_nweap addMagazine _x;		
			} forEach _m;
			
			reload _nweap;			
		};
	};
	
	if (!isDedicated) then
	{
		[] spawn
		{
			sleep 0.1;
			
			_l_player = objNull;
			_l_eh = -1;
			
			while {true} do
			{
				if (player != _l_player) then
				{
					if (!isNull _l_player && _l_eh >= 0) then
					{
						_l_player removeEventHandler ["WeaponAssembled", _l_eh];
					};
					
					_l_player = player;
					
					if (!isNull player) then
					{
						_l_eh = player addEventHandler ["WeaponAssembled", {
							_weap = _this select 1;
							
							hideObject _weap;
							GVAR(recreateAssembledWeapon) = _weap;
							publicVariableServer 'GVAR(recreateAssembledWeapon)';
						}];
					};
				};
			
				sleep 10;
			};
		};		
	};	
};
