#include "addon.hpp"
#include "main.hpp"

if (!(isNull GVAR(curatorObj))) then
{
	deleteVehicle GVAR(curatorObj);
};


GVAR(curatorObj) = "ModuleCurator_F" createVehicleLocal [0,0,0];
//GVAR(curatorObj) = (createGroup sideLogic) createUnit 
//	['ModuleCurator_F',[0,0,0],[],0,'NONE'];

player assignCurator GVAR(curatorObj);

sleep 2;
GVAR(curatorObj) addCuratorAddons activatedAddons;

//diag_log "@#$" + (curatorAddons GVAR(curatorObj));


PV(_editable_objs) = [];

{
	if ((isNull group _x) && {!((str (side _x)) in ["LOGIC", "ENEMY", "AMBIENT LIFE"])}) then
	{
		if (_x call CFUNC(_objText) != "none") then
		{
			_editable_objs pushBack _x;
		};
	};	
} forEach (entities "");


GVAR(curatorObj) addCuratorEditableObjects [_editable_objs, false]; 



hint "ZME is ready to use! Press 'Y' (or another assigned key) to open zeus interface. To save the changes to SQM file, activate 'ZME finalize' action.";
