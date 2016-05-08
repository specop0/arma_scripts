/*
    Author: SpecOp0
    
    Description:
    Aborts the construction progress (initiated via attachObject).
    
    Parameter(s):
    0: OBJECT - unit/player who wants to abort the construct progress
    1 (Optional): NUMBER - added displayEventHandler
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]], ["_eventHandlerID",-1,[0]] ];

if(!isNull _unit) then {
    // clear variables for attached object
    _unit setVariable [SPEC_VAR_ATTACHED_OBJECT,objNull];
    _unit setVariable [SPEC_VAR_OFFSET_HEIGHT,0];
    _unit setVariable [SPEC_VAR_OFFSET_DISTANCE,0];

    // clear ace actions
    {
        [_unit,1,["ACE_SelfActions",_x]] call ace_interact_menu_fnc_removeActionFromObject;
    } forEach [
        SPEC_ACTION_CONSTRUCT_ID,
        SPEC_ACTION_ABORT_ID,
        SPEC_ACTION_UP_ID,
        SPEC_ACTION_DOWN_ID,
        SPEC_ACTION_FAR_ID,
        SPEC_ACTION_NEAR_ID
    ];
    
    // remove eventHandler
    if(_eventHandlerID >= 0) then {
        (findDisplay 46) displayRemoveEventHandler ["KeyDown", _eventHandlerID];
    };
};
true
