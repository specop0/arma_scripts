/*
	Author: SpecOp0

	Description:
	Assigns a Player to all Curators (Respawn/JIP).
	If the Player is a Curator all objects will be added to his module.

	Parameter(s):
	0: OBJECT - player (or unit) which should be added to the Curators

	Returns:
	true
*/

if(!isServer) then {
	// call this function on server
	_this remoteExecCall ["Spec_fnc_assignToAllCurators", 2, false];
} else {
	private ["_parameterCorrect"];
	_parameterCorrect = params [ ["_player",objNull,[objNull]] ];
	if(_parameterCorrect) then {
		// add respawned (or JIP) player to allCurators
		{
			_x addCuratorEditableObjects [[_player],true];
		} forEach allCurators;
		// if player is Curator add allUnits
		if(!isNull (getAssignedCuratorLogic _player) ) then {
			(getAssignedCuratorLogic _player) addCuratorEditableObjects [allUnits, false];
		};
	} else {
		"Wrong Parameter: Expected (player) object" call BIS_fnc_error;
	};
};
true
