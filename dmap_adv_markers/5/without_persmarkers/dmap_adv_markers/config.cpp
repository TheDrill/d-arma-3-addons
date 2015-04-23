
class CfgPatches {

	class dmap_adv_markers {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
		author[]= {"Drill"};
		addon_version = 5;
	};
};


class CfgFunctions
{
	class DMapAdvMarkers
	{
		class Init
		{
			file = "\xx\addons\dmap_adv_markers";
			class postInit {
				preInit = 0;
				postInit = 1;
//				recompile = 1;
			};
		};
	};
};
