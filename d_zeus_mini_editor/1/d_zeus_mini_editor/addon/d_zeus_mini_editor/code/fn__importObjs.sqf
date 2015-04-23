#include "addon.hpp"
#include "main.hpp"

#define CALLEXT(x) ("d_zeus_mini_editor" callExtension (x))
#define CHKERR(x) if ((x) != "OK") exitWith {hint format["ZME DLL error: %1", (x)];}

// init
PV(_misname) = format["%1.%2" , missionName, worldName];
PV(_misdir) = "missions";

if (isMultiplayer) then
{
	_misdir = "MPMissions";
};

PV(_fullpath) = format["Arma 3\%1\%2\mission.sqm", _misdir, _misname];



PV(_cmd) = format["BEGIN %1", _fullpath];
diag_log text ("sending to ZME DLL: " + _cmd);
PV(_rv) = CALLEXT(_cmd);
diag_log text ("received from ZME DLL: " + _rv);
CHKERR(_rv);



// the command
_cmd = "IMPORT_ALL";
diag_log text ("sending to ZME DLL: " + _cmd);
PV(_rv) = CALLEXT(_cmd);
diag_log text ("received from ZME DLL: " + _rv);
CHKERR(_rv);




// finalizing
_cmd = "END";
diag_log text ("sending to ZME DLL: " + _cmd);
PV(_rv) = CALLEXT(_cmd);
diag_log text ("received from ZME DLL: " + _rv);
CHKERR(_rv);



hint "IMPORT_ALL is done!";
