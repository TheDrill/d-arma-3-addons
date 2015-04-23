#define RECOMPILE 0

class CfgPatches
{
	class d_static_weapons_workaround
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
	class d_static_weapons_workaround
	{
		class Main
		{
			file="\xx\addons\d_static_weapons_workaround\code";
			class _init
			{
				preInit=0;
				postInit=1;
				recompile=RECOMPILE;
			};
		};
	};
};



