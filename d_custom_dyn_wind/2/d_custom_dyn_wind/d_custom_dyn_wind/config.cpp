#define RECOMPILE 0

#include "config_macros.hpp"


class CfgPatches
{
	class d_custom_dyn_wind
	{
		units[]={"d_module_setWindParameters"};
		weapons[]={};
		requiredAddons[]={};
		author[]=
		{
			"Drill"
		};
		addon_version=2;
	};
};



class CfgFunctions
{
	class d_custom_dyn_wind
	{
		class Main
		{
			file="\xx\addons\d_custom_dyn_wind\code";
			class _init
			{
				preInit=1;
				postInit=0;
				recompile=RECOMPILE;
			};

			class _mainLoop {recompile=RECOMPILE;};
			class _module_setWindParams_fnc {recompile=RECOMPILE;};
		};
	};
};



class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
/*		class ArgumentsBaseUnits
		{
		};*/
		class ModuleDescription
		{
		};
	};
	class d_module_setWindParameters: Module_F
	{
		scope = 2;
		
		author = "Drill";
		
		displayName = "$STR_Addons__d_custom_dyn_wind__moduleDisplayName"; 
		icon = "\xx\addons\d_custom_dyn_wind\data\module_icon.paa";
		category = "Environment";

		
		function = SCR(CFUNC(_module_setWindParams_fnc));
		functionPriority = 1;
		isGlobal = 0;
//		isTriggerActivated = 1;
//		isDisposable = 1;

		// Menu displayed when the module is placed or double-clicked on by Zeus
//		curatorInfoType = "RscDisplayAttributeModuleNuke";

		// Module arguments
		class Arguments//: ArgumentsBaseUnits
		{
//			class Units: Units {};
			// Module specific arguments
			class Direction
 			{
				displayName = "$STR_Addons__d_custom_dyn_wind__moduleDir_0";
				description = "$STR_Addons__d_custom_dyn_wind__moduleDir_1";
				typeName = "NUMBER"; 
				defaultValue = "-1";
			};
			class Strength
 			{
				displayName = "$STR_Addons__d_custom_dyn_wind__moduleStr_0";
				description = "$STR_Addons__d_custom_dyn_wind__moduleStr_1";
				typeName = "NUMBER"; 
				defaultValue = "-1";
			};
			class Dispersion
 			{
				displayName = "$STR_Addons__d_custom_dyn_wind__moduleDisp_0";
				description = "$STR_Addons__d_custom_dyn_wind__moduleDisp_1";
				typeName = "NUMBER"; 
				defaultValue = "-1";
			};
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "$STR_Addons__d_custom_dyn_wind__moduleDescription"; 
		};
	};
};
