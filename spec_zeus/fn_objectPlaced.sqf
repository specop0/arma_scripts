/*
	Author: FETT, SpecOp0

	Description:
	Changes to owner of a (placed) unit and adds it to all Curators.

	Parameter(s):
	0: OBJECT - curator which placed the unit
	1: OBJECT - object which was placed

	Returns:
	true
*/

private ["_parameterCorrect","_objectHasAI"];
_parameterCorrect = params [ ["_curator",objNull,[objNull]],["_objectPlaced",objNull,[objNull]] ];

if(_parameterCorrect && isServer) then {
	// check if unit has AI and change ownership
	_objectHasAI = _objectPlaced isKindOf "Man";
	if(!_objectHasAI) then {
		{
			if(_x isKindOf "Man") exitWith { _objectHasAI = true; }
		} forEach (crew _objectPlaced);
	};
	if (_objectHasAI) then {
		private _id = [] call Spec_fnc_getNextOwnerID;
		(group _objectPlaced) setGroupOwner _id;
	};
	// make unit editable for allCurators
	{
		_x addCuratorEditableObjects [[_objectPlaced],true];
	} forEach (allCurators - [_curator]);
};
true
