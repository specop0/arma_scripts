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

private ["_parameterCorrect","_localityChanged","_objectHasAI"];
_parameterCorrect = params [ ["_curator",objNull,[objNull]],["_objectPlaced",objNull,[objNull]] ];

if(_parameterCorrect && isServer) then {
	// check if unit has AI and change ownership (TODO check for headless clients)
	_objectHasAI = _objectPlaced isKindOf "Man";
	_localityChanged = false;
	if(_objectHasAI) then {
		if(!isNil "Spec_var_ownerList") then {
			if(count Spec_var_ownerList > 0) then {
				_localityChanged = (group _objectPlaced) setGroupOwner (Spec_var_ownerList select 0);
			};
		};	
	};
	// make unit editable for allCurators
	if(_localityChanged) then {
		{
			_x addCuratorEditableObjects [[_objectPlaced],true];
		} forEach allCurators;
	} else {
		{
			_x addCuratorEditableObjects [[_objectPlaced],true];
		} forEach (allCurators - [_curator]);
	};
};
true
