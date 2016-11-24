/*
    Author: SpecOp0
    
    Description:
    AddsActions (vanilla) to the object which can assign and deassign a vehicle to provide a full heal.
    
    To find a vehicle the nearest vehicle is used.
    If no vehicle found or the nearest one is locked an error message is shown.
    
    Parameter(s):
    0: OBJECT - object which can assign a vehicle to provide a full heal
    1: STRING - marker name to search for a vehicle
    2: NUMBER - priority in AddAction
    3: NUMBER - radius to show AddAction
    
    Returns:
    true
*/
#define COLOR_GREEN "579D1C"
#define COLOR_RED "EE0000"
#define FULL_HEAL_BOOL_STRING "isFullHealVehicle"

params [ ["_object",objNull,[objNull]], ["_markerName","",[""]], ["_priority",1,[0]], ["_radius",5,[0]] ];

if(hasInterface) then {
    {
       _x params ["_actionName", "_assignAsFullHealVehicle"];
        _object addAction [_actionName, {
            params ["_target", "_caller", "_id", "_argv"];
            _argv params ["_markerName", "_assignAsFullHealVehicle"];
            
            private _nearestVehicle = nearestObject [getMarkerPos _markerName, "AllVehicles"];
            if(!isNull _nearestVehicle && {locked _nearestVehicle in [0,1]}) then {
                _nearestVehicle setVariable [FULL_HEAL_BOOL_STRING, _assignAsFullHealVehicle, true];
                private _xCoord = round((getPosASL _nearestVehicle select 0)/10.0);
                private _yCoord = round((getPosASL _nearestVehicle select 1)/10.0);
                private _color = if(_assignAsFullHealVehicle) then { COLOR_GREEN } else { COLOR_RED };
                private _textPrefix = if(_assignAsFullHealVehicle) then { "" } else { "k" };
                hint parseText format ["Das Fahrzeug vom Typ<br />'%1'<br />auf den Koordinaten %2-%3<br />ist nun <t color='#%4'>%5eine</t> PAK-Station", 
                    typeOf _nearestVehicle, _xCoord, _yCoord, _color, _textPrefix];
            } else {
                hint "Fehler: Konnte kein gültiges Ziel finden.";
            };
        }, [_markerName, _assignAsFullHealVehicle], _priority, false, true, "", "", _radius];
    } foreach [
        [format ["Nähstes Fahrzeug -> <t color='#%1'>PAK-Station</t>", COLOR_GREEN], true],
        [format ["Nähstes Fahrzeug -> <t color='#EE0000'>keine PAK-Station</t>", COLOR_RED], false]
    ];
};
true
