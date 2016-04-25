/*
    Author: FETT, SpecOp0

    Description:
    Changes to owner of a (placed) group and adds it to all Curators.

    Parameter(s):
    0: OBJECT - curator which placed the unit
    1: OBJECT - group which was placed

    Returns:
    true
*/

private _parameterCorrect = params [ ["_curator",objNull,[objNull]],["_groupPlaced",grpNull,[grpNull]] ];

if(_parameterCorrect && isServer) then {
    // make group editable for allCurators
    {
        _x addCuratorEditableObjects [(units _groupPlaced),true];
    } forEach (allCurators - [_curator]);
};
true
