/*
    Author: SpecOp0
    
    Description:
    Adds ACE Actions to take (intel) item.
    
    See const.hpp for name of action.
    
    Parameter(s):
    0: OBJECT - intel item
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_item",objNull,[objNull]] ];

if(_parameterCorrect && hasInterface) then {
    removeAllActions _item;
    private _actionTakeIntel =
    [
        SPEC_ACTION_TAKE_INTEL_ID,
        SPEC_ACTION_TAKE_INTEL_NAME,
        "",
        {
            params ["_target","_caller"];
            [0,
            {
                if(isNil {SPEC_VAR_INTEL_COUNT}) then {
                    SPEC_VAR_INTEL_COUNT = 0;
                };
                deleteVehicle _this;
                SPEC_VAR_INTEL_COUNT = SPEC_VAR_INTEL_COUNT + 1;
            },
            _target] call CBA_fnc_globalExecute;
        },
        {true}
    ] call ace_interact_menu_fnc_createAction;
    [_item,0,["ACE_MainActions"], _actionTakeIntel] call ace_interact_menu_fnc_addActionToObject;
};
true