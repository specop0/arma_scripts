comment "Edit these Entries";
local _parameterCorrect = params [["_airplane",objNull,[objNull]]];

comment "Name of Marker for Waypoints";
local _markerNameWaypoints = ["wp1","wp2"];

local _pilotType = "B_Pilot_F";

comment "Some other Parameters";
local _radiusOfUnitsToLoad = 50;
local _sleepTime = 10;
local _flightHeight = 500;

comment "Script start";
if(_parameterCorrect) then {

	local _waypointsParseError = false;
	local _waypointsPositions = [];
	{
		local _pos = getMarkerPos _x;
		_waypointsPositions pushBack _pos;
		if(_pos select 0 == 0 && _pos select 1 == 0) then {
			_waypointsParseError = true;
			hint format ["marker %1 missing or at (0,0,z)", _x];
		};
	} foreach _markerNameWaypoints;

	if(!_waypointsParseError) then {
		local _bluforOutside = 0;
		local _unitsOutside = [];
		waitUntil {
			sleep _sleepTime;
			_bluforOutside = 0;
			_unitsOutside = nearestObjects [_airplane,["CAManBase"],_radiusOfUnitsToLoad];
			{ 
				if (damage _x <= 0.5) then {
					_bluforOutside = _bluforOutside + 1;
				};
			} foreach _unitsOutside;
			_bluforOutside <= 0
		};
		local _groupAirplane = createGroup WEST;
		local _pilot = _groupAirplane createUnit [_pilotType, [0,0,0], [], 0, "NONE"];
		_pilot moveInCargo _airplane;
		_pilot = _groupAirplane createUnit [_pilotType, [0,0,0], [], 0, "NONE"];
		_pilot moveInTurret [_airplane, [0]];
		local _wp = _groupAirplane addWaypoint [getPos _airplane, count (waypoints _groupAirplane)];
		_wp setWaypointType "GETIN NEAREST";
		local _flyInHeightStr = format ["%1 flyInHeight %2;", _airplane, _flightHeight];
		local _i = 0;
		{
			_i = count (waypoints _groupAirplane);
			_wp = _groupAirplane addWaypoint [_x, _i];
			_wp setWaypointBehaviour "CARELESS";
			_wp setWaypointStatements ["true", _flyInHeightStr];
		} foreach _waypointsPositions
	};
} else {
	hint "Script Error: Wrong Input parameter, expected airplane";
};
	