_parameterCorrect = params [["_x",objNull,[objNull]]];

_standardAmmo = "hlc_30Rnd_556x45_SOST_AUG";
_mgAmmo = "rhs_200rnd_556x45_M_SAW";
_lmgAmmo = "hlc_100Rnd_762x51_B_M60E4";
_secondaryAmmo = "rhsusf_mag_17Rnd_9x19_JHP";

_smokeShell = "1Rnd_Smoke_Grenade_shell";
_smokeShellRed = "1Rnd_SmokeRed_Grenade_shell";
_heShell = "1Rnd_HE_Grenade_shell";

if(_parameterCorrect) then {
	clearMagazineCargoGlobal _x;
	_x addMagazineCargoGlobal [_standardAmmo,34];
	_x addMagazineCargoGlobal [_mgAmmo,4];
	_x addMagazineCargoGlobal [_lmgAmmo,4];
	_x addMagazineCargoGlobal [_secondaryAmmo,8];
	_x addMagazineCargoGlobal [_smokeShell,6];
	_x addMagazineCargoGlobal [_smokeShellRed,6];
	_x addMagazineCargoGlobal [_heShell,12];
};
