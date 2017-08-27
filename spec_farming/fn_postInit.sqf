/*
    Author: SpecOp0

    Description:
    Adds for each group a farming waypoint.

    Parameter(s):
    -

    Returns:
    true
*/
if(isServer) then {
    {
        [leader _x] call Spec_farming_fnc_addFarmingWaypoint;
    } forEach allGroups;
};
true
