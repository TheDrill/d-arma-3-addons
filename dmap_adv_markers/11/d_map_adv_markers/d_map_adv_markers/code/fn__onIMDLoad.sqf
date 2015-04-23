#include "addon.hpp"
#include "main.hpp"

disableSerialization;

uiNamespace setVariable ['GVAR(UIIM_display)', _this select 0];
uiNamespace setVariable ['GVAR(UIIM_text_ctrl)', (_this select 0) displayCtrl 101];
uiNamespace setVariable ['GVAR(IMDisplay_shown)', true];

uiNamespace setVariable ['GVAR(needToInitIMD)', true];


	
	
//////////////////////////////
// For tu_markers support
//////////////////////////////

if (//isClass (configFile >> "CfgPatches" >> "tu_markers") &&
	!isNil "c_persistent_markers_markerHandle") then
{

	(_this select 0) displayAddEventHandler ["KeyDown", '
		if (time > 600) then
		{
			false;
		}
		else
		{
			if(_this select 1 == 28 && _this select 3) then
			{
				[_this select 0] call c_persistent_markers_markerHandle;
				
				(findDisplay 54) closeDisplay 0;
				
				true;
			}
			else
			{
				false;
			};
		};
	
	'];
	
};

//////////////////////////////
//
//////////////////////////////
