class CfgPatches
{
	class d_recoil_randomizer
	{
		units[]={};
		weapons[]={};
		requiredAddons[]={};
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
	class d_recoil_randomizer
	{
		class Main
		{
			file="\xx\addons\d_recoil_randomizer\code";
			class _init
			{
				preInit=0;
				postInit=1;
				recompile=FUNCTIONS__RECOMPILE;
			};

			class _mainLoop {recompile=FUNCTIONS__RECOMPILE;};
		};
	};
};



