#ifndef __STRUCTURES_H__
#define __STRUCTURES_H__


#define MARKERS_VAR_IN_PLAYERS "_DMAMMarkers"

#define MAX_DISTANCE_FOR_GROUP 1000
#define MAX_DISTANCE_FOR_DIRECT 5



#define CHAN_GROUP 3
#define CHAN_SIDE 1
#define CHAN_GLOBAL 0
#define CHAN_VEHICLE 4
#define CHAN_COMMAND 2
#define CHAN_DIRECT 5





#define MAR_ID(x) ((x) select 0)
#define MAR_UID(x) ((x) select 1)
#define MAR_CHAN(x) ((x) select 2)
#define MAR_CHANDATA(x) ((x) select 3)
#define MAR_NAME(x) ((x) select 4)
#define MAR_TEXT(x) ((x) select 5)
#define MAR_TYPE(x) ((x) select 6)
#define MAR_COLOR(x) ((x) select 7)
#define MAR_THICKNESS(x) ((x) select 8)
#define MAR_COORDS(x) ((x) select 9)
#define MAR_DAYTIME(x) ((x) select 10)



#endif
