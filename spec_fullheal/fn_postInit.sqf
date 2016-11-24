/*
    Author: SpecOp0
    
    Description:
    Assigns the full heal event handler to the player.
    The event handler will be automatically reassigned if the player respawns.
    
    Parameter(s):
    -
    
    Returns:
    true
*/
if(hasInterface) then {
    [player] call Spec_fullheal_fnc_addEventHandler;
};
true
