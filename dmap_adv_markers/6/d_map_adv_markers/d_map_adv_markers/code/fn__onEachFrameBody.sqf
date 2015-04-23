#include "main.hpp"


// chat channel determination
if (!isNull (findDisplay 63)) then
{
	PV(_text) = ctrlText ((findDisplay 63) displayCtrl 101);
	
	if (_text == GVAR(str_c_gr)) then { GVAR(UICurrentChannel) = CHAN_GROUP; };
	if (_text == GVAR(str_c_si)) then { GVAR(UICurrentChannel) = CHAN_SIDE; };
	if (_text == GVAR(str_c_gl)) then { GVAR(UICurrentChannel) = CHAN_GLOBAL; };
	if (_text == GVAR(str_c_ve)) then { GVAR(UICurrentChannel) = CHAN_VEHICLE; };
	if (_text == GVAR(str_c_co)) then { GVAR(UICurrentChannel) = CHAN_COMMAND; };
	if (_text == GVAR(str_c_di)) then { GVAR(UICurrentChannel) = CHAN_VEHICLE; }; // not implemented	
	

	GVAR(str_localized_cur_channel) = _text;
};



// insert marker dialog initialization
if ( uiNamespace getVariable ['GVAR(needToInitIMD)', false] &&
	{(ctrlPosition (uiNamespace getVariable 'GVAR(UIIM_text_ctrl)')) select 1 < 9} ) then
{
	uiNamespace setVariable ['GVAR(needToInitIMD)', false];
	
	[] call CFUNC(_UIIM_initDialog);
};



if (visibleMap && count GVAR(UIPoints) > 0) then
{
	[] call FUNC(UIUpdateMarkersParams);	
};

