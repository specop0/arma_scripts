/*
    Author: SpecOp0
    
    Description:
    Assigns ACE interaction to object.
    A player is then able to initiate the construction process of given type (see playerAddConstructionAction).
    
    Parameter(s):
    0: OBJECT - object to assign action
    1: STRING - id of action (unique or the last will be overwritten)
    2: STRING - name of action
    3: STRING - type of object to build
    4: NUMBER - number of animations to display before finishing the construction
    
    Returns:
    true
*/
#include "const.hpp"

params [
    ["_object",objNull,[objNull]],
    ["_actionID","",[""]],
    ["_actionName","",[""]],
    ["_objectTypeToBuild","",[""]],
    ["_numberOfAnimations",1,[0]]
];

if(!isNull _object && !("" in [_actionID,_actionName,_objectTypeToBuild])) then {
    // clear id and boolean variable
    private _buildingAvailableBoolString = format [SPEC_ACTION_ATTACH_BOOL_STR,_actionID];
    if(isServer) then {
        _object setVariable [_buildingAvailableBoolString,true,true];
    };
    if(hasInterface) then {
        [_object,0,["ACE_MainActions",_actionName]] call ace_interact_menu_fnc_removeActionFromObject;
        // add action
        private _action = [
            _actionID,
            _actionName,
            "",
            {
                params ["_target","_caller","_argv"];
                private _buildingAvailableBoolString = _argv select 5;
                _target setVariable [_buildingAvailableBoolString,false,true];
                _argv set [0,_caller];
                _argv call SPEC_FNC_PLAYER_ADD_CONSTRUCT_ACTION;
            },
            {
                params ["_target","_caller"];
                private _buildingAvailableBoolString = (_this select 2) select 5;
                _target getVariable [_buildingAvailableBoolString,true];
            }, {}, [_object,_actionID,_actionName,_objectTypeToBuild,_numberOfAnimations,_buildingAvailableBoolString]
        ] call ace_interact_menu_fnc_createAction;
        [_object,0,["ACE_MainActions"],_action] call ace_interact_menu_fnc_addActionToObject;
    };
};
true
