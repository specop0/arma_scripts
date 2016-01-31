/*
	Author: SpecOp0

	Description:
	AI Helicopter Taxi Script.
	Flies defined helicopter (at defined base landing pad) to marker called Spec_marker_LZ (see moveMarkerLZ.sqf),
	lifts off if no man is nearby and flies to base.
	
	For use in a addAction entry, most parameter are hardcoded.

	Parameter(s):
	0: -
	1: OBJECT - player who wants to call the helicopter (i.e. a player who chooses the menu entry)

	Returns:
	true
*/

comment "Edit these Entries";

comment "Name of Marker for Helicopter and 'Base'/Invisible Helipad";
private _helicopter = bussard;
private _landingPadBase = landingpad_bussard;

comment "Hints displayed for Caller";
private _hintHeliOnMove = "Hier Bussard\nSind auf dem Weg zu LZ Alpha.\nBussard Ende.";
private _hintHeliNearLZ = "Hier Bussard\nNähern uns der LZ. Werfen Sie violetten Rauch.\nBussard Ende.";
private _hintHeliNumberOfManOutside = "Noch %1 draußen.";
private _hintHeliLanded = "Touchdown!";
private _hintHeliLiftoff = "Liftoff!";
private _hintHeliMakerLZnotFound = "Hier Bussard\nKoennen Markierung von LZ Alpha nicht finden. Bitte neu markieren.\nBussard Ende.";

comment "Some other Parameters";
private _distanceToLZ = 700; // if this distance is the travel distance the script won't work (helicopter takes off instantly)
private _heightAboveLZ = 3;
private _radiusOfUnitsToLoad = 25;

comment "Script start";
private _markerLZ = "Spec_marker_LZ";
params ["",["_caller",objNull,[objNull]]];
private _landingPadBasePos = position _landingPadBase;
private _landingPadMarkerPos = getMarkerPos _markerLZ;

if(isNull _caller) then {
	"Script Error: Unit which called for Helicopter is null/has no Position attached" remoteExec ["hint"];
} else {
	if( isNull _helicopter || (_landingPadBasePos select 0 == 0 && _landingPadBasePos select 1 == 0 && _landingPadBasePos select 2 == 0) ) then {
		format ["Script Error: Helicopter '%1' and/or Helipad '%2' not found", str _helicopter, str _markerNameBase] remoteExec ["hint",_caller];
	} else {
		private _crewGroup = group _helicopter;
		
		if(isNull _crewGroup) then {
			format ["Script Error: Crew of Helicopter '%1' not found", str _helicopter] remoteExec ["hint",_caller];
		} else {	
			if(_landingPadMarkerPos select 0 == 0 && _landingPadMarkerPos select 1 == 0) then {
				_hintHeliMakerLZnotFound remoteExec ["hint",_caller];
			} else {
				private _landingPad = "Land_HelipadEmpty_F" createVehicle _landingPadMarkerPos;
				private _landingPadPos = getPos _landingPad;

				private _wp0 = _crewGroup addWaypoint [_landingPadPos,0];
				_wp0 setWaypointType "MOVE"; 
				_wp0 setWaypointBehaviour "CARELESS";
				// force this waypoint to be active (delete scripts of current waypoint)
				private _oldWP = (waypoints _crewGroup) select (currentWaypoint _crewGroup);
				_oldWP setWaypointStatements ["true",""];
				_crewGroup setCurrentWaypoint _wp0;
				private _wp1 = _crewGroup addWaypoint [_landingPadPos,0];
				_wp1 setWaypointType "TR UNLOAD"; 
				_hintHeliOnMove remoteExec ["hint",_caller];		
				
				// check if helicopter is near LZ
				private _heliPos = [0,0,0];
				waitUntil {
					sleep 10;
					_heliPos = getPosATL _helicopter;
					[_heliPos select 0,_heliPos select 1] distance [_landingPadPos select 0,_landingPadPos select 1] <= _distanceToLZ
				};
				_hintHeliNearLZ remoteExec ["hint",_caller];
				
				// check if helicopter has landed
				waitUntil {
					sleep 10;
					(getPosATL _helicopter) select 2 <= _heightAboveLZ
				};
				_hintHeliLanded remoteExec ["hint",_caller];
				
				// check for Man nearby and take off if no one found
				private _bluforOutside = 0;
				private _unitsOutside = [];
				waitUntil {
					sleep 10;
					_bluforOutside = 0;
					_unitsOutside = nearestObjects [_helicopter,["CAManBase"],_radiusOfUnitsToLoad];
					{ 
						if (!isNull _x && {alive _x}) then {
							_bluforOutside = _bluforOutside + 1;
						};
					} foreach _unitsOutside;
					format [_hintHeliNumberOfManOutside, _bluforOutside] remoteExec ["hint",_caller];
					_bluforOutside <= 0
				};
				_hintHeliLiftoff remoteExec ["hint",_caller];
				// fly to base turn off engine and fully heal embarked units
				private _wp2 = _crewGroup addWaypoint [_landingPadBasePos,0];
				_wp2 setWaypointType "TR UNLOAD"; 
				_wp2 setWaypointStatements ["true","this action [""engineOff"", vehicle this];"];
			};
		}; 
	};
};
true
