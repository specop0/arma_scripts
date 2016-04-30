/*
    Author: SpecOp0

    Description:
    AI Helicopter Taxi Script.
    Flies defined helicopter (at defined base landing pad) to marker called Spec_marker_LZ (see moveMarkerLZ.sqf and const.hpp),
    lifts off if no man is nearby and flies to base.
    
    For use in a addAction entry, most parameter are hardcoded in const.hpp.

    Parameter(s):
    0: -
    1: OBJECT - player who wants to call the helicopter (i.e. a player who chooses the menu entry)

    Returns:
    true
*/
#include "const.hpp"

comment "Edit these Entries";

comment "Name of Helicopter and 'Base'/Invisible Helipad";
private _helicopter = HELI_TAXI_ID;
private _helipadBase = HELI_TAXI_HELIPAD_BASE_ID;

comment "Script start";
if(isNil "_helicopter" || isNil "_helipadBase") exitWith { hint "Script Error: Helicopter and/or Helipad not found"; };
params ["",["_caller",objNull,[objNull]]];
private _helipadBasePos = position _helipadBase;
private _helipadMarkerPos = getMarkerPos MARKER_A_ID;

scopeName "heliscript";
if(isNull _caller) then {
    "Script Error: Unit which called for Helicopter is null/has no Position attached" remoteExec ["hint"];
} else {
    if( isNull _helicopter || (_helipadBasePos select 0 == 0 && _helipadBasePos select 1 == 0 && _helipadBasePos select 2 == 0) ) then {
        format ["Script Error: Helicopter '%1' and/or Helipad '%2' not found", str _helicopter, str _markerNameBase] remoteExec ["hint",_caller];
    } else {
        private _crewGroup = group driver _helicopter;
        _crewGroup setGroupOwner 2;
        
        if(isNull _crewGroup) then {
            format ["Script Error: Crew of Helicopter '%1' not found", str _helicopter] remoteExec ["hint",_caller];
        } else {    
            if(_helipadMarkerPos select 0 == 0 && _helipadMarkerPos select 1 == 0) then {
                HINT_HELI_TAX_LZ_MARKER_NOT_FOUND remoteExec ["hint",_caller];
            } else {
                private _helipad = _helicopter getVariable [HELIPAD_GET_VARIABLE,objNull];
                if(isNull _helipad) then{
                    _helipad = "Land_HelipadEmpty_F" createVehicle _helipadMarkerPos;
                    _helicopter setVariable [HELIPAD_GET_VARIABLE,_helipad, true];
                } else {
                    _helipad setPosATL [_helipadMarkerPos select 0,_helipadMarkerPos select 1,0];
                };
                private _helipadPos = getPos _helipad;

                private _wp0 = _crewGroup addWaypoint [_helipadPos,0];
                _wp0 setWaypointType "MOVE"; 
                _wp0 setWaypointBehaviour "CARELESS";
                // force this waypoint to be active (delete scripts of current waypoint)
                private _oldWP = (waypoints _crewGroup) select (currentWaypoint _crewGroup);
                _oldWP setWaypointStatements ["true",""];
                _crewGroup setCurrentWaypoint _wp0;
                private _wp1 = _crewGroup addWaypoint [_helipadPos,0];
                _wp1 setWaypointType "MOVE"; 
                _wp1 setWaypointStatements ["true","vehicle this land 'GET IN';"];
                HINT_HELI_TAXI_ON_MOVE remoteExec ["hint",_caller];    

                private _waypointsOfThisScript = [_wp0 select 1, _wp1 select 1];                
                
                // check if helicopter is near LZ
                private _heliPos = [0,0,0];
                waitUntil {
                    sleep 10;
                    // abort script if new waypoints are added (newer call of this script)
                    if !(currentWaypoint _crewGroup in _waypointsOfThisScript || currentWaypoint _crewGroup == count waypoints _crewGroup) then {
                        "Script Aborted: Helicopter was flying to the LZ." remoteExec ["hint",_caller];
                        true breakOut "heliscript"
                    };
                    _heliPos = getPosATL _helicopter;
                    [_heliPos select 0,_heliPos select 1] distance [_helipadPos select 0,_helipadPos select 1] <= HELI_TAXI_DISTANCE_TO_LZ
                };
                HINT_HELI_TAXI_NEAR_LZ remoteExec ["hint",_caller];
                
                // check if helicopter has landed
                waitUntil {
                    sleep 10;
                    // abort script if new waypoints are added (newer call of this script)
                    if !(currentWaypoint _crewGroup in _waypointsOfThisScript || currentWaypoint _crewGroup == count waypoints _crewGroup) then {
                        "Script Aborted: Helicopter was near the LZ and tried to land." remoteExec ["hint",_caller];
                        true breakOut "heliscript"
                    };
                    (getPosATL _helicopter) select 2 <= HELI_TAXI_HEIGHT_ABOVE_LZ
                };
                HINT_HELI_TAXI_LANDED remoteExec ["hint",_caller];
                
                // check for Man nearby and take off if no one found
                private _bluforOutside = 0;
                private _unitsOutside = [];
                waitUntil {
                    sleep 10;
                    // abort script if new waypoints are added (newer call of this script)
                    if !(currentWaypoint _crewGroup in _waypointsOfThisScript || currentWaypoint _crewGroup == count waypoints _crewGroup) then {
                        "Script Aborted: Helicopter was waiting for everyone at the LZ to board the Helicopter." remoteExec ["hint",_caller];
                        true breakOut "heliscript"
                    };
                    _bluforOutside = 0;
                    _unitsOutside = nearestObjects [_helicopter,["CAManBase"],HELI_TAXI_RADIUS_OF_UNITS_TO_LOAD];
                    { 
                        if (!isNull _x && {alive _x}) then {
                            _bluforOutside = _bluforOutside + 1;
                        };
                    } foreach _unitsOutside;
                    format [HINT_HELI_TAXI_NUMBER_OF_MAN_OUTSIDE, _bluforOutside] remoteExec ["hint",_caller];
                    _bluforOutside <= 0
                };
                // abort script if new waypoints are added (newer call of this script)
                if !(currentWaypoint _crewGroup in _waypointsOfThisScript || currentWaypoint _crewGroup == count waypoints _crewGroup) then {
                    "Script Aborted: Helicopter was waiting for everyone at the LZ to board the Helicopter." remoteExec ["hint",_caller];
                    true breakOut "heliscript"
                };
                HINT_HELI_TAXI_LIFTOFF remoteExec ["hint",_caller];
                // fly to base and turn off engine
                private _wp2 = _crewGroup addWaypoint [_helipadBasePos,0];
                _wp2 setWaypointType "MOVE"; 
                _wp2 setWaypointStatements ["true","vehicle this land 'LAND';"];
            };
        }; 
    };
};
true
