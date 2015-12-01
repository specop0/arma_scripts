private _parameterCorrect = params [["_x",objNull,[objNull]]];

private _atLauncher = "UK3CB_BAF_AT4_AT_Launcher";
private _aaLauncher = "rhs_weap_fim92";
private _aaAmmo = "rhs_fim92_mag";

if(_parameterCorrect && isServer) then {
	clearWeaponCargoGlobal _x;
	clearMagazineCargoGlobal _x;
	_x addWeaponCargoGlobal [_atLauncher,2];
	_x addWeaponCargoGlobal [_aaLauncher,2];
	_x addMagazineCargoGlobal [_aaAmmo,2];
};
