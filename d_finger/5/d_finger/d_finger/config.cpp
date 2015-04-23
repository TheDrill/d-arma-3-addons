#define RECOMPILE 0

class CfgPatches
{
	class d_finger
	{
		units[]={};
		weapons[]={};
		requiredAddons[]={};
		author[]=
		{
			"Drill"
		};
		addon_version=5;
	};
};

class CfgFunctions
{
	class d_finger
	{
		class Main
		{
			file="\xx\addons\d_finger\code";
			class _init
			{
				preInit=0;
				postInit=1;
				recompile=RECOMPILE;
			};

			class _mainLoop {recompile=RECOMPILE;};
			class _comm {recompile=RECOMPILE;};
			class _conf {recompile=RECOMPILE;};
			class _fp_handler {recompile=RECOMPILE;};
			class _OEF_renderer {recompile=RECOMPILE;};
		};
	};
};



