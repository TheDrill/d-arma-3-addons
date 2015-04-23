#include "addon.hpp"
#include "main.hpp"

PV(_s) = str (str _this);

if ((_s find ":") >= 0 || {(_s find " ") >= 0}) exitWith {"none";};

_s;
