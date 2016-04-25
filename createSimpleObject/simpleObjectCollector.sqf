private _exclude = [
    "Land_CampingChair_V1_F",
    "Land_Cargo_House_V3_F",
    "Land_Cargo_HQ_V3_F",
    "Land_Medevac_HQ_V1_F",
    "Land_Cargo_Patrol_V3_F"
];

private _type = "";
private _deleted = 0;
{
    if !((typeOf _x) in _exclude) then {
        _position = getPosWorld _x;
        _vectorDirUp = [vectorDir _x, vectorUp _x];
        _model = getModelInfo _x select 1;
        deleteVehicle _x;
        _deleted = _deleted + 1;
        deleteVehicle _x;
        _simpleObject = createSimpleObject [_model, _position];
        _simpleObject setVectorDirAndUp _vectorDirUp;
    };
} forEach (allMissionObjects "Static");
{
    _type = typeOf _x;
    if(_type isKindOf ["Thing", configFile >> "CfgVehicles"] && !(_type in _exclude)) then {
        _position = getPosWorld _x;
        _vectorDirUp = [vectorDir _x, vectorUp _x];
        _model = getModelInfo _x select 1;
        deleteVehicle _x;
        _deleted = _deleted + 1;
        deleteVehicle _x;
        _simpleObject = createSimpleObject [_model, _position];
        _simpleObject setVectorDirAndUp _vectorDirUp;
    };
} forEach vehicles;
format ["%1 deleted\n%2", _deleted, time] remoteExec ["hint"];