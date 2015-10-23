comment "Edit these Entries";

comment "Type of spawned Helicoptor (this Unit has to include AI)";
local _heliType = "B_Heli_Transport_03_F";

comment "Parameter for spawned Helicoptor (Direction in degree and Side).";
comment "If Side is empty (no Unit on Map and/or no 'createCenter' used) no Helicopter will spawn!";
local _heliSpawnerDirection = 180;
local _heliSpawnerSide = WEST;

comment "Name of Marker for Helicopter Spawn and 'Base'/liftoff Target";
local _markerNameHeliSpawn = "heli_spawn";
local _markerNameBase = "ende";

comment "Hints displayed for Caller";
local _hintHeliOnMove = "Hier Bussard\nSind auf dem Weg zu ihrer Positionen.\nBussard Ende.";
local _hintHeliNearLZ = "Hier Bussard\nNähern uns der LZ. Werfen Sie bitte violetten Rauch.\nBussard Ende.";
local _hintHeliLanded = "Touchdown!";
local _hintHeliLiftoff = "Liftoff!";
local _hintSpawnPosBlocked = "Hier Bussard\nLuftraum ist besetzt und können nicht starten. Rufen Sie uns in ein paar Minuten erneut\nBussard Ende.";

comment "Some other Parameters";
local _distanceToLZ = 700;
local _heightAboveLZ = 3;
local _radiusOfUnitsToLoad = 50;

comment "Script start";
params ["",["_caller",objNull,[objNull]]];
local _heliSpawn = getMarkerPos _markerNameHeliSpawn;
local _lzEnd = getMarkerPos _markerNameBase;

if(isNull _caller) then {
	hint "Script Error: Unit which called for Helicoptor is null/has no Position attached";
} else {
	if( (_lzEnd select 0 == 0 && _lzEnd select 1 == 0 && _lzEnd select 2 == 0) || 
		(_heliSpawn select 0 == 0 && _heliSpawn select 1 == 0 && _heliSpawn select 2 == 0)) then {
		hint format ["Script Error: Marker '%1' and/or '%2' not found",_markerNameHeliSpawn,_markerNameBase];
	} else {	
		local _nearestHelis = nearestObjects [_heliSpawn,[_heliType],200];
		local _nearestHelisAlive = 0;
		{
			if (damage _x <= 0.5) then {
				_nearestHelisAlive = _nearestHelisAlive + 1;
			};
		} foreach _nearestHelis;

		if(_nearestHelisAlive > 0) then {
			hint _hintSpawnPosBlocked;
		} else {
			local _spawnedHeliReturnValue = [_heliSpawn,_heliSpawnerDirection,_heliType, _heliSpawnerSide] call BIS_fnc_spawnVehicle;
			comment "_spawnedHeli = nearestObject [_heliSpawn, _heliType];";
			local _spawnedHeli = _spawnedHeliReturnValue select 0;
			local _crewArray = _spawnedHeliReturnValue select 1;
			local _crewGroup = _spawnedHeliReturnValue select 2;
			
			local _landingPad = "Land_HelipadEmpty_F" createVehicle position _caller;

			local _wp0 = group _spawnedHeli addWaypoint [_landingPad,0];
			_wp0 setWaypointType "MOVE"; 
			_wp0 setWaypointBehaviour "CARELESS";
			local _wp1 = group _spawnedHeli addWaypoint [_landingPad,1];
			_wp1 setWaypointType "TR UNLOAD"; 
		
			hint _hintHeliOnMove;
			local _landingPos = getPos _landingPad;
			local _heliPos = [0,0,0];
			waitUntil {
				sleep 10;
				_heliPos = getPosATL _spawnedHeli;
				[_heliPos select 0,_heliPos select 1] distance [_landingPos select 0,_landingPos select 1] <= _distanceToLZ
			};
			hint _hintHeliNearLZ;
			waitUntil {
				sleep 10;
				(getPosATL _spawnedHeli) select 2 <= _heightAboveLZ
			};
			hint _hintHeliLanded;
			local _bluforOutside = 0;
			local _unitsOutside = [];
			waitUntil {
				sleep 10;
				_bluforOutside = 0;
				_unitsOutside = nearestObjects [_spawnedHeli,["CAManBase"],_radiusOfUnitsToLoad];
				{ 
					if (getDammage _x <= 0.5) then {
						_bluforOutside = _bluforOutside + 1;
					};
				} foreach _unitsOutside;
				_bluforOutside <= 0
			};
			hint _hintHeliLiftoff;
			local _wp2 = group _spawnedHeli addWaypoint [_lzEnd,1];
			_wp2 setWaypointType "MOVE";    
		};
	};
};
