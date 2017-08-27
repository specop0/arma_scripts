/*
    Author: SpecOp0

    Description:
    Does a farming action/animation and afterwards adds another farming waypoint.

    Parameter(s):
    0: OBJECT - (AI) unit who farms

    Returns:
    true
*/
params ["_unit"];
// play animations
_unit playActionNow "PlayerCrouch";
sleep 2;
_unit playActionNow "PlayerStand";
sleep 1;
// add next farming waypoint
[_unit] call Spec_farming_fnc_addFarmingWaypoint;
true
