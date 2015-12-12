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

private ["_parameterCorrect","_unitsPlaced","_unitsHaveAI"];
_parameterCorrect = params [ ["_curator",objNull,[objNull]],["_groupPlaced",grpNull,[grpNull]] ];

if(_parameterCorrect && isServer) then {
	_unitsPlaced = (units _groupPlaced);
	// check if unit has AI and change ownership
	_unitsHaveAI = false;
	{
		if (_x isKindOf "Man") exitWith {_unitsHaveAI = true};
	} forEach _unitsPlaced;
	if (_unitsHaveAI) then {
		private _id = [] call Spec_fnc_getNextOwnerID;
		_groupPlaced setGroupOwner _id;
	};
	// make group editable for allCurators
	{
		_x addCuratorEditableObjects [_unitsPlaced,true];
	} forEach (allCurators - [_curator]);
};
true
