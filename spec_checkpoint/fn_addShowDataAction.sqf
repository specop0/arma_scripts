/*
    Author: SpecOp0
    
    Description:
    Adds ACE Actions to unit (player).
    If Action is activated data (smuggler and intel count) is shown.
    
    See const.hpp for name of action and array of smuggler items.
    
    Parameter(s):
    0: OBJECT - unit / player
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]] ];

if(_parameterCorrect && hasInterface && local _unit) then {
    private _actionShowSmugglerCount =
    [
        SPEC_ACTION_SHOW_DATA_ID,
        SPEC_ACTION_SHOW_DATA_NAME,
        "",
        {
            params ["_target","_caller"];
            [0,
            {
                if(isNil {SPEC_VAR_SMUGGLER_COUNT}) then {
                    SPEC_VAR_SMUGGLER_COUNT = 0;
                };
                if(isNil {SPEC_VAR_INTEL_COUNT}) then {
                    SPEC_VAR_INTEL_COUNT = 0;
                };
                format ["Schmuggler durchgelassen: %1\nInformationen gesammelt: %2",SPEC_VAR_SMUGGLER_COUNT,SPEC_VAR_INTEL_COUNT] remoteExec ["hint",_this];
            },
            _caller] call CBA_fnc_globalExecute;
        },
        {true}
    ] call ace_interact_menu_fnc_createAction;
    [_unit,1,["ACE_SelfActions"], _actionShowSmugglerCount] call ace_interact_menu_fnc_addActionToObject;
};
true
