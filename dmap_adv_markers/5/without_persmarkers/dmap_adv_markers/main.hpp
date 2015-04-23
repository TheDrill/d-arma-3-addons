#ifndef __MAIN_HPP_
#define __MAIN_HPP_

// main macros

//#define MAIN_INIT PLAYER_SESSION_ID = -1; if (!isDedicated) then \
//	{[] spawn = {  waitUntil{player == player}; PLAYER_SESSION_ID =  }};
//#define PLAYER_SESSION_ID dMapLineMarkerSysPlayerID


#define BASENAME dMapAdvMarkersSys

#define FUNC(x) fnc_##BASENAME##_##x

#define GVAR(x) BASENAME##_##x
#define UIGV(x) BASENAME##UI_##x

#define PV(x) private ['x']; x



// remote commands (public vars with event handlers)

#define RC_DEFINE(x) fnc_##BASENAME##RC_##x 
#define RC_INIT_EH(x) 'BASENAME##RC_##x' addPublicVariableEventHandler {(_this select 1) call fnc_##BASENAME##RC_##x;}

#define RC_FUNC(x) fnc_##BASENAME##RC_##x
#define RC_VAR(x) ##BASENAME##RC_##x

// should be defined to pass params
#define RC_EXEC_ARG []

#define RC_EXEC_AC(x) BASENAME##RC_##x = (RC_EXEC_ARG); \
	publicVariable 'BASENAME##RC_##x'; \
	if (!isDedicated) then {BASENAME##RC_##x call fnc_##BASENAME##RC_##x;}
	
#define RC_EXEC_S(x) if (isServer) then \
	{(RC_EXEC_ARG) call fnc_##BASENAME##RC_##x;} else \
	{BASENAME##RC_##x = (RC_EXEC_ARG); publicVariableServer 'BASENAME##RC_##x';}
	
#define RC_EXEC_C(x,z) BASENAME##RC_##x = (RC_EXEC_ARG); \
	(z) publicVariableClient 'BASENAME##RC_##x'


// other


#define M_MARKER_BASE "_dMapLineMarkerSys_Marker"
#define M_MARKER(i, j) (M_MARKER_BASE + "_" + (str (i)) + "_" + (str (j)))



// marker array utils
// 0: id, 1: channel id, 2: channel data, 3: markername, 4: markertext, 5: type, 6: color, 7: thickness, 8:coords array

#define MAR_ID(x) ((x) select 0)
#define MAR_CHAN(x) ((x) select 1)
#define MAR_CHANDATA(x) ((x) select 2)
#define MAR_NAME(x) ((x) select 3)
#define MAR_TEXT(x) ((x) select 4)
#define MAR_TYPE(x) ((x) select 5)
#define MAR_COLOR(x) ((x) select 6)
#define MAR_THICKNESS(x) ((x) select 7)
#define MAR_COORDS(x) ((x) select 8)



// channels

#define CHAN_GROUP 3
#define CHAN_SIDE 1
#define CHAN_GLOBAL 0
#define CHAN_VEHICLE 4
#define CHAN_COMMAND 2
#define CHAN_DIRECT 5


// direct and command unimplemented


// marker tag visibility values

#define MTAG_ALWAYS_OFF 0
#define MTAG_OFF 1
#define MTAG_ON 2
#define MTAG_ALWAYS_ON 3


#define PROFILE_MTAG_OPTION_VAR_NAME "DMapAdvMarkersSys_MarkerTagsVisibilitySettings"



#define V_SERVER_READY GVAR(ServerReady)





// common

// mutex...dont work in eventhandlers, so no of use right now


//#define MUTEX(x) BASENAME##Mutex_##x = [true]
//#define MUTEX_LOCK(x) waitUntil{ [BASENAME##Mutex_##x select 0,BASENAME##Mutex_##x set [0,false]] select 0}
//#define MUTEX_UNLOCK(x) BASENAME##Mutex_##x set [0,true]
//#define MUTEX_STATUS(x) (BASENAME##Mutex_##x select 0)

#endif
