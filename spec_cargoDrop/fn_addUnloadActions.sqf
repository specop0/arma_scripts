/*
    Author: SpecOp0
    
    Description:
    For each ACE cargo item an ACE interaction will be added to 
    the vehicle to unload item (if player is in vehicle).
    
    Parameter(s):
    0: OBJECT - vehicle with cargo space
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_vehicle",objNull,[objNull]] ];

if(_parameterCorrect) then {
    // remove old actions
    private _actionUnloadID = SPEC_ACTION_UNLOAD_IDS;
    for "_i" from 0 to SPEC_ACTION_UNLOAD_MAX_ID do {
        [_vehicle,1,["ACE_SelfActions", format [_actionUnloadID,_i]]] call ace_interact_menu_fnc_removeActionFromObject; 
    };

    // addActions to unload cargo (ACE function not working if vehicle is flying)
    private _cargoObjects = _vehicle getVariable [ACE_CARGO_LOADED,[]];
    private _class = "";
    private _name = "";
    {
        _class = if (_x isEqualType "") then {_x} else {typeOf _x};
        _name = getText(configfile >> "CfgVehicles" >> _class >> "displayName");
        private _actionUnload = 
        [
            format [_actionUnloadID,_forEachIndex],
            _name,
            SPEC_ACTION_UNPACK_ICON,
            {
                _this remoteExec ["Spec_cargoDrop_fnc_unload",2];
            },
            {
                params ["_target","_caller"];
                (_this select 2) params ["_item"];
                _item in (_target getVariable [ACE_CARGO_LOADED,[]])
            }, {}, [_x]
        ] call ace_interact_menu_fnc_createAction;
        [_vehicle,1, ["ACE_SelfActions"], _actionUnload] call ace_interact_menu_fnc_addActionToObject;
    } forEach _cargoObjects;
};
true
