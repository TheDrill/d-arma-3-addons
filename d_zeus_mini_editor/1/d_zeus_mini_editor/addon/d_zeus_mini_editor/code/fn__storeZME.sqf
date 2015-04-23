#include "addon.hpp"
#include "main.hpp"


#define CALLEXT(x) ("d_zeus_mini_editor" callExtension (x))
#define CHKERR(x) if ((x) != "OK") exitWith {hint format["ZME DLL error: %1", (x)];}

if (isNull GVAR(curatorObj)) exitWith {};

// begin communication with the extension


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


// updating/adding objects
{
	if (isNull group _x) then
	{
		PV(_objstr) = _x call CFUNC(_getObjInfoStr);

		_cmd = format["SET %1", _objstr];
		diag_log text ("sending to ZME DLL: " + _cmd);
		_rv = CALLEXT(_cmd);
		diag_log text ("received from ZME DLL: " + _rv);
		CHKERR(_rv);

	};
} forEach (curatorEditableObjects GVAR(curatorObj));

if (_rv != "OK") exitWith {};


// finalizing
_cmd = "END";
diag_log text ("sending to ZME DLL: " + _cmd);
PV(_rv) = CALLEXT(_cmd);
diag_log text ("received from ZME DLL: " + _rv);
CHKERR(_rv);



deleteVehicle GVAR(curatorObj);


hint "ZME seems to be done writing changes to SQM!"
