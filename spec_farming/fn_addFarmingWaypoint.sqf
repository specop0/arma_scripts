/*
    Author: SpecOp0

    Description:
    Adds a waypoint to the group of the unit at which the leader makes a farming action.
    The unit must have the farming area set via a marker which name is saved into "Spec_farming_marker".

    Parameter(s):
    0: OBJECT - (AI) unit who farms

    Returns:
    true
*/
params ["_unit"];
private _markerName = _unit getVariable ["Spec_farming_marker", ""];
if !(_markerName isEqualTo "") then {
    // add waypoint to random position in marker
    private _wp = (group _unit) addWaypoint [
        [_markerName] call BIS_fnc_randomPosTrigger,
        0
    ];
    // after a timeout do the farming action (which calls this function for a recursion)
    _wp setWaypointTimeout [1,2,3];
    _wp setWaypointStatements ["true", "[this] spawn Spec_farming_fnc_farmingAction;"];
};
true
