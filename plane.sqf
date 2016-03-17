/*
	Author: SpecOp0

	Description:
	Spawn pilots into a plane which then takes off and follows assigned waypoints (with flyInHeight).
	For use in a addAction entry, most parameter are hardcoded.

	Parameter(s):
	0: OBJECT - plane who will be flown by the AI

	Returns:
	true
*/


comment "Edit these Entries";
private _parameterCorrect = params [["_airplane",objNull,[objNull]]];

comment "Name of Marker for Waypoints";
private _markerNameWaypoints = ["wp1","wp2"];

private _pilotType = "B_Pilot_F";

comment "Some other Parameters";
private _radiusOfUnitsToLoad = 50;
private _sleepTime = 10;
private _flightHeight = 500;

comment "Script start";
if(_parameterCorrect) then {

	private _waypointsParseError = false;
	private _waypointsPositions = [];
	{
		private _pos = getMarkerPos _x;
		_waypointsPositions pushBack _pos;
		if(_pos select 0 == 0 && _pos select 1 == 0) then {
			_waypointsParseError = true;
			hint format ["marker %1 missing or at (0,0)", _x];
		};
	} foreach _markerNameWaypoints;
	
	if(!_waypointsParseError) then {
		private _bluforOutside = 0;
		private _unitsOutside = [];
		waitUntil {
			sleep _sleepTime;
			_bluforOutside = 0;
			_unitsOutside = nearestObjects [_airplane,["CAManBase"],_radiusOfUnitsToLoad];
			{ 
				if (!isNull _x && {alive _x}) then {
					_bluforOutside = _bluforOutside + 1;
				};
			} foreach _unitsOutside;
			_bluforOutside <= 0
		};
		private _groupAirplane = createGroup WEST;
		private _pilot = _groupAirplane createUnit [_pilotType, [0,0,0], [], 0, "NONE"];
		_pilot moveInCargo _airplane;
		_pilot = _groupAirplane createUnit [_pilotType, [0,0,0], [], 0, "NONE"];
		_pilot moveInTurret [_airplane, [0]];
		private _wp = _groupAirplane addWaypoint [getPos _airplane, count (waypoints _groupAirplane)];
		_wp setWaypointType "GETIN NEAREST";
		private _flyInHeightStr = format ["%1 flyInHeight %2;", _airplane, _flightHeight];
		private _i = 0;
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
true
	
