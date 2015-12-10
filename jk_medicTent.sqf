/*
 * Author: joko // Jonas
 */
JK_BuildAnimation = "Acts_carFixingWheel";
JK_BuildTime = 12;
JK_Medical_Vehicles = [zamak_medic];

JK_fnc_canBuildTent = {
    params ["_JKvehicle","_JKplayer"];
    !(_JKvehicle getVariable ["JK_buildTent", false]) && ((_JKplayer getVariable ["ace_medical_medicClass", 0]) >= 1 || (_JKplayer getVariable ["ACE_IsEngineer", 0]) == 2) && _JKplayer == vehicle _JKplayer
};

JK_fnc_destructTent = {
    (_this select 0) params ["_JKtent","_JKplayer"];
    private _JKvehicle = _JKtent getVariable ["JK_tentVehicle", objNull];
    _JKtent setVariable ["JK_tentVehicle", objNull, true];
    _JKvehicle setVariable ["JK_buildTent", false, true];
    deleteVehicle _JKtent;
};

JK_fnc_destructTentProgressBar = {
    player playMove JK_BuildAnimation;
    [JK_BuildTime, _this, JK_fnc_destructTent, {(_this select 0) select 1 switchMove ""}, "Reiße medizinisches Zelt ab"] call ace_common_fnc_progressBar;
};

JK_fnc_buildTent = {
    (_this select 0) params ["_JKvehicle","_JKplayer"];
    private _position = (getPos _JKvehicle) findEmptyPosition [5, 20, "MASH"];
    if (_position isEqualTo []) exitWith {hint "Nicht genug Platz zum Aufbau des Zeltes vorhanden."};
    private _JKtent = "MASH" createVehicle _position;
    _JKtent setdir (getDir _JKvehicle);
    private _action = ["JK_BuildTent", "Reiße medizinisches Zelt ab", "",
        JK_fnc_destructTentProgressBar,
        JK_fnc_canBuildTent
    ] call ace_interact_menu_fnc_createAction;
    [[_JKtent, 0, ["ACE_MainActions"], _action], "ace_interact_menu_fnc_addActionToObject", true] call BIS_fnc_MP;
    _JKtent setVariable ["ace_medical_isMedicalFacility", true, true];
    _JKvehicle setVariable ["JK_buildTent", true, true];
    _JKtent setVariable ["JK_tentVehicle", _JKvehicle, true];
};

JK_buildTentProgressBar = {
    params ["_JKvehicle"];
    private _position = (getPos _JKvehicle) findEmptyPosition [5, 20, "MASH"];
	if (_position isEqualTo []) exitWith {hint "Nicht genug Platz zum Aufbau des Zeltes vorhanden."};
    player playMove JK_BuildAnimation;
    [JK_BuildTime, _this, JK_fnc_buildTent, {(_this select 0) select 1 switchMove ""}, "Baue medzinisches Zelt auf"] call ace_common_fnc_progressBar;
};

_action = ["JK_BuildTent", "Baue medzinisches Zelt auf", "",
    JK_buildTentProgressBar,
    JK_fnc_canBuildTent
] call ace_interact_menu_fnc_createAction;

{
    [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	nil
} forEach JK_Medical_Vehicles;
