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
	private _scriptHandle = _this spawn {
		sleep 20; // 1 works as well ; otherwise not fully initalized
		private _parameterCorrect = params [ ["_player",objNull,[objNull]] ];
		if(_parameterCorrect) then {
			// add respawned (or JIP) player to allCurators
			{
				_x addCuratorEditableObjects [[_player],true];
			} forEach allCurators;
			// if player is Curator add allUnits
			if(!isNull (getAssignedCuratorLogic _player) ) then {
				[_player, ["Assign Units", {(getAssignedCuratorLogic (_this select 1)) addCuratorEditableObjects [allUnits, false];}, nil, -2, false, true, "", "true"] ] remoteExec ["addAction", _player] ;
				(getAssignedCuratorLogic _player) addCuratorEditableObjects [allUnits, false];
			};
		} else {
			"Wrong Parameter: Expected (player) object" call BIS_fnc_error;
		};
	};
};
true
