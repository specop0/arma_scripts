/*
    Author: SpecOp0

    Description:
    Detaches all items (e.g. laptop) from to the unit.
    
    Parameter(s):
    0: -
    1: OBJECT - caller to attach the target item to (e.g. a player who chooses the menu entry)

    Returns:
    true
    
    Usage (initPlayerLocal.sqf):
    player addAction ["Put Laptop down", { _this call compile preprocessFileLineNumbers "detachLaptop.sqf"; }, nil, 1.5, true, true, "", "count attachedObjects _this > 0"];
*/

params ["_target","_caller"];

private _dir = direction _caller;
private _posASL = getPosASL _caller;
// place items before player (for large distance posATL / posAGL better)
private _distance = 0.5;
_posASL set [0,(_posASL select 0) + _distance * sin(_dir)];
_posASL set [1,(_posASL select 1) + _distance * cos(_dir)];
// face item to player
_dir = _dir + 180;
{
	detach _x;
	_x setPosASL _posASL;
	_x setDir _dir;
} forEach attachedObjects _caller;

true
