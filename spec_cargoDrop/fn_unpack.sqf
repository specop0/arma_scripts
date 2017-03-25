/*
    Author: SpecOp0
    
    Description:
    Unpacks attached item from supply crate.
    This function has to be called on the server.
    
    Parameter(s):
    0: OBJECT - supply crate to unpack
    1: OBJECT - player who activated action
    
    Returns:
    true
*/
#include "const.hpp"

params [ ["_target",objNull,[objNull]] , "_caller"];

if(!isNull _target) then {
    private _crates = _target getVariable [SPEC_ATTACHED_CRATES_VAR,[]];
    private _posASL = getPosASL _target;
    private _direction = (direction _target) + 90;
    private _offset = 1;
    private _angle = 0;
    _target setPosASL [0,0,0];
    {
        detach _x;
        _angle = 45 + 90 * _forEachIndex;
        _x hideObjectGlobal false;
        _x setPosASL [
            (_posASL select 0) + (_offset * (sin (_angle + _direction))),
            (_posASL select 1) + (_offset * (cos (_angle + _direction))),
            _posASL select 2
        ];
        _x setDir _direction;
    } forEach _crates;
    deleteVehicle _target;
};
true
