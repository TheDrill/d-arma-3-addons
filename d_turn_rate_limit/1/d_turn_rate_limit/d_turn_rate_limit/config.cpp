class CfgPatches
{
	class d_turn_rate_limit
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
	class d_turn_rate_limit
	{
		class Main
		{
			file="\xx\addons\d_turn_rate_limit\code";
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



