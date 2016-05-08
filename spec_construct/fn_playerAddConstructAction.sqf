/*
    Author: SpecOp0
    
    Description:
    Assigns ACE (self) interaction to unit (player).
    The unit is then able to initiate the construction process of given type (see attachObject).
    
    Parameter(s):
    0: OBJECT - unit/player to assign action
    1: STRING - id of action (unique or the last will be overwritten)
    2: STRING - name of action
    3: STRING - type of object to build
    4: NUMBER - number of animations to display before finishing the construction
    
    Returns:
    true
*/
#include "const.hpp"

params [
    ["_unit",objNull,[objNull]],
    ["_actionID","",[""]],
    ["_actionName","",[""]],
    ["_objectTypeToBuild","",[""]],
    ["_numberOfAnimations",1,[0]]
];

if(hasInterface && !isNull _unit && !("" in [_actionID,_actionName,_objectTypeToBuild])) then {
    // clear id and boolean variable
    [_unit,1,["ACE_SelfActions",_actionID]] call ace_interact_menu_fnc_removeActionFromObject;
    private _buildingAvailableBoolString = format [SPEC_ACTION_ATTACH_BOOL_STR,_actionID];
    _unit setVariable [_buildingAvailableBoolString, true ];
    // add action
    private _action = [
        _actionID,
        _actionName,
        "",
        {
            params ["_target","_caller","_argv"];
            _argv call SPEC_FNC_ATTACH_OBJECT;
        },
        {
            params ["_target","_caller","_argv"];
            private _buildingAvailableBoolString = _argv select 3;
            _caller getVariable [_buildingAvailableBoolString, true ] && isNull (_caller getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull]);
        }, {}, [_unit,_objectTypeToBuild,_numberOfAnimations,_buildingAvailableBoolString]
    ] call ace_interact_menu_fnc_createAction;
    [_unit,1,["ACE_SelfActions"],_action] call ace_interact_menu_fnc_addActionToObject;
};
true
