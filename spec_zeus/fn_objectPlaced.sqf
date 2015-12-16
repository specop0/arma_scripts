/*
	Author: FETT, SpecOp0

	Description:
	Changes to owner of a (placed) unit and adds it to all Curators.
	
	If a group is placed this function will be called for every object
	except the crew members.

	Parameter(s):
	0: OBJECT - curator which placed the unit
	1: OBJECT - object which was placed

	Returns:
	true
*/

private _parameterCorrect = params [ ["_curator",objNull,[objNull]],["_objectPlaced",objNull,[objNull]] ];

if(_parameterCorrect && isServer) then {
	// make unit editable for allCurators
	{
		_x addCuratorEditableObjects [ ([_objectPlaced] + crew _objectPlaced),true];
	} forEach (allCurators - [_curator]);
	// check if unit has AI and change ownership
	private _objectGroup = group _objectPlaced;
	if (!isNull _objectGroup) then {
		// test if unit is spawned with curator object or group module
		if(count (units _objectGroup) == count (crew _objectPlaced)) then {
			private _id = [] call Spec_fnc_getNextOwnerID;
			_objectGroup setGroupOwner _id;
		};
	};
};
true
