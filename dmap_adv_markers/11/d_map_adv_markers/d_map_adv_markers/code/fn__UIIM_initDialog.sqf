#include "addon.hpp"
#include "main.hpp"

#define BORDER	0.005

#define CHAN_BTNS_IDC(x) (14500 + (x))

		
disableSerialization;

PV(_i) = 0;

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
//~ _pos set [1,_posY + 3*_posH];
//~ _pos set [3,_posH];
//~ _mchannel_cb ctrlsetposition _pos;
//~ _mchannel_cb ctrlcommit 0;


PV(_chan_buttons) = [];

PV(_spos) = [_posX, _posY + 3*_posH, _posW / 6, _posH];

for "_i" from 0 to 5 do
{
	PV(_ctrl) = _display ctrlCreate ["RscButtonMenu", CHAN_BTNS_IDC(_i)];
	_chan_buttons set [_i, _ctrl];
	
	_spos set [0, _posX + _i * _posW / 6];
	_ctrl ctrlSetPosition _spos;
	_ctrl ctrlCommit 0;
};



//--- ButtonCancel
_pos set [1,_posY + 4 * _posH + 2 * BORDER];
_pos set [2,_posW / 2];
_pos set [3,_posH];
_buttonCancel ctrlsetposition _pos;
_buttonCancel ctrlcommit 0;


//--- ButtonOK
_pos set [0,_posX + _posW / 2];
_pos set [1,_posY + 4 * _posH + 2 * BORDER];
_pos set [2,_posW / 2 - BORDER];
_pos set [3,_posH];
_buttonOk ctrlsetposition _pos;
_buttonOk ctrlcommit 0;













// setup channel buttons

{
	PV(_ctrl) = _chan_buttons select (_x select 0);
	_ctrl ctrlSetText (_x select 1);
	_ctrl ctrlSetTextColor (_x select 2);
	_ctrl ctrlSetTooltip LOCALIZE(_x select 3);
	
	_ctrl ctrlEnable false;
} forEach [
	[CHAN_GLOBAL,  "Gl", [0.847059,0.847059,0.847059,1], "btn_send_to_chan__global"],
	[CHAN_SIDE,    "Si", [0.27451,0.827451,0.988235,1], "btn_send_to_chan__side"],
	[CHAN_COMMAND, "Co", [1,1,0.27451,1], "btn_send_to_chan__command"],
	[CHAN_GROUP,   "Gr", [0.709804,0.972549,0.384314,1], "btn_send_to_chan__group"],
	[CHAN_VEHICLE, "Ve", [1,0.815686,0,1], "btn_send_to_chan__vehicle"],
	[CHAN_DIRECT,  "Di", [1, 1, 1, 1], "btn_send_to_chan__direct"]
];


// highlight current channel
PV(_ctrl) = _chan_buttons select GVAR(UICurrentChannel);

_ctrl ctrlSetBackgroundColor [
	profilenamespace getvariable ['GUI_BCG_RGB_R',0.69],
	profilenamespace getvariable ['GUI_BCG_RGB_G',0.75],
	profilenamespace getvariable ['GUI_BCG_RGB_B',0.5 ],
	(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8 ])
];


PV(_clsz) = lbSize _mchannel_cb;

PV(_act_channels) = [];

for "_i" from 0 to (_clsz - 1) do
{
	PV(_text) = _mchannel_cb lbText _i;
	
	PV(_rv) = -1;

	if (_text == GVAR(str_c_gr)) then { _rv = CHAN_GROUP; };
	if (_text == GVAR(str_c_si)) then { _rv = CHAN_SIDE; };
	if (_text == GVAR(str_c_gl)) then { _rv = CHAN_GLOBAL; };
	if (_text == GVAR(str_c_ve)) then { _rv = CHAN_VEHICLE; };
	if (_text == GVAR(str_c_co)) then { _rv = CHAN_COMMAND; };
	if (_text == GVAR(str_c_di)) then { _rv = CHAN_DIRECT; };
	
	if (_rv >= 0) then
	{
		_act_channels pushBack _rv;
	};
};

_act_channels = (_act_channels - [CHAN_DIRECT]) + [CHAN_DIRECT];
_act_channels = (_act_channels - [GVAR(UICurrentChannel)]) + [GVAR(UICurrentChannel)];


// setup eventhandlers for channel buttons


GVAR(_chn_btn_channel_code) = -1;


{
	PV(_ctrl) = _chan_buttons select _x;
	_ctrl ctrlEnable true;
	
	_ctrl buttonSetAction  format ['GVAR(_chn_btn_channel_code) = %1; [0, 28, false, false, false] call FUNC(IMOnKeyDown);', _x];
} forEach _act_channels;














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
//~ _mchannel_cb lbAdd GVAR(str_c_di);
//~ 
//~ // set to direct channel if it is current channel
//~ if (GVAR(UICurrentChannel) == CHAN_DIRECT) then
//~ {
	//~ _mchannel_cb lbSetCurSel ((lbSize _mchannel_cb) - 1);
//~ };


ctrlSetFocus (_display displayCtrl 101);


[] call FUNC(UIUpdateIMMarker);

GVAR(UIIM_ignoreCBChange) = false;
