local _cachedGroupArray = [];
if(isServer) then {
	local _parameterCorrect = params [["_unitToCache",objNull]];
	if(_parameterCorrect) then {
		if(_unitToCache isKindof "Man") then {
					// save leader position, etc
					local _group = group _unitToCache;
					local _leader = leader _group;
					local _side = side _leader;
					local _direction = getDir _leader;
					local _positionLeader = getPosATL _leader;
					// save type of units
					local _unitTypeArray = [typeOf _leader];
					{
						_unitTypeArray pushBack (typeOf _x);
					} foreach units _group - [_leader];

					// save waypoints
					local _waypointsArray = [];
					local _i = 0;
					local _noWaypoints = count (waypoints _group);
					private ["_waypointPosition","_waypointBehaviour","_waypointCombatMode","_waypointCompletionRadius","_waypointFormation","_waypointSpeed","_waypointTimeout","_waypointType"];
					while { _i < _noWaypoints } do {
						_waypointPosition = waypointPosition [_group,_i];
						_waypointBehaviour = waypointBehaviour [_group,_i];
						_waypointCombatMode = waypointCombatMode [_group,_i];
						_waypointCompletionRadius = waypointCompletionRadius [_group,_i];
						_waypointFormation = waypointFormation [_group,_i];
						_waypointSpeed = waypointSpeed [_group,_i];
						_waypointTimeout = waypointTimeout [_group,_i];
						_waypointType = waypointType [_group,_i];
						// change GETIN to GETIN NEAREST because linked vehicle is not saved
						if (_waypointType == "GETIN") then {
							_waypointType = "GETIN NEAREST";
						};
						_waypointsArray pushBack [_waypointPosition,_i,_waypointBehaviour,_waypointCombatMode,_waypointCompletionRadius,_waypointFormation,_waypointSpeed,_waypointTimeout,_waypointType];
						_i = _i + 1;
					};
					
					// delete group
					{
						deleteVehicle _x;
					} foreach units _group;

					// return value
					_cachedGroupArray = [_side,_positionLeader,_direction,_unitTypeArray,_waypointsArray];
		} else {
			"Wrong parameter: unit does not inherit from Man (for vehicles: spawn empty vehicle and cache crew with getin waypoint)" call BIS_fnc_error;
		};
	} else {
		"Wrong usage: expected unit - called manually from user?" call BIS_fnc_error;
	};
};
_cachedGroupArray
