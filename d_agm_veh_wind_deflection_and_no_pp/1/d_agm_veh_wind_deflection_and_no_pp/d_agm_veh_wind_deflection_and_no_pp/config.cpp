class CfgPatches
{
	class d_agm_veh_wind_deflection_and_no_pp
	{
		units[]={};
		weapons[]={};
		requiredAddons[]={"AGM_Wind"};
		author[]=
		{
			"Drill"
		};
		addon_version=1;
	};
};

#define FUNCTIONS__RECOMPILE 0

class CfgFunctions
{
	class d_agm_veh_wind_deflection_and_no_pp
	{
		class Main
		{
			file="\xx\addons\d_agm_veh_wind_deflection_and_no_pp\code";
			class _init
			{
				preInit=0;
				postInit=1;
				recompile=FUNCTIONS__RECOMPILE;
			};
		};
	};
};



class Extended_Fired_EventHandlers
{
	class CAManBase
	{
		class AGM_Wind
		{
			delete clientFired;
		};
	};
	
	class AllVehicles
	{
		class AGM_Wind
		{
			clientFired = "_this call AGM_Wind_fnc_firedEH";
		};
	};
};
