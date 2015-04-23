#include "addon.hpp"
#include "main.hpp"

#define BORDER	0.005
		
disableSerialization;

PV(_display) = uiNamespace getVariable 'GVAR(UIIM_display)';


PV(_text) = _display displayctrl 101;
PV(_textbg) = _display displayctrl 14400;
PV(_picture) = _display displayctrl 102;
PV(_buttonOK) = _display displayctrl 1;
PV(_buttonCancel) = _display displayctrl 2;
PV(_description) = _display displayctrl 1100;
PV(_title) = _display displayctrl 1001;

PV(_mshape_cb) = _display displayctrl 14401;
PV(_mcolor_cb) = _display displayctrl 14402;
PV(_mchannel_cb) = _display displayctrl 103;


//--- Background
PV(_pos) = ctrlposition _text;

PV(_shift) = 0 min ( safeZoneY + safeZoneH - ((_pos select 1) + (_pos select 3) * 5) );

PV(_posX) = (_pos select 0);// + 0.01;
PV(_posY) = (_pos select 1) + _shift;
PV(_posW) = _pos select 2;
PV(_posH) = _pos select 3;
_pos set [0, _posX];
_pos set [1, _posY];
_text ctrlsetposition _pos;
_text ctrlcommit 0;

_textbg ctrlsetposition _pos;
_textbg ctrlcommit 0;

//--- Picture
PV(_picpos) = ctrlposition _picture;
_picpos set [1, (_picpos select 1) + _shift];
_picture ctrlsetposition _picpos;
_picture ctrlcommit 0;

//--- Title
_pos set [1,_posY - 2*_posH - BORDER];
_pos set [3,_posH];
_title ctrlsetposition _pos;
_title ctrlcommit 0;

_pos set [1,_posY - 1*_posH];
_pos set [3,1*_posH];
_description ctrlsetposition _pos;
_description ctrlsetstructuredtext parsetext format 
	["<t size='0.8'>%1</t>",
	localize "STR_Addons__d_map_adv_markers__IMD_Description"]; //--- ToDo: Localze
_description ctrlcommit 0;

PV(_activeColor) = (["IGUI","WARNING_RGB"] call bis_fnc_displaycolorget) call bis_fnc_colorRGBtoHTML;




//--- Marker shape combobox
_pos set [1,_posY + 1*_posH];
_pos set [3,_posH];
_mshape_cb ctrlsetposition _pos;
_mshape_cb ctrlcommit 0;

//--- Marker color combobox
_pos set [1,_posY + 2*_posH];
_pos set [3,_posH];
_mcolor_cb ctrlsetposition _pos;
_mcolor_cb ctrlcommit 0;

//--- Marker channel combobox
_pos set [1,_posY + 3*_posH];
_pos set [3,_posH];
_mchannel_cb ctrlsetposition _pos;
_mchannel_cb ctrlcommit 0;

//--- ButtonOK
_pos set [1,_posY + 4 * _posH + 2 * BORDER];
_pos set [2,_posW / 2 - BORDER];
_pos set [3,_posH];
_buttonOk ctrlsetposition _pos;
_buttonOk ctrlcommit 0;

//--- ButtonCancel
_pos set [0,_posX + _posW / 2];
_pos set [1,_posY + 4 * _posH + 2 * BORDER];
_pos set [2,_posW / 2];
_pos set [3,_posH];
_buttonCancel ctrlsetposition _pos;
_buttonCancel ctrlcommit 0;


GVAR(UIIM_ignoreCBChange) = true;

// filling shapes list
{
	_mshape_cb lbAdd getText(configFile >> "CfgMarkers" >> _x >> "name");
	_mshape_cb lbSetTooltip [_forEachIndex, _x];
	
	_mshape_cb lbSetPicture [_forEachIndex, getText (configFile >> "CfgMarkers" >> _x >> "icon")];
} forEach GVAR(UIMarkerTypes);
_mshape_cb lbSetCurSel GVAR(UIMarkerTypeID);

// filling colors list
{
	_mcolor_cb lbAdd getText(configFile >> "CfgMarkerColors" >> _x >> "name");
	_mcolor_cb lbSetTooltip [_forEachIndex, _x];
	
	PV(_rgba) = getArray(configFile >> "CfgMarkerColors" >> _x >> "color");
	PV(_icon) = format ["#(argb,8,8,3)color(%1,%2,%3,%4)", _rgba select 0, _rgba select 1, _rgba select 2, _rgba select 3];
	_mcolor_cb lbSetPicture [_forEachIndex, _icon];
	//_mcolor_cb lbSetColor [_forEachIndex, ];
} forEach GVAR(UIMarkerColors);
_mcolor_cb lbSetCurSel GVAR(UIMarkerColorID);


// adding direct channel to the channels list
_mchannel_cb lbAdd GVAR(str_c_di);

// set to direct channel if it is current channel
if (GVAR(UICurrentChannel) == CHAN_DIRECT) then
{
	_mchannel_cb lbSetCurSel ((lbSize _mchannel_cb) - 1);
};


ctrlSetFocus (_display displayCtrl 101);


[] call FUNC(UIUpdateIMMarker);

GVAR(UIIM_ignoreCBChange) = false;
