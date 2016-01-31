/*
	Author: SpecOp0

	Description:
	AI Helicopter Taxi Script.
	Flies defined helicopter (at defined base landing pad) to position of caller/player,
	lifts off if no man is nearby and flies to base.
	At Base unloaded passengers get fully healed (PAK from ACE Advanced Medic is used).
	
	For use in a addAction entry, most parameter are hardcoded.
	WIP: addAction to relocate healed personal from base to last called LZ.

	Parameter(s):
	0: -
	1: OBJECT - player who wants to call the helicopter (i.e. a player who chooses the menu entry)

	Returns:
	true
*/

comment "Edit these Entries";

comment "Name of Marker for Helicopter and 'Base'/Invisible Helipad";
private _helicopter = weiss;
private _landingPadBase = landingpad_weiss;

comment "Hints displayed for Caller";
private _hintHeliOnMove = "Hier Weiss\nSind auf dem Weg zu ihrer Position.\nWeiss Ende.";
private _hintHeliNearLZ = "Hier Weiss\nNähern uns der LZ. Werfen Sie violetten Rauch.\nWeiss Ende.";
private _hintHeliNumberOfManOutside = "Noch %1 draußen.";
private _hintHeliLanded = "Touchdown!";
private _hintHeliLiftoff = "Liftoff!";

private _addActionFlyback = "Fliege Sie uns zurueck an die Front.";

comment "Some other Parameters";
private _distanceToLZ = 700; // if this distance is the travel distance the script won't work (helicopter takes off instantly)
private _heightAboveLZ = 3;
private _radiusOfUnitsToLoad = 25;

comment "Script start";
params ["",["_caller",objNull,[objNull]]];
private _landingPadBasePos = position _landingPadBase;

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
			private _landingPad = "Land_HelipadEmpty_F" createVehicle position _caller;
			private _landingPadPos = getPos _landingPad;
			
			_helicopter setVariable ["Spec_var_landingPadPos", _landingPadPos, true];
			_helicopter setVariable ["Spec_var_landingPadBasePos", _landingPadBasePos, true];

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
			_wp2 setWaypointStatements ["true","
				this action [""engineOff"", vehicle this];
				private _scriptHandle = [this] spawn {
					params [""_crewLeader""];
					sleep 1;
					private _bluforOutside = nearestObjects [position _crewLeader,[""CAManBase""],30];
					{
						if(!isNull _x) then {
							[_crewLeader,_x] call ACE_medical_fnc_treatmentAdvanced_fullHeal;
							sleep 0.5;
						};
					} forEach _bluforOutside;
				};
			"];
			_helicopter addAction [_addActionFlyback, {
				params ["_target","_caller"];
				private _landingPadPos = _target getVariable ["Spec_var_landingPadPos", position _target];
				private _landingPadBasePos =  _target getVariable ["Spec_var_landingPadBasePos", position _target];
				private _crewGroup = group _target;
				private _wp0 = _crewGroup addWaypoint [_landingPadPos,0];
				_wp0 setWaypointType "TR UNLOAD";
				private _wp1 = _crewGroup addWaypoint [_landingPadBasePos,0];
				_wp1 setWaypointType "TR UNLOAD";
			}, [], 1.5, false, true, "", "_this in _target"];
			
			// check for bluefor outside and use PAK
			/*private _bluforOutside = nearestObjects [_helicopter,["CAManBase"],30];
			{
				if(!isNull _x) then {
					[leader _crewGroup,_x] call ACE_medical_fnc_treatmentAdvanced_fullHeal;
					sleep 0.5;
				};
			} forEach _bluforOutside;*/
			// 	if !(currentWaypoint _crewGroup in [_wp0 select 1, _wp1 select 1] || 
			// currentWaypoint _crewGroup == count waypoints _crewGroup) exitWith {hint "abort script cause duplication";};
		}; 
	};
};
true
