/*
    Author: SpecOp0
    
    Description:
    Aborts the construction progress of (locally) attached object.
    
    Parameter(s):
    0: OBJECT - unit/player which has object attached
    1 (Optional): NUMBER - added displayEventHandler
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]], ["_eventHandlerID",-1,[0]] ];

if(!isNull _unit) then {
    private _attachedObject = _unit getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull];
    if(!isNull _attachedObject) then {
        detach _attachedObject;
        deleteVehicle _attachedObject;
    };
    [_unit,_eventHandlerID] call SPEC_FNC_CLEAR_ATTACHED_OBJECT;
};
true
