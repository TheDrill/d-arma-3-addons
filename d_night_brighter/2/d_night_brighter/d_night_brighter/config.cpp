#define RECOMPILE 0

class CfgPatches
{
	class d_night_brighter
	{
		units[]={};
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
	class d_night_brighter
	{
		class Main
		{
			file="\xx\addons\d_night_brighter\code";
			class _init
			{
				preInit=0;
				postInit=1;
				recompile=RECOMPILE;
			};

			class _mainLoop {recompile=RECOMPILE;};
		};
	};
};



