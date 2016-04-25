/*
    Author: SpecOp0
    
    Description:
    Assigns multiple constructable objects (of one type) to an object via ACE interaction.
    A player is then able to initiate the construction process of given type (see playerAddConstructionAction).
    
    Parameter(s):
    0: OBJECT - object to assign as construction station
    1: STRING - type of object to build
    2: STRING - name of object type (text will be added see const.hpp)
    3: NUMBER - number of animations to display before finishing the construction
    4: NUMBER - number of objects available to this station (race condition)
    
    Returns:
    true
*/
#include "const.hpp"

params [
    ["_object",objNull,[objNull]],
    ["_objectTypeToBuild","",[""]],
    ["_objectName","",[""]],
    ["_numberOfAnimations",1,[0]],
    ["_numberOfObjectsAvailable",1,[0]]
];

if(!isNull _object && !("" in [_objectName,_objectTypeToBuild])) then {
    if(isServer) then {
        _object setVariable [_objectTypeToBuild,_numberOfObjectsAvailable,true];
    };
    if(hasInterface) then {
        [_object,0,["ACE_MainActions",_objectTypeToBuild]] call ace_interact_menu_fnc_removeActionFromObject;
        private _buildingAvailableBoolString = format [SPEC_ACTION_ATTACH_BOOL_STR,_objectTypeToBuild];
        private _actionName = format [SPEC_ACTION_CONSTRUCT_NAME_PARAM,_objectName];
        // add action
        private _action = [
            _objectTypeToBuild,
            _actionName,
            "",
            {
                params ["_target","_caller","_argv"];
                // change _numberOfObjectsAvailable 
                private _objectTypeToBuild = _argv select 3;
                private _numberOfObjectsAvailable = (_target getVariable [_objectTypeToBuild,0]);
                _numberOfObjectsAvailable = _numberOfObjectsAvailable - 1;
                _target setVariable [_objectTypeToBuild,_numberOfObjectsAvailable, true];
                hint format [SPEC_HINT_NUMBER_OF_OBJECTS_LEFT, _numberOfObjectsAvailable];
                // add _numberOfObjectsAvailable to action ID
                _argv set [0, _caller];
                _argv set [1, format ["%1_%2",_objectTypeToBuild,_numberOfObjectsAvailable]];
                _argv call SPEC_FNC_PLAYER_ADD_CONSTRUCT_ACTION;
            },
            {
                params ["_target","_caller"];
                private _objectTypeToBuild = (_this select 2) select 3;
                _target getVariable [_objectTypeToBuild,0] > 0;
            }, {}, [_object,_objectTypeToBuild,_actionName,_objectTypeToBuild,_numberOfAnimations,_buildingAvailableBoolString]
        ] call ace_interact_menu_fnc_createAction;
        [_object,0,["ACE_MainActions"],_action] call ace_interact_menu_fnc_addActionToObject;
    };
};
true
