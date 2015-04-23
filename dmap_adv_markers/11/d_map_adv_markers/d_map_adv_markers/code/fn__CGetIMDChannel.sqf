// receives nothing

#include "main.hpp"

disableSerialization;

PV(_rv) = GVAR(UICurrentChannel);

if (GVAR(_chn_btn_channel_code) >= 0) then 
{
	_rv = GVAR(_chn_btn_channel_code);
};


_rv;
