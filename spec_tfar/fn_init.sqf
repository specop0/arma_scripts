/*
    Author: SpecOp0

    Description:
    Sets the channel name and password.
    If client hasInterface (is a player) the TFAR frequencies are initialized (see fn_TFAR_initGroups)
    and a EventHandler is added if a new radio is received to set frequencies accordingly (see fn_setTFAR.sqf).
    Furthermore for each radio an entry to the ACE Menu (Equipment) is added.
    
    Parameter(s):
    -

    Returns:
    true
*/

if(hasInterface) then {
    player call Spec_tfar_fnc_initGroups;
    player call Spec_tfar_fnc_setFrequencies;
    player setVariable ["Spec_var_timeAtInit", serverTime];
    ["Spec_setTFAR", "OnRadiosReceived", Spec_tfar_fnc_setFrequencies, player] call TFAR_fnc_addEventHandler;
};
true
