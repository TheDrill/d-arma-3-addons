// Made by Drill

#include "main.hpp"
#include "settings.hpp"

GVAR(SMarkersCount) = 0;
GVAR(SMarkerNextUID) = 1;

#define MIN_PENDING_FREE_IDS 2000

GVAR(ServerFreeMarkersPending) = [];
GVAR(ServerFreeMarkersCurrent) = [];
GVAR(ServerFreeMarkersCurrentIndex) = 0;

#define ALLMARKERS_ARRAY_RESIZE_STEP 2000
GVAR(SAllMarkers) = [];

GVAR(SAllMarkers) resize ALLMARKERS_ARRAY_RESIZE_STEP;



//#define REM_PL_CHK(x)  ( isPlayer x || {time <= 0 && (owner x) > 2} )

// for radio-mod
// #define REM_PL_CHK(x)  ( isPlayer x || {time <= 0} )



#define REM_PL_CHK(x)  ( isPlayer x || {time <= 0 && (owner x) > 2} )


// channel-specific conditions

// conditions for SAddLineMarker
GVAR(SALMChanConds) = [
	{true}, // global
	{ side (group _this) == MAR_CHANDATA(_mark) }, // side
	{ ( side (group _this) == MAR_CHANDATA(_mark) ) &&
                          { leader (group _this) == _this }}, // command
	{ group _this == MAR_CHANDATA(_mark) }, // group
	{ vehicle _this == MAR_CHANDATA(_mark) }, // vehicle
	{ time > 0 && {(getPosASL _this) vectorDistance (getPosASL _spl)  < MAX_DISTANCE_FOR_DIRECT} }  // direct
];

// conditions for SDelLineMarker
GVAR(SDLMChanConds) = [
	{true}, // global
	{ side (group _this) == _chandata }, // side
	{ side (group _this) == _chandata }, // command
	{ group _this == _chandata }, // group
	{ vehicle _this == _chandata }, // vehicle
	{ false }  // direct
];




// takes [marker, source player]
RC_DEFINE(SAddLineMarker) =
{
	PV(_mark) = _this select 0;
	PV(_spl) = _this select 1;
	
	
	PV(_i) = 0;



	
	if (count GVAR(ServerFreeMarkersCurrent) > 0) then
	{
		_i = GVAR(ServerFreeMarkersCurrent) select GVAR(ServerFreeMarkersCurrentIndex);
		
		GVAR(ServerFreeMarkersCurrentIndex) = GVAR(ServerFreeMarkersCurrentIndex) + 1;
		
		if (GVAR(ServerFreeMarkersCurrentIndex) >= count GVAR(ServerFreeMarkersCurrent)) then
		{
			GVAR(ServerFreeMarkersCurrent) = [];
		};
	}
	else
	{
		_i = GVAR(SMarkersCount);
		GVAR(SMarkersCount) = GVAR(SMarkersCount) + 1;
		
		if ((count GVAR(SAllMarkers)) <= GVAR(SMarkersCount)) then
		{
			GVAR(SAllMarkers) resize (
				(count GVAR(SAllMarkers)) + ALLMARKERS_ARRAY_RESIZE_STEP
			);
		};
	};
	
	
	
	
	
	// warning - have to set marker id just in _mark for performance. Don't know if
	// there's any problems with it
	_mark set [0, _i];
	
	
	// setting UID
	_mark set [1, GVAR(SMarkerNextUID)];
	GVAR(SMarkerNextUID) = GVAR(SMarkerNextUID) + 1;
	
	
	
	
	// storing marker info to the array
	GVAR(SAllMarkers) set [_i, _mark];

	

	// setting up conditions 
	PV(_chan_cond) = {false};

	if ( MAR_CHAN(_mark) in [0, 1, 2, 3, 4, 5] ) then
	{
		_chan_cond = GVAR(SALMChanConds) select MAR_CHAN(_mark);
	};



	// sending marker to players according to _chan_cond
	
	if (!isDedicated && {alive player} && 
		{player == _spl || {player call _chan_cond}}) then
	{
		if (true || time == 0) then
		{
			[_mark, false] call RC_FUNC(CAddLineMarker);
			
			[player, MAR_ID(_mark), MAR_UID(_mark)] 
				call RC_FUNC(SStorePlayerSeenMarker);
		}
		else
		{
			[_mark, true, _spl] call RC_FUNC(CAddLineMarker);
		};
	};

	{
		if (_x != player && {alive _x} &&
			{_x == _spl || {_x call _chan_cond}}) then
		{
			
			// briefing - every player should receive anyway
			if (true || time == 0) then
			{
				if (owner _x > 2) then
				{
					#define RC_EXEC_ARG [_mark, false]
					RC_EXEC_C(CAddLineMarker, owner _x);
				};

				[_x, MAR_ID(_mark), MAR_UID(_mark)] 
					call RC_FUNC(SStorePlayerSeenMarker);
			}
			else
			{
				#define RC_EXEC_ARG [_mark, true, _spl]
				RC_EXEC_C(CAddLineMarker, owner _x);
			};

		};
	} forEach playableUnits;
	

	// add log entry about adding the marker
	// diag_log text format ["Line-marker %1 added at moment %2 by %3", _i, 
	//	diag_tickTime, _mark select 3];

};
RC_INIT_EH(SAddLineMarker);









// takes [marker, channel, channel data] as argument
RC_DEFINE(SDelLineMarker) =
{
	PV(_id) = _this select 0;
	PV(_chan) = _this select 1;
	PV(_chandata) = _this select 2;

	
	if (!isNil {GVAR(SAllMarkers) select _id}) then
	{
		
		GVAR(SAllMarkers) set [_this select 0, nil];
	
		
		
		
		GVAR(ServerFreeMarkersPending) set [count GVAR(ServerFreeMarkersPending), _this select 0];
		if (count GVAR(ServerFreeMarkersPending) > MIN_PENDING_FREE_IDS && 
			count GVAR(ServerFreeMarkersCurrent) == 0) then
		{
			GVAR(ServerFreeMarkersCurrent) = GVAR(ServerFreeMarkersPending);
			GVAR(ServerFreeMarkersCurrentIndex) = 0;
			GVAR(ServerFreeMarkersPending) = [];
		};
		


		// setting up conditions 
		PV(_chan_cond) = {false};

		if ( _chan in [0, 1, 2, 3, 4, 5] ) then
		{
			_chan_cond = GVAR(SDLMChanConds) select _chan;
		};
		
		
		
		// send delete request to players according to _chan_cond

		if (!isDedicated && {alive player} && {player call _chan_cond}) then
		{
			_id call RC_FUNC(CDelLineMarker);
		};
		
		{
			if (REM_PL_CHK(_x) && {_x != player} && {alive _x} && 
				{_x call _chan_cond}) then
			{
				#define RC_EXEC_ARG _id
				RC_EXEC_C(CDelLineMarker, owner _x);
			};
		} forEach playableUnits;

		

		
		// add log entry about deleting the marker
		// diag_log text format ["Line-marker %1 deleted at moment %2 by %3", _this select 0,
		//	diag_tickTime, _this select 1];
	};

};
RC_INIT_EH(SDelLineMarker);





// [player, marker id, marker uid]
RC_DEFINE(SStorePlayerSeenMarker) =
{
	PV(_pl) = _this select 0;
	
	if (isNil {_pl getVariable MARKERS_VAR_IN_PLAYER}) then
	{
		_pl setVariable [MARKERS_VAR_IN_PLAYER, []];
	};
	
	(_pl getVariable MARKERS_VAR_IN_PLAYER) 
		pushBack [_this select 1, _this select 2];
};
RC_INIT_EH(SStorePlayerSeenMarker);




// takes the calling player's object as the argument
RC_DEFINE(SRequestMarkersForPlayer) =
{
	_this spawn
	{
		if (!isNull _this) then
		{
			PV(_pid) = owner _this;
			

			PV(_allpm) = _this getVariable [MARKERS_VAR_IN_PLAYER, []];
			PV(_i) = 0;
			PV(_nn) = count _allpm;
			
			while {_i < _nn} do
			{
				PV(_xx) = _allpm select _i;
				PV(_id) = _xx select 0;
				PV(_uid) = _xx select 1;
				PV(_el) = GVAR(SAllMarkers) select _id;
				
				if (!isNil {_el}) then
				{
					if (MAR_UID(_el) == _uid) then
					{
						#define RC_EXEC_ARG [_el, false]
						RC_EXEC_C(CAddLineMarker, _pid);
					}
					else
					{
						_allpm deleteAt _i;
						_i = _i - 1;
						_nn = _nn - 1;
					};
				}
				else
				{
					_allpm deleteAt _i;
					_i = _i - 1;
					_nn = _nn - 1;
				};
				
				_i = _i + 1;
			};
			
		};
	};
};
RC_INIT_EH(SRequestMarkersForPlayer);




V_SERVER_READY = true;
publicVariable 'V_SERVER_READY';



