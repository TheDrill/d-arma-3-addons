#define BIS_W ( ((safezoneW / safezoneH) min 1.2) / 40 )
#define BIS_H ( (((safezoneW / safezoneH) min 1.2) / 1.2) / 25 )
#define BIS_H2 ( (((safezoneW / safezoneH) min 1.2) / 1.2) )



class RscPicture;
class RscText;
class RscStructuredText;
class RscButtonMenuOK;
class RscButtonMenuCancel;
class RscButtonMenu;
class RscEdit;
class RscCombo;
class RscSlider;




class RscDisplayInsertMarker
{
	onLoad = SCR(_this call CFUNC(_onIMDLoad));
	onUnload = SCR(_this call CFUNC(_onIMDUnload));
	idd = 54;
	movingEnable = 0;
	
	onKeyUp = SCR(_this call FUNC(IMOnKeyUp));
	onKeyDown = SCR(_this call FUNC(IMOnKeyDown));

	class controlsBackground
	{
		class RscText_1000: RscText
		{
			idc = 1000;
			x = "0 * GUI_GRID_INSERTMARKER_W + GUI_GRID_INSERTMARKER_X";
			y = "0 * GUI_GRID_INSERTMARKER_H + GUI_GRID_INSERTMARKER_Y";
			w = "8 * GUI_GRID_INSERTMARKER_W";
			h = "2.5 * GUI_GRID_INSERTMARKER_H";
			colorBackground[] = {0,0,0,0.5};
		};
		
		class TextBackground: RscText
		{
			idc = 14400;
			
			colorBackground[] = {0,0,0,0.7};
						
			y = 10;
		};		
	};
	class controls
	{
		delete ButtonOK;
		delete ButtonMenuInfo;
		delete Info;
		
		
		class DescriptionChannel: RscStructuredText
		{
			y = safeZoneH*10;
		};

		
		class ButtonMenuOK: RscButtonMenuOK
		{
			y = safeZoneH*10;
		//	default = 0;
			
			onMouseButtonUp = SCR( [] call FUNC(IMOnMouseClickOk) );
		};
		class ButtonMenuCancel: RscButtonMenuCancel
		{
			y = safeZoneH*10;
		};

		class Title: RscText
		{
			y = safeZoneH*10;
		};
		class Description: RscStructuredText
		{
			y = safeZoneH*10;
		};
		class Picture: RscPicture
		{
			y = safeZoneH*10;
		};
/*		class Text: RscEdit
		{
			y = safeZoneH*10;
		};*/
	
		class MarkerText: RscEdit
		{
			y = safeZoneH*10;
			
	//		default = 1;
		};		
		
		class MarkerChannel: RscCombo
		{
			y = safeZoneH*10;
			
			onLBSelChanged = SCR(\
					ctrlSetFocus ((findDisplay 54) displayCtrl 101);\
				);
		};
		
		class MarkerShape: RscCombo
		{
			idc = 14401;
			y = safeZoneH*10;
			
			wholeHeight = safeZoneH * 0.48;
						
			onLBSelChanged = SCR(\
					if (!GVAR(UIIM_ignoreCBChange)) then \
					{\
						GVAR(UIMarkerTypeID) = _this select 1;\
						GVAR(UIMarkerType) = GVAR(UIMarkerTypes) select GVAR(UIMarkerTypeID);\
						[] call FUNC(UIUpdateIMMarker);\
						\
						ctrlSetFocus ((findDisplay 54) displayCtrl 101);\
					};\
				);
		};
		class MarkerColor: RscCombo
		{
			idc = 14402;
			y = safeZoneH*10;
			
			wholeHeight = safeZoneH * 0.48;
			
			onLBSelChanged = SCR(\
					if (!GVAR(UIIM_ignoreCBChange)) then \
					{\
						GVAR(UIMarkerColorID) = _this select 1;\
						GVAR(UIMarkerColor) = GVAR(UIMarkerColors) select GVAR(UIMarkerColorID);\
						[] call FUNC(UIUpdateIMMarker);\
						\
						ctrlSetFocus ((findDisplay 54) displayCtrl 101);\
					};\
				);
		};
	};
};
