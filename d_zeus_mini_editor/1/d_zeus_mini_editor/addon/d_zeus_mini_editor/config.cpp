#define RECOMPILE 0

class CfgPatches
{
	class d_zeus_mini_editor
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

class CfgFunctions
{
	class d_zeus_mini_editor
	{
		class Main
		{
			file="\xx\addons\d_zeus_mini_editor\code";

			class _init
			{
				preInit=0;
				postInit=1;
				recompile=RECOMPILE;
			};

			class _initMain {recompile=RECOMPILE;};
			
			class _intToOID {recompile=RECOMPILE;};
			class _OIDToInt {recompile=RECOMPILE;};
			
			class _objText {recompile=RECOMPILE;};
			
			class _getObjInfoStr {recompile=RECOMPILE;};
			
			
			
			
			class _activateZME {recompile=RECOMPILE;};
			class _storeZME {recompile=RECOMPILE;};
			
			class _importObjs {recompile=RECOMPILE;};
			class _unimportObjs {recompile=RECOMPILE;};
			
			class _makeAllPlayable {recompile=RECOMPILE;};
		};
	};
};



