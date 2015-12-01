private _parameterCorrect = params [["_x",objNull,[objNull]]];

private _standardAmmo = "hlc_30Rnd_556x45_SOST_AUG";
private _mgAmmo = "rhs_200rnd_556x45_M_SAW";
private _lmgAmmo = "hlc_100Rnd_762x51_B_M60E4";
private _secondaryAmmo = "rhsusf_mag_17Rnd_9x19_JHP";

private _smokeShell = "1Rnd_Smoke_Grenade_shell";
private _smokeShellRed = "1Rnd_SmokeRed_Grenade_shell";
private _heShell = "1Rnd_HE_Grenade_shell";

if(_parameterCorrect && isServer) then {
	clearMagazineCargoGlobal _x;
	_x addMagazineCargoGlobal [_standardAmmo,34];
	_x addMagazineCargoGlobal [_mgAmmo,4];
	_x addMagazineCargoGlobal [_lmgAmmo,4];
	_x addMagazineCargoGlobal [_secondaryAmmo,8];
	_x addMagazineCargoGlobal [_smokeShell,6];
	_x addMagazineCargoGlobal [_smokeShellRed,6];
	_x addMagazineCargoGlobal [_heShell,12];
};
