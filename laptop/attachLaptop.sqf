/*
    Author: SpecOp0

    Description:
    Attaches an item (e.g. laptop) to the unit.
    Additional it will be detached if the unit is killed or disconnects.
    
    Parameter(s):
    0: OBJECT - target item to attach (e.g. a laptop)
    1: OBJECT - caller to attach the target item to (e.g. a player who chooses the menu entry)

    Returns:
    true
    
    Usage (initPlayerLocal.sqf):
    myLaptop addAction ["Take Laptop", { _this call compile preprocessFileLineNumbers "attachLaptop.sqf"; }, nil, 1.5, true, true, "", "true", 2];
*/

params ["_target","_caller"];

detach _target;
_target attachTo [_caller, [-0.25, -0.04, 0], "pelvis"];
_target setVectorDirAndUp [[0.1,1,0],[-1,0,0.2]];

// what happens if the unit is killed or disconnects? -> detach laptop
if(_caller getVariable ["hasKilledEH",false]) then {
	// killed
	_caller addEventHandler ["Respawn",{
		params ["_unitDead","_killer"];
		[_unitDead,_unitDead]  call compile preprocessFileLineNumbers "detachLaptop.sqf";
	}];
	// disconnect
	[_caller,["HandleDisconnect",{
		params ["_unitDC"];
		[_unitDC,_unitDC]  call compile preprocessFileLineNumbers "detachLaptop.sqf";
	}]] remoteExec ["addEventHandler",2];
	_caller setVariable ["hasKilledEH",true];
};

true
