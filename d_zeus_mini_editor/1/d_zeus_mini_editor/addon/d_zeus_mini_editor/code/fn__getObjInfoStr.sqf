#include "addon.hpp"
#include "main.hpp"

PV(_s_id) = _this call CFUNC(_objText);


PV(_pos) = getPosATL _this;

PV(_offsetY) = _pos select 2;

_pos set [2, 0];
_pos = ATLtoASL _pos;
PV(_s_pos) = format ["%1 %2 %3", _pos select 0, _pos select 2, _pos select 1];

PV(_s_offsetY) = str _offsetY;

PV(_s_azimut) = str (getDir _this);

PV(_s_veh) = str (typeOf _this);



format ["%1 position[] %2 offsetY %3 azimut %4 vehicle %5", 
	_s_id, _s_pos, _s_offsetY, _s_azimut, _s_veh];
