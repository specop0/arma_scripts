private _message = "Simple Mission Check";

private _baseRadius = 1500;
private _errorPlaceholder = "<t color='#FF0000'>%1</t>";
private _successPlaceHolder = "<t color='#4CDD00'>%1</t>";

private _playableUnits = if (isMultiplayer) then { playableUnits } else { switchableUnits };
comment "============ RESPAWN (MARKER AND TYPE) ============";
private _sides = [];
private _groups = [];
{
    if !(typeof _x in ["HeadlessClient_F"]) then {
        if !(side _x in _sides) then {
            _sides pushBack side _x;
        };
        if !(group _x in _groups) then {
            _groups pushBack group _x;
        };
    };
} forEach _playableUnits;

if (getMarkerPos "respawn" isEqualTo [0,0,0]) then {
    private _sideAndMarker = [
        [BLUFOR, "respawn_west"],
        [OPFOR, "respawn_east"],
        [INDEPENDENT, "respawn_guerrila"],
        [CIVILIAN, "respawn_civilian"]
    ];
    private _missingRespawnMarker = [];
    {
        _x params ["_side", "_markerName"];
        if (_side in _sides) then {
            if (getMarkerPos _markerName isEqualTo [0,0,0]) then {
                _missingRespawnMarker pushBack _side;
            };
        };
    } forEach _sideAndMarker;
    if (count _missingRespawnMarker == 0) then {
        _message = format ["%1<br/>Respawn:<br/>%2 for all playable sides (", _message, format [_successPlaceHolder, "Found Markers"]];
        {
            private _placeholder = if (_forEachIndex == 0) then { "%1(%2" } else { "%1, %2" };
            _message = format [_placeholder, _message, str _x];
        } forEach _sides;
        _message = format ["%1)", _message];
    } else {
        _message = format ["%1<br/>Respawn:<br/>%2 Could not find the markers for the following playable sides: ", _message, format [_errorPlaceholder, "ERROR!"]];
        {
            private _placeholder = if (_forEachIndex == 0) then { "%1%2" } else {"%1, %2" };
            _message = format [_placeholder, _message, str _x];
        } forEach _missingRespawnMarker;
    };
} else {
    _message = format ["%1<br/>Respawn:<br/>%2 for all sides.", _message, format [_successPlaceHolder, "Found global Marker"]];
};
private _respawnType = getMissionConfigValue ["respawn",0];
private _respawnTypeCorrect = if (_respawnType isEqualType 0) then { _respawnType == 3 } else { _respawnType isEqualTo "BASE" };
if (_respawnTypeCorrect) then {
    _message = format ["%1<br/>%2 is set correctly", _message, format [_successPlaceHolder, "Type of respawn"]];
} else {
    _message = format ["%1<br/>%2 Type of respawn is NOT set to Custom Position / BASE / 3 / position of respawn marker", _message, format [_errorPlaceholder, "ERROR!"]];
};

comment "============ VEHICLES near PLAYER ============";
private _availableVehicles = [];
private _allVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], _baseRadius];
private _seatsAvailable = 0;
private _ignoredWeapons = ["FirstAidKit"];
private _ignoredMagazines = [
    "SmokeShell", "SmokeShellRed", "SmokeShellGreen", "SmokeShellYellow","SmokeShellPurple", "SmokeShellBlue", "SmokeShellOrange",
    "UK3CB_BAF_32Rnd_40mm_G_Box","UK3CB_BAF_762_200Rnd_T", "ToolKit"
];
private _ignoredBackpacks = ["B_Parachute"];

private _vehiclesWithWeapons = [];
private _vehiclesWithMagazines = [];
private _vehiclesWithBackpacks = [];
{
    if (!isNull _x && simulationEnabled _x && locked _x in [0, 1] && !isObjectHidden _x) then {
        _availableVehicles pushBack _x;
        
        getWeaponCargo _x params [ ["_types",[]], ["_amounts", []] ];
        if ({ !(_x in _ignoredWeapons) } count _types > 0) then {
            _vehiclesWithWeapons pushBack _x;
        };
        
        getMagazineCargo _x params [ ["_types",[]], ["_amounts", []] ];
        if ({ !(_x in _ignoredMagazines) } count _types > 0) then {
            _vehiclesWithMagazines pushBack _x;
        };
        
        getBackpackCargo _x params [ ["_types",[]], ["_amounts", []] ];
        if ({ !(_x in _ignoredBackpacks) } count _types > 0) then {
            _vehiclesWithBackpacks pushBack _x;
        };
        
        _seatsAvailable = _seatsAvailable + count fullCrew [_x, "", true];
    };
} forEach _allVehicles;
_message = format ["%1<br/>Vehicles in base (%2/%3):", _message, count _availableVehicles, count _allVehicles];

if (count _vehiclesWithWeapons > 0) then {
    private _types = [];
    {
        if !(typeOf _x in _types) then {
            _types pushBack typeOf _x;
        };
    } forEach _vehiclesWithWeapons;
    _message = format ["%1<br/>%2 are present in: ", _message, format [_errorPlaceholder, "WEAPONS"]];
    {
        private _placeholder = if (_forEachIndex == 0) then { "%1%2" } else {"%1, %2" };
        _message = format [_placeholder, _message, _x];
    } forEach _types;
} else {
    _message = format ["%1<br/>No relevant %2 found in inventory", _message, format [_successPlaceHolder, "weapons"]];
};

if (count _vehiclesWithMagazines > 0) then {
    private _types = [];
    {
        if !(typeOf _x in _types) then {
            _types pushBack typeOf _x;
        };
    } forEach _vehiclesWithMagazines;
    _message = format ["%1<br/>%2 are present in: ", _message, format [_errorPlaceholder, "MAGAZINES"]];
    {
        private _placeholder = if (_forEachIndex == 0) then { "%1%2" } else {"%1, %2" };
        _message = format [_placeholder, _message, _x];
    } forEach _types;
} else {
    _message = format ["%1<br/>No relevant %2 found in inventory", _message, format [_successPlaceHolder, "magazines"]];
};

if (count _vehiclesWithBackpacks > 0) then {
    private _types = [];
    {
        if !(typeOf _x in _types) then {
            _types pushBack typeOf _x;
        };
    } forEach _vehiclesWithBackpacks;
    _message = format ["%1<br/>%2 are present in: ", _message, format [_errorPlaceholder, "BACKPACKS"]];
    {
        private _placeholder = if (_forEachIndex == 0) then { "%1%2" } else {"%1, %2" };
        _message = format [_placeholder, _message, _x];
    } forEach _types;
} else {
    _message = format ["%1<br/>No relevant %2 found in inventory", _message, format [_successPlaceHolder, "backpacks"]];
};

if (count _availableVehicles == 0) then {
    _message = format ["%1<br/>%2 for any player", _message, format [_errorPlaceholder, "No vehicle available"]];
} else {
    private _seatsPerPlayer = _seatsAvailable / count _playableUnits;
    if(_seatsPerPlayer < 1.5) then {
        _message = format ["%1<br/>%2 in vehicles available (%3 seats for %4 player)", _message, format [_errorPlaceholder, "Few seats"], _seatsAvailable, count _playableUnits];
    } else {
        _message = format ["%1<br/>%2 in vehicles available (%3 seats for %4 player)", _message, format [_successPlaceHolder, "Enough seats"], _seatsAvailable, count _playableUnits];
    };
};

comment "============ CALL SIGNS ============";
private _incorrectGroupNames = [];
private _generatedGroupPrefix = ["Alpha", "Bravo", "Charlie", "Delta"];
{
    private _groupName = groupId _x;
    private _hasGeneratedPrefix = { _groupName find _x isEqualTo 0 } count _generatedGroupPrefix > 0;
    if (_hasGeneratedPrefix) then {
        private _length = count _groupName;
        if (!(parseNumber (_groupName select [_length - 1, 1]) isEqualTo 0) && !(parseNumber (_groupName select [_length - 3, 1]) isEqualTo 0)) then {
            _incorrectGroupNames pushBack _groupName;
        };
    };
} forEach _groups;
if (count _incorrectGroupNames > 0) then {
    _message = format ["%1<br/>%2: There are generated group names: ", _message, format [_errorPlaceholder, "Callsigns"]];
    {
        private _placeholder = if (_forEachIndex == 0) then { "%1%2" } else {"%1, %2" };
        _message = format [_placeholder, _message, _x];
    } forEach _incorrectGroupNames;
} else {
    _message = format ["%1<br/>%2: Every playable group has a correct group names.", _message, format [_successPlaceHolder, "Callsigns"]];
};

comment "============= WIND ==============";
private _isWindForced = "Intel" get3DENMissionAttribute "IntelWindIsForced";
_message = format [
    "%1<br/>%2: Wind is %3 forced.",
    _message,
    format [ if (_isWindForced) then { _successPlaceHolder } else { _errorPlaceholder }, "Wind"],
    if (_isWindForced) then { "" } else { format [_errorPlaceholder, "not"] }
];


comment "============ LOADOUT ============";


hint parseText _message;