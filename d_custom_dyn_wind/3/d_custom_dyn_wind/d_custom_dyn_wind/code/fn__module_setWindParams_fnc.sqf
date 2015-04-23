#include "addon.hpp"
#include "main.hpp"

_logic = _this select 0;
_activated = _this select 2;



if (_activated) then
{
	_wdir = _logic getVariable ["Direction", -1];
	_wstr = _logic getVariable ["Strength", -1];
	_wdisp = _logic getVariable ["Dispersion", -1];
	
	if (_wdir >= 0) then {GVAR(avgWindDir) = _wdir};
	if (_wstr >= 0) then {GVAR(avgWindStr) = _wstr};
	if (_wdisp >= 0) then {GVAR(windVector2Disp) = _wdisp};
};

true
