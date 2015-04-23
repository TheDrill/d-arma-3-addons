// Made by Drill

#include "main.hpp"


GVAR(SMarkersCount) = 0;

#define MIN_PENDING_FREE_IDS 2000

GVAR(ServerFreeMarkersPending) = [];
GVAR(ServerFreeMarkersCurrent) = [];
GVAR(ServerFreeMarkersCurrentIndex) = 0;


GVAR(SSideMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];
GVAR(SGroupMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];
GVAR(SGlobalMarkersLogic) = "Logic" createVehicleLocal [-10000,-10000,0];

GVAR(SGlobalMarkersLogic) setVariable ["ids", []];






// takes Marker array as the argument
RC_DEFINE(SAddLineMarker) =
{
	
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
	};
	
	
	
	
	
	// warning - have to set marker id just in _this for performance. Don't know if
	// there's any problems with it
	_this set [0, _i];




	///////////////////////////////////////////////////////////////////////

	if ( MAR_CHAN(_this) == CHAN_SIDE ) then
	{
		PV(_j) = GVAR(SSideMarkersLogic) getVariable [ str MAR_CHANDATA(_this), objNull ];
		if (isNull _j) then
		{
			_j = "Logic" createVehicleLocal [-10000,-10000,0];
			 GVAR(SSideMarkersLogic) setVariable [ str MAR_CHANDATA(_this), _j ];
		};
		
		_j setVariable [str _i, _this];
		_j setVariable ["ids", (_j getVariable ["ids", []]) + [_i]];
		
		
		
		if (!isDedicated && {playerSide == MAR_CHANDATA(_this)}) then
		{
			_this call RC_FUNC(CAddLineMarker);
		};
		
		{
			if ( ( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && 
				{ _x != player && 
					{ side (group _x) == MAR_CHANDATA(_this) } 
				}) then
			{
				#define RC_EXEC_ARG _this
				RC_EXEC_C(CAddLineMarker, owner _x);
			};
		} forEach playableUnits;

	};
	
	
	
	
	
	
	
	/////////////////////////////////////////////////////////////////////////
	
	if ( MAR_CHAN(_this) == CHAN_GROUP ) then
	{
		PV(_j) = GVAR(SGroupMarkersLogic) getVariable [ str MAR_CHANDATA(_this), objNull ];
		if (isNull _j) then
		{
			_j = "Logic" createVehicleLocal [-10000,-10000,0];
			 GVAR(SGroupMarkersLogic) setVariable [ str MAR_CHANDATA(_this), _j ];
		};
		
		_j setVariable [str _i, _this];		
		_j setVariable ["ids", (_j getVariable ["ids", []]) + [_i]];





		if (!isDedicated && {group player == MAR_CHANDATA(_this)}) then
		{
			_this call RC_FUNC(CAddLineMarker);
		};
		
		{
			if ( ( isPlayer _x || {time <= 0 && (owner _x) > 2} ) &&
				{ _x != player && 
					{ group _x == MAR_CHANDATA(_this) }
				}) then
			{
				#define RC_EXEC_ARG _this
				RC_EXEC_C(CAddLineMarker, owner _x);
			};
		} forEach playableUnits;
	};











	////////////////////////////////////////////////////////////////

	if ( MAR_CHAN(_this) == CHAN_GLOBAL ) then
	{		
		GVAR(SGlobalMarkersLogic) setVariable [str _i, _this];
		GVAR(SGlobalMarkersLogic) setVariable ["ids",
			(GVAR(SGlobalMarkersLogic) getVariable ["ids", []]) + [_i]];
		
		
		
		if (!isDedicated) then
		{
			_this call RC_FUNC(CAddLineMarker);
		};
		
		{
			if ( ( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && 
				{ _x != player }) then
			{
				#define RC_EXEC_ARG _this
				RC_EXEC_C(CAddLineMarker, owner _x);
			};
		} forEach playableUnits;

	};
	





	
	//////////////////////////////////////////////////////////////////////////

	if ( MAR_CHAN(_this) == CHAN_VEHICLE ) then
	{				
		if (!isDedicated && {vehicle player == MAR_CHANDATA(_this)}) then
		{
			_this call RC_FUNC(CAddLineMarker);
		};
		
		{
			if ( ( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && 
				{ _x != player && { vehicle _x == MAR_CHANDATA(_this) }
				}) then
			{
				#define RC_EXEC_ARG _this
				RC_EXEC_C(CAddLineMarker, owner _x);
			};
		} forEach playableUnits;

	};
	

	// add log entry about adding the marker
	// diag_log text format ["Line-marker %1 added at moment %2 by %3", _i, 
	//	diag_tickTime, _this select 2];





};
RC_INIT_EH(SAddLineMarker);









// takes [marker, channel, channel data] as argument
RC_DEFINE(SDelLineMarker) =
{




	PV(_j) = objNull;
	
	
	
	
	
	
	if ((_this select 1) == CHAN_SIDE) then
	{
		_j = GVAR(SSideMarkersLogic) getVariable 
			[str (_this select 2), objNull];
	};
	
	if ((_this select 1) == CHAN_GROUP) then
	{
		_j = GVAR(SGroupMarkersLogic) getVariable
			[str (_this select 2), objNull];
	};
	
	if ((_this select 1) == CHAN_GLOBAL) then
	{
		_j = GVAR(SGlobalMarkersLogic);
	};
	
	
	
	
	
	if ((_this select 1) == CHAN_VEHICLE   ||
		{!isNull _j && {count (_j getVariable [str (_this select 0), []]) > 0}} ) then
	{
		
		
		if ((_this select 1) != CHAN_VEHICLE) then
		{
			_j setVariable [str (_this select 0), []];
			_j setVariable ["ids", (_j getVariable ["ids", []]) - [_i]];
		};
		
		
		
		
		
		GVAR(ServerFreeMarkersPending) set [count GVAR(ServerFreeMarkersPending), _this select 0];
		if (count GVAR(ServerFreeMarkersPending) > MIN_PENDING_FREE_IDS && 
			count GVAR(ServerFreeMarkersCurrent) == 0) then
		{
			GVAR(ServerFreeMarkersCurrent) = GVAR(ServerFreeMarkersPending);
			GVAR(ServerFreeMarkersCurrentIndex) = 0;
			GVAR(ServerFreeMarkersPending) = [];
		};
		
		
		
		/////////////////////////////////////////////////////////////////
		if ((_this select 1) == CHAN_SIDE) then
		{
			if (!isDedicated && {playerSide == _this select 2}) then
			{
				(_this select 0) call RC_FUNC(CDelLineMarker);
			};
			
			
			{
				if (( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && { _x != player && 
					{side (group _x) == _this select 2} }) then
				{
					#define RC_EXEC_ARG _this select 0
					RC_EXEC_C(CDelLineMarker, owner _x);
				};
			} forEach playableUnits;
		};
		
		
		
		
		////////////////////////////////////////////////////////////////////
		if ((_this select 1)== CHAN_GROUP) then
		{
			if (!isDedicated && {group player == _this select 2}) then
			{
				(_this select 0) call RC_FUNC(CDelLineMarker);
			};
			
			
			{
				if (( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && { _x != player && 
					{group _x == _this select 2} }) then
				{
					#define RC_EXEC_ARG _this select 0
					RC_EXEC_C(CDelLineMarker, owner _x);
				};
			} forEach playableUnits;		
		};




		//////////////////////////////////////////////////////////////////
		if ((_this select 1)== CHAN_GLOBAL) then
		{
			if (!isDedicated) then
			{
				(_this select 0) call RC_FUNC(CDelLineMarker);
			};
			
			
			{
				if (( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && { _x != player }) then
				{
					#define RC_EXEC_ARG _this select 0
					RC_EXEC_C(CDelLineMarker, owner _x);
				};
			} forEach playableUnits;		
		};
		
		
		
		
		//////////////////////////////////////////////////////////////////
		if ((_this select 1) == CHAN_VEHICLE) then
		{
			if (!isDedicated && {vehicle player == _this select 2}) then
			{
				(_this select 0) call RC_FUNC(CDelLineMarker);
			};
			
			
			{
				if (( isPlayer _x || {time <= 0 && (owner _x) > 2} ) && { _x != player && 
					{(vehicle _x) == _this select 2} }) then
				{
					#define RC_EXEC_ARG _this select 0
					RC_EXEC_C(CDelLineMarker, owner _x);
				};
			} forEach playableUnits;
		};

		

		
		// add log entry about deleting the marker
		// diag_log text format ["Line-marker %1 deleted at moment %2 by %3", _this select 0,
		//	diag_tickTime, _this select 1];
	};





};
RC_INIT_EH(SDelLineMarker);







FUNC(S__SendAllMarkers) =
{
	PV(_pid) = _this select 0;
	
	{
		PV(_z) = (_this select 1) getVariable [str _x, []];
		if (count _z > 0) then
		{
			#define RC_EXEC_ARG _z
			RC_EXEC_C(CAddLineMarker, _pid);
		};		
		
	} forEach ((_this select 1) getVariable["ids", []]);
};



// takes the calling player's object as the argument
RC_DEFINE(SRequestMarkersForPlayer) =
{
	_this spawn
	{
		if (!isNull _this) then
		{
			PV(_pid) = owner _this;
			
			PV(_z) = [];
			
			
			
			PV(_y) = GVAR(SSideMarkersLogic) getVariable [str (side (group _this)), objNull];
			if (!isNull _y) then
			{
				[_pid, _y] call FUNC(S__SendAllMarkers);
			};



			_y = GVAR(SGroupMarkersLogic) getVariable [str (group _this), objNull];
			if (!isNull _y) then
			{
				[_pid, _y] call FUNC(S__SendAllMarkers);
			};	
			
			[_pid, GVAR(SGlobalMarkersLogic)] call FUNC(S__SendAllMarkers);
		};
	};
};
RC_INIT_EH(SRequestMarkersForPlayer);




V_SERVER_READY = true;
publicVariable 'V_SERVER_READY';



