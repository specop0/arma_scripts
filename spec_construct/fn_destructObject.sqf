/*
    Author: SpecOp0
    
    Description:
    Destruct given object (globally).
    
    Parameter(s):
    0: OBJECT - unit/player who wants to construct something
    1: STRING - id of action (unique or the last will be overwritten)
    2: STRING - name of action
    3: OBJECT - object to destruct
    4: NUMBER - current number of animation which is displayed
    5: NUMBER - number of animations to display before finishing the destruction
    
    Returns:
    true
*/
#include "const.hpp"

params [
    ["_unit",objNull,[objNull]],
    ["_actionID","",[""]],
    ["_actionName","",[""]],
    ["_objectToDestruct",objNull,[objNull]],
    ["_currentAnimation",0,[0]],
    ["_numberOfAnimations",1,[0]]
];

// position query
if(!isNull _unit && !isNull _objectToDestruct) then {
    _currentAnimation = _currentAnimation + 1;
    private _numberOfDestructAnimations = round(_numberOfAnimations / 2.0);
    if(_currentAnimation <= _numberOfDestructAnimations) then {
        _unit playMove SPEC_ACTION_BUILD_ANIMATION;
        [
            SPEC_ACTION_BUILD_ANIMATION_TIME,
            [_unit,_actionID,_actionName,_objectToDestruct,_currentAnimation,_numberOfAnimations],
            {
                (_this select 0) call SPEC_FNC_DECONSTRUCT_ACTION;
            },
            {
                (_this select 0) params ["_unit"];
                _unit switchMove "";
            },
            format [SPEC_ACTION_BUILD_STATUS_TEXT,_currentAnimation, _numberOfDestructAnimations] 
        ] call ace_common_fnc_progressBar;
    } else {
        _unit switchMove "";
        private _type = typeOf _objectToDestruct;
        deleteVehicle _objectToDestruct;
        [_unit,_actionID,_actionName,_type,_numberOfAnimations] call SPEC_FNC_PLAYER_ADD_CONSTRUCT_ACTION;
    };
};
true
