#include "addon.hpp"
#include "main.hpp"

#define ADDITIONAL_HEIGHT 0.5
#define NEW_VEHICLE_INVULN_TIME 2


[] spawn
{

	if (isServer) then
	{
		GVAR(recreateAssembledWeapon) = objNull;
		
		
		FUNC(SRAWHandler) = {
			_weap = _this select 1;
			
			_p = getPosWorld _weap;
			_vd = getDir _weap;
			_vu = vectorUp _weap;
			_m = magazinesAmmo _weap;
			
			_vc =  typeOf _weap;
			
			deleteVehicle _weap;
			
			// create it a bit above original point
			_p set [2, (_p select 2) + ADDITIONAL_HEIGHT];
			
			_nweap = _vc createVehicle [0,0,10000];
			
			_nweap allowDamage false;
			
			_nweap setVectorUp _vu;
			_nweap setDir _vd;
			_nweap setPosWorld _p;
			
			_nweap setVehicleAmmo 0;
			
			{
				_nweap addMagazine _x;		
			} forEach _m;
			
			reload _nweap;	
			
			_nweap spawn
			{
				sleep NEW_VEHICLE_INVULN_TIME;
				_this allowDamage true;
			};		
		};
		
		'GVAR(recreateAssembledWeapon)' addPublicVariableEventHandler FUNC(SRAWHandler);
	};
	
	if (hasInterface) then
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
							
							if (isServer) then
							{
								[0, GVAR(recreateAssembledWeapon)] call FUNC(SRAWHandler);
							}
							else
							{
								publicVariableServer 'GVAR(recreateAssembledWeapon)';
							};
						}];
					};
				};
			
				sleep 10;
			};
		};		
	};	
	
	
};
