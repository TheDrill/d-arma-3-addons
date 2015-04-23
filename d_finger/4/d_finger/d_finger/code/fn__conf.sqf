#include "addon.hpp"
#include "main.hpp"

GVAR(FP_keyComb) = [41, false, true, false]; // Ctrl + Tilda
GVAR(FP_color) = [0.83, 0.68, 0.21];
GVAR(FP_opaque) = [0.75];
GVAR(FP_indicator_for_self) = true;

if (!isNil {d_uac_fnc_registerParameter}) then
{
	['GVAR(FP_keyComb)',
		localize "STR_Addons__d_finger__uac_section",
		localize "STR_Addons__d_finger__uac_keyComb",
		""]
		call d_uac_fnc_registerKeyBindingVariable;

	
	PV(_colors) = [
			[localize "STR_Addons__d_finger__uac_col_Black", [0, 0, 0]],
			[localize "STR_Addons__d_finger__uac_col_Blue", [0, 0, 1]],
			[localize "STR_Addons__d_finger__uac_col_Brown", [0.5, 0.25, 0.1]],
			[localize "STR_Addons__d_finger__uac_col_Green", [0, 0.8, 0]],
			[localize "STR_Addons__d_finger__uac_col_Grey", [0.5, 0.5, 0.5]],
			[localize "STR_Addons__d_finger__uac_col_Khaki", [0.5, 0.6, 0.4]],
			[localize "STR_Addons__d_finger__uac_col_Orange", [0.85, 0.4, 0]],
			[localize "STR_Addons__d_finger__uac_col_Pink", [1, 0.3, 0.4]],
			[localize "STR_Addons__d_finger__uac_col_Red", [0.9, 0, 0]],
			[localize "STR_Addons__d_finger__uac_col_White", [1, 1, 1]],
			[localize "STR_Addons__d_finger__uac_col_Yellow", [0.85, 0.85, 0]],
			[localize "STR_Addons__d_finger__uac_col_Gold", [0.83, 0.68, 0.21]]	
		];

	['GVAR(FP_color)',
		localize "STR_Addons__d_finger__uac_section",
		localize "STR_Addons__d_finger__uac_color",
		"",
		_colors]
		call d_uac_fnc_registerEnumVariable;


	PV(_opaque) = [
			["100%", [1]],
			["75%" , [0.75]],
			["50%" , [0.5]],
			["25%" , [0.25]],
			["10%" , [0.1]]
		];

	['GVAR(FP_opaque)',
		localize "STR_Addons__d_finger__uac_section",
		localize "STR_Addons__d_finger__uac_opaque",
		"",
		_opaque]
		call d_uac_fnc_registerEnumVariable;


	['GVAR(FP_indicator_for_self)',
		localize "STR_Addons__d_finger__uac_section",
		localize "STR_Addons__d_finger__uac_indicator_for_self",
		""]
		call d_uac_fnc_registerBooleanVariable;
	
}
else
{
	if (!isNil {cba_fnc_addKeybind}) then
	{
		GVAR(cba_mode) = true;		
	};
};
