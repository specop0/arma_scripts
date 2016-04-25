/*
    Author: SpecOp0

    Description:
    Cleanup Script.
    Deletes Land units (and ACE_Wheels) around a marker with a given radius.
    Furthermore checks if no allied unit (same side) of the caller is present.
    For use in a addAction entry.
    Some hints are hardcoded.

    Parameter(s):
    0: -
    1: -
    2: -
    3: Array - arguments defined in the addAction entry
        0: OBJECT - unit which activates the entry (or has the same side)
        1: STRING - name of marker to clean around
        2: NUMBER - radius to clean (center marker position)

    Returns:
    true
*/

private _parameterCorrect = (_this select 3) params [ ["_caller",objNull,[objNull]],["_markerName","",["STRING"]],["_radius",0,[0]] ];

private _hintPlayerInAreaAlive = "Im Gebiet sind noch befreundete Streitkräfte am Leben. Cleanup nicht möglich.";
private _hintCleanUpStarted = "Es wird angefangen alle Einheiten im Gebiet zu löschen. Dies kann einen Moment dauern.";
private _hintCleanUpSucessfull = "Es wurden alle Einheiten im Gebiet gelöscht.";

private _cleanUpSleepTime = 0.1;
if(_parameterCorrect) then {
    private _sidePlayer = side _caller;
    private _position = getMarkerPos _markerName;
    if(_position select 0 != 0 && _position select 1 != 0) then {
        private _objects = _position nearObjects ["Land",_radius];
        // ammo crates, air vehicle still present
        private _numberBluforAlive = 0;
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
true
