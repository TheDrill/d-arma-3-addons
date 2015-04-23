#include "addon.hpp"
#include "main.hpp"

if (_this <= 0.01 || _this >= 0.02) exitWith {-1};

floor((_this - 0.01) * 10000000);

