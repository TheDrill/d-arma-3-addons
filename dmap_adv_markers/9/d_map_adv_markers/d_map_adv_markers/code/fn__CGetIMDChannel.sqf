// receives nothing

#include "main.hpp"

disableSerialization;

PV(_rv) = GVAR(UICurrentChannel);

PV(_display) = uiNamespace getVariable 'GVAR(UIIM_display)';
PV(_mchannel_cb) = _display displayctrl 103;

PV(_text) = _mchannel_cb lbText (lbCurSel _mchannel_cb);

if (_text == GVAR(str_c_gr)) then { _rv = CHAN_GROUP; };
if (_text == GVAR(str_c_si)) then { _rv = CHAN_SIDE; };
if (_text == GVAR(str_c_gl)) then { _rv = CHAN_GLOBAL; };
if (_text == GVAR(str_c_ve)) then { _rv = CHAN_VEHICLE; };
if (_text == GVAR(str_c_co)) then { _rv = CHAN_COMMAND; };
if (_text == GVAR(str_c_di)) then { _rv = CHAN_DIRECT; };



_rv;
