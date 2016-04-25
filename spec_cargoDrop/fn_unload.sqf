/*
    Author: SpecOp0
    
    Description:
    Unloads item from ACE cargo space and calls function to add a Parachute.
    
    Partially reproduces ace functions.
    See const.hpp for distance behind the plane.
    
    Parameter(s):
    0: OBJECT - vehicle with cargo space
    1: OBJECT - player who activated action
    2 (Optional): ARRAY
        0: OBJECT - item to unload (has to be in given vehicle)
    
    Returns:
    BOOL - true if item is in vehicle
*/
#include "const.hpp"

params [ ["_vehicle",objNull,[objNull]], ["_caller",objNull,[objNull]] ];
(_this select 2) params [ ["_item",objNull,[objNull]] ];
private _returnValue = false;

if(!isNull _vehicle && !isNull _item) then {
    // select position 20m behind vehicle
    private _posATL = getPosATL _vehicle;
    private _direction = direction _vehicle + 180.0;
    _posATL set [0, (_posATL select 0) + (sin _direction) * SPEC_ACTION_UNLOAD_DISTANCE_TO_PLANE];
    _posATL set [1, (_posATL select 1) + (cos _direction) * SPEC_ACTION_UNLOAD_DISTANCE_TO_PLANE];

    // unload cargo
    // copied from ace_cargo_fnc_unloadItem
    private _loaded = _vehicle getVariable [ACE_CARGO_LOADED,[]];
    if (_item in _loaded) then {
        _loaded deleteAt (_loaded find _item);
        _vehicle setVariable [ACE_CARGO_LOADED, _loaded, true];

        private _space = [_vehicle] call ace_cargo_fnc_getCargoSpaceLeft;
        private _itemSize = [_item] call ace_cargo_fnc_getSizeItem;
        _vehicle setVariable [ACE_CARGO_SPACE, (_space + _itemSize), true];
        detach _item;
        
        // copied from ServerUnloadCargo Event
        //["ServerUnloadCargo", [_item, _posATL]] call ace_common_fnc_serverEvent;
        _item hideObjectGlobal false;
        _item setPosATL _posATL;
        
        // add parachute (routine)
        [_item,2] call Spec_cargoDrop_fnc_addParachute;
        _returnValue = true;
    };
};
_returnValue
