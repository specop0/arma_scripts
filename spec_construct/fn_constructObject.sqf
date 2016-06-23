/*
    Author: SpecOp0
    
    Description:
    Construct given object (globally).
    
    Parameter(s):
    0: OBJECT - unit/player who wants to construct something
    1: STRING - type of object to build
    2: POSITION - position of object (posASL)
    3: NUMBER - direction of object
    4: NUMBER - current number of animation which is displayed
    5: NUMBER - number of animations to display before finishing the construction
    6: STRING - name of variable (via getVariable) to reactivate parent construction action if construction is aborted
    
    Returns:
    true
*/
#include "const.hpp"

params [
    ["_unit",objNull,[objNull]],
    ["_objectTypeToBuild","",[""]],
    ["_posASL",[0,0,0],[[]]],
    ["_direction",0,[0]], 
    ["_currentAnimation",0,[0]],
    ["_numberOfAnimations",1,[0]],
    ["_buildingAvailableBoolString","",[""]]
];

// position query
if(!isNull _unit && !("" in [_objectTypeToBuild,_buildingAvailableBoolString])) then {
    _currentAnimation = _currentAnimation + 1;
    if(_currentAnimation <= _numberOfAnimations) then {
        _unit playMove SPEC_ACTION_BUILD_ANIMATION;
        [
            SPEC_ACTION_BUILD_ANIMATION_TIME,
            [_unit,_objectTypeToBuild,_posASL,_direction,_currentAnimation,_numberOfAnimations,_buildingAvailableBoolString],
            {
                (_this select 0) call SPEC_FNC_CONSTRUCT_ACTION;
            },
            {
                (_this select 0) params ["_unit"];
                _unit switchMove "";
            },
            format [SPEC_ACTION_BUILD_STATUS_TEXT,_currentAnimation, _numberOfAnimations] 
        ] call ace_common_fnc_progressBar;
    } else {
        _unit switchMove "";
        _unit setVariable [_buildingAvailableBoolString,false];
        // create object
        private _object = _objectTypeToBuild createVehicle position _unit;
        _object setDir _direction;
        _object setPosASL _posASL;
        // don't change owner ship because of static object
        // add destruct action
        if(SPEC_BUILD_DESTRUCTION_AVAILABLE) then {
            [
                -1,
                {
                    params ["_object","_actionID","_actionName","_objectToDestruct","_currentAnimation", "_numberOfAnimations"];
                    private _destructAction = [
                        SPEC_ACTION_DESTRUCT_ID,
                        SPEC_ACTION_DESTRUCT_NAME,
                        "",
                        {
                            (_this select 2) call SPEC_FNC_DECONSTRUCT_ACTION;
                        },
                        {true},{},
                        [player,_actionID,_actionName,_objectToDestruct,_currentAnimation,_numberOfAnimations]
                    ] call ace_interact_menu_fnc_createAction;
                    [_object,0,["ACE_MainActions"],_destructAction] call ace_interact_menu_fnc_addActionToObject;
                },
                [_object,_objectTypeToBuild,format [SPEC_ACTION_CONSTRUCT_NAME_PARAM,_objectTypeToBuild],_object,0,_numberOfAnimations]
            ] call CBA_fnc_globalExecute;
        };
    };
};
true
