#include "config_macros.hpp"

#define RECOMPILE 0

class CfgPatches {

	class d_map_adv_markers {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {"A3_UI_F"};
		author[]= {"Drill"};
		addon_version = 9;
	};
};


class CfgFunctions
{
	class d_map_adv_markers
	{
		class Init
		{
			file = "\xx\addons\d_map_adv_markers\code";
			class _init {
				preInit = 0;
				postInit = 1;
				recompile = RECOMPILE;
			};

			class _onIMDLoad {recompile = RECOMPILE;};
			class _onIMDUnload {recompile = RECOMPILE;};
			
			class _UIIM_initDialog {recompile = RECOMPILE;};
			
			class _onEachFrameBody {recompile = RECOMPILE;};
			
			
			class _CCheckIfMarkerAllowedSend {recompile = RECOMPILE;};
			class _CCheckIfMarkerAllowedReceive {recompile = RECOMPILE;};
			
			class _CGetIMDChannel {recompile = RECOMPILE;};
			
		};
	};
};



#include "config_ui.hpp"
