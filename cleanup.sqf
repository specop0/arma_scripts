local _parameterCorrect = (_this select 3) params [["_caller",objNull],["_markerName",objNull,["STRING"]],["_radius",0,[0]]];

local _hintPlayerInAreaAlive = "Im Gebiet sind noch befreundete Streitkräfte am Leben. Cleanup nicht möglich.";
local _hintCleanUpStarted = "Es wird angefangen alle Einheiten im Gebiet zu löschen. Dies kann einen Moment dauern.";
local _hintCleanUpSucessfull = "Es wurden alle Einheiten im Gebiet gelöscht.";

local _cleanUpSleepTime = 0.1;
if(_parameterCorrect) then {
	local _sidePlayer = side _caller;
	local _position = getMarkerPos _markerName;
	if(_position select 0 != 0 && _position select 1 != 0) then {
		local _objects = _position nearObjects ["Land",_radius];
		// ammo crates, air vehicle still present
		local _numberBluforAlive = 0;
		{
			if( (side _x) == _sidePlayer) then {
				if(alive _x) then {
					_numberBluforAlive = _numberBluforAlive + 1;
				};
			};
		} foreach _objects;
		if(_numberBluforAlive == 0) then {
			hint _hintCleanUpStarted;
			{
				{
					deleteVehicle _x;
				} foreach crew _x;
				deleteVehicle _x;
				sleep _cleanUpSleepTime;
			} foreach _objects;
			hint _hintCleanUpSucessfull;
			// ACE Wheels other type
			{
				deleteVehicle _x;
				sleep _cleanUpSleepTime;
			} foreach (_position nearObjects ["ACE_Wheel",_radius]);
		} else {
			hint _hintPlayerInAreaAlive;
		};
	} else {
		hint format ["Script Error: Marker %1 not found %2", str _markerName];
	};
} else {
	hint "Script Error: wrong parameter expected [player,""nameOfMarker"",radiusToCleanup]";
};