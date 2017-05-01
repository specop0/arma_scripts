/*
    Author: SpecOp0
    
    Description:
    Activates or deactivates a loop to show the medic data of
    - the player if unconscious
    - the nearest man
    
    Parameter(s):
    0: BOOL - flag indicating wether the loop should be activated or deactivated.
    
    Returns:
    true
*/

#define SPEC_MEDIC_ACTIVATE_VAR "Spec_medic_activateMedicData"
params [ ["_activate",true,[true]] ];

if(hasInterface) then {
    private _loopActive = missionNamespace getVariable [SPEC_MEDIC_ACTIVATE_VAR, false];
    if(!_loopActive isEqualTo _activate) then {
        if(_activate) then {
            missionNamespace setVariable [SPEC_MEDIC_ACTIVATE_VAR, true];
            // activate loop
            [{
                params ["_args","_id"];
                if(missionNamespace getVariable [SPEC_MEDIC_ACTIVATE_VAR, false]) then {
                    // if player is unconscious output its medic data
                    if([player] call ace_medical_fnc_getUnconsciousCondition) then {
                            [player] call Spec_medic_fnc_showMedicData;
                    } else {
                        // find nearest man and show its medic data
                        private _nearestObjects = nearestObjects [player, ["CAManBase"], 5];
                        if(count _nearestObjects > 1) then {
                            private _target = _nearestObjects select 1;
                            [_target] call Spec_medic_fnc_showMedicData;
                        } else {
                            hintSilent "Kein Ziel gefunden";
                        };
                    };
                } else {
                    // abort show medic data
                    [_id] call CBA_fnc_removePerFrameHandler;
                };
            }, 0, []] call CBA_fnc_addPerFrameHandler;
        } else {
            missionNamespace setVariable [SPEC_MEDIC_ACTIVATE_VAR, false];
        };
    };
};
true
