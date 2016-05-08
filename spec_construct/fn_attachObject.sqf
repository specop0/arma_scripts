/*
    Author: SpecOp0
    
    Description:
    Attaches (locally created) object to unit/player, who is then able to construct this object.
    In Addition several ACE self interactions for construction are added.
    
    Parameter(s):
    0: OBJECT - unit/player who wants to construct something
    1: STRING - type of object to build
    2: NUMBER - number of animations to display before finishing the construction
    3: STRING - name of variable (via getVariable) to reactivate parent construction action if construction is aborted
    
    Returns:
    true
*/
#include "const.hpp"

params [
    ["_unit",objNull,[objNull]],
    ["_objectTypeToBuild","",[""]],
    ["_numberOfAnimations",1,[0]],
    ["_buildingAvailableBoolString","",[""]]
];

if(!isNull _unit && !("" in [_objectTypeToBuild,_buildingAvailableBoolString])) then {
    // clear function to reset variables
    [_unit] call SPEC_FNC_CLEAR_ATTACHED_OBJECT;

    // create local object
    private _attachedObject = _objectTypeToBuild createVehicleLocal (getPosASL _unit);
    _attachedObject setDir (direction _unit);
    _unit setVariable [SPEC_VAR_ATTACHED_OBJECT,_attachedObject];

    // attach object
    [_unit,0,"nothing"] call SPEC_FNC_OFFSET_CONSTRUCTION;
    
    // add KeyHandler
    private _eventHandlerID = [] call SPEC_FNC_ADD_KEY_HANDLER;

    // abort
    private _actionAbort = [
        SPEC_ACTION_ABORT_ID,
        SPEC_ACTION_ABORT_NAME,
        "",
        {
            params ["_target","_caller","_argv"];
            [_caller, _argv select 0] call SPEC_FNC_ABORT_CONSTRUCT;
        },
        {true}, {}, [_eventHandlerID]
    ] call ace_interact_menu_fnc_createAction;
    [_unit,1,["ACE_SelfActions"],_actionAbort] call ace_interact_menu_fnc_addActionToObject;

    // build
    private _actionBuild = [
        SPEC_ACTION_CONSTRUCT_ID,
        SPEC_ACTION_CONSTRUCT_NAME,
        "",
        {
            params ["_target","_caller"];
            (_this select 2) params ["_numberOfAnimations","_buildingAvailableBoolString","_eventHandlerID"];
            private _attachedObject = _caller getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull];
            if(!isNull _attachedObject) then {
                detach _attachedObject;
                private _direction = direction _attachedObject;
                private _posASL = getPosASL _attachedObject;
                private _type = typeOf _attachedObject;
                private _boundingBoxClear = [_attachedObject] call SPEC_FNC_IS_BOUNDING_BOX_FREE;
                if(_boundingBoxClear) then {
                    deleteVehicle _attachedObject;
                    [_caller,_eventHandlerID] call SPEC_FNC_CLEAR_ATTACHED_OBJECT;
                    [_caller,_type,_posASL,_direction,0,_numberOfAnimations,_buildingAvailableBoolString] call SPEC_FNC_CONSTRUCT_ACTION;
                } else {
                    [_caller,0,"nochange"] call SPEC_FNC_OFFSET_CONSTRUCTION;
                    hint SPEC_HINT_MAN_NEARBY;
                };
            };
        },
        {
            params ["_target","_caller"];
            !isNull (_caller getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull])
        }, {}, [_numberOfAnimations,_buildingAvailableBoolString,_eventHandlerID]
    ] call ace_interact_menu_fnc_createAction;
    [_unit,1,["ACE_SelfActions"],_actionBuild] call ace_interact_menu_fnc_addActionToObject;

    // change offset
    private _actionsChangeOffset = [
        [SPEC_ACTION_UP_ID,   SPEC_ACTION_UP_NAME,   SPEC_VAR_OFFSET_INCREASE, SPEC_VAR_OFFSET_TYPE_HEIGHT],
        [SPEC_ACTION_DOWN_ID, SPEC_ACTION_DOWN_NAME, SPEC_VAR_OFFSET_DECREASE, SPEC_VAR_OFFSET_TYPE_HEIGHT],
        [SPEC_ACTION_FAR_ID,  SPEC_ACTION_FAR_NAME,  SPEC_VAR_OFFSET_INCREASE, SPEC_VAR_OFFSET_TYPE_DISTANCE],
        [SPEC_ACTION_NEAR_ID, SPEC_ACTION_NEAR_NAME, SPEC_VAR_OFFSET_DECREASE, SPEC_VAR_OFFSET_TYPE_DISTANCE]
    ];
    {
        private _actionChangeOffset = [
            _x select 0,
            _x select 1,
            "",
            {
                params ["_target","_caller"];
                (_this select 2) params ["","","_change","_changeTypeString"];
                [_caller,_change,_changeTypeString] call SPEC_FNC_OFFSET_CONSTRUCTION;
            },
            {
                params ["_target","_caller"];
                !isNull (_caller getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull])
            }, {}, _x
        ] call ace_interact_menu_fnc_createAction;
        [_unit,1,["ACE_SelfActions"],_actionChangeOffset] call ace_interact_menu_fnc_addActionToObject;
    } forEach _actionsChangeOffset;
};
true
