/*
    Author: POTS, Speutzi, SpecOp0

    Description:
    Suicide Script.
    If conditions are met unit, vehicle or other attached object
    will trigger a explosion (with 3 possible sizes).

    Parameter(s):
    0: OBJECT - object to trigger explosion from (e.g. vehicle or unit)
    1: NUMBER - likelihood to trigger explosion in percent (0..100)
    2: STRING - suicide yell/last words of unit/vehicle before explosion (using a hint)
    3: NUMBER - delay after last words in seconds after suicide yell/last
    4: STRING - size of explosion: "SMALL", "MEDIUM" or "LARGE"
    5 (Optional): BOOL - if true will wait for enemy side to be nearby before explosion
    6 (Optional): NUMBER - distance/radius to look for enemies (if 5 is true)
    7 (Optional): SIDE - side of enemy (if 5 is true); default value is "WEST"

    Returns:
    true
*/

private _scriptHandle = _this spawn {

    private ["_parameterCorrect","_chance","_types","_null","_sleepTime"];
    _parameterCorrect = params [ ["_car",objNull,[objNull]], ["_possibility",50,[0]], ["_shoutout","DIE!",["STRING"]], ["_delay",1,[0]], ["_size","MEDIUM",["STRING"]] ];
    // optional parameter
    params [ "", "", "", "", "", ["_lookForEnemy",false,[true]], ["_distance",30,[0]], ["_enemySide",WEST,[WEST]] ];

    // time to look for enemies (as large as possible to avoid heavy computation)
    _sleepTime = 0.5;
    while {_lookForEnemy} do
    {
        if(alive _car) then    {
            // explodes if vehicle is empty
            if((driver _car isKindOf "Man") && (side driver _car != _enemySide)) then
            {
                _types = _car nearObjects ["Man", _distance];
                {
                    if (side _x == _enemySide) exitWith {_lookForEnemy = false};
                } foreach _types;
            } else {
                if(true) exitWith {_lookForEnemy = false};
            };
        } else {
            _lookForEnemy = false;
            _possibility = 0;
        };
        sleep _sleepTime;
    };


    _chance = floor(random 100) + 1;
    if(_chance <= _possibility) then {
        if(_shoutout != "") then {
            _shoutout remoteExec ["hint", (_car nearObjects ["Man",_distance]) ];
        };
        sleep _delay;
        switch (_size) do {
            case "SMALL": {
                {deleteVehicle _x} foreach (crew _car) - [_car];
                _null = "M_Mo_82mm_AT_LG" createVehicle getPos _car;
                _updatepos = [(getPos _car) select 0, ((getPos _car) select 1) + 1];
                sleep 0.25;
                _null = "M_Mo_82mm_AT_LG" createVehicle _updatepos;        
                _car setDammage 1; 
            };
            case "MEDIUM" : {
                {deleteVehicle _x} foreach (crew _car) - [_car];
                _null = "Sh_122_HE" createVehicle getPos _car;
                _car setDammage 1; 
            };
            case "LARGE" : {
                {deleteVehicle _x} foreach (crew _car) - [_car];
                _null = "Bo_GBU12_LGB" createVehicle getPos _car;
                _car setDammage 1; 
                //deleteVehicle _car;
            };
            default {
                ["Wrong Parameter: Expected size of explosion to be ""SMALL"", ""MEDIUM"" or ""LARGE""."] call BIS_fnc_error;
            };
        };
    };
};
true
