/*
    Author: SpecOp0
    
    Description:
    Adds Action EventHandler to given vehicle to allow a
    unit who gets in (Driver and Gunner) to unload ACE 
    cargo space in the air (with a parachute).
    
    Parameter(s):
    0: OBJECT - vehicle with cargo space
    
    Returns:
    true
*/

private _parameterCorrect = params [ ["_vehicle",objNull,[objNull]] ];

if(_parameterCorrect && hasInterface) then {
    _vehicle addEventHandler ["GetIn",{
        params ["_vehicle","_position"];
        if(_position in ["driver","gunner"]) then {
            [_vehicle] call Spec_cargoDrop_fnc_addUnloadActions;
        };
    }];
};
true
