
class CfgPatches {

	class dmap_adv_markers {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {"Extended_EventHandlers"};
		author[]= {"Drill"};
		addon_version = 2;
	};
};

class Extended_PostInit_EventHandlers {

	class dmap_adv_markers {
		Init = "call compile preProcessFileLineNumbers '\xx\addons\dmap_adv_markers\init.sqf'";
	};
};