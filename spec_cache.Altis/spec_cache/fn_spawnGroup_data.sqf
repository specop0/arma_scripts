local _returnValue = false;
if(isServer) then {
	local _parameterCorrect = params [["_side",objNull,[WEST]], ["_position",objNull,[[0]],3], ["_direction",0,[0]], ["_unitTypeArray",objNull], ["_waypointsArray",objNull]];
	if (_parameterCorrect) then {
		if (count _unitTypeArray > 0) then {
			// spawn units
			local _group = createGroup _side;
			private "_spawnedUnit";
			{
				_spawnedUnit = _group createUnit [_x, _position, [], 0, "FORM"];
				_spawnedUnit setDir _direction;
			} foreach _unitTypeArray;
			// assign group waypoints
			private "_waypoint";
			{
				_waypoint = _group addWaypoint [(_x select 0), (_x select 1)];
				_waypoint setWaypointBehaviour (_x select 2);
				_waypoint setWaypointCombatMode (_x select 3);
				_waypoint setWaypointCompletionRadius (_x select 4);
				_waypoint setWaypointFormation (_x select 5);
				_waypoint setWaypointSpeed (_x select 6);
				_waypoint setWaypointTimeout (_x select 7);
				_waypoint setWaypointType (_x select 8);
			} foreach _waypointsArray;

			_returnValue = true;
		} else {
			["Wrong Usage: _unitTypeArray is empty - called manually from user? or error while saving"] call BIS_fnc_error;
		};
	};
};
_returnValue
