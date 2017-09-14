/*
    Author: diverse authors

    Description:
    Lets a group of artillery fire at given targets with deviation.
    Artillery and target, number of shells (default 10) und deviation (default 85m) must are hard coded.

    Parameter(s):
    Hard coded.
    
    Returns:
    true

    Usage (Trigger.OnActivation):
    [] call compile preprocessFileLineNumbers "artillery.sqf";
*/

private _scriptHandle = [] spawn {

private _artyAndTarget = [
    [artillery1, target1],
    [artillery2, target2]
];

private _deviation = 85;

for "_i" from 0 to 9 do 
{
    {
        _x params ["_artillery", "_target"];
        if (alive _artillery) then {
            _center = getPosASL _target;
            _posATL = [
                (_center select 0) - _deviation + (2 * random _deviation),
                (_center select 1) - _deviation + (2 * random _deviation),
                0
            ];
            //_artillery doArtilleryFire [_posATL,"8Rnd_82mm_Mo_shells",1];
            [leader group _artillery,[_posATL,"8Rnd_82mm_Mo_shells",1]] remoteExecCall ["doArtilleryFire", groupOwner group _artillery];
        };
    } foreach _artyAndTarget;
    sleep 5;
};

};
