local _parameterCorrect = params [["_x",objNull,[objNull]]];

local _atLauncher = "UK3CB_BAF_AT4_AT_Launcher";
local _aaLauncher = "rhs_weap_fim92";
local _aaAmmo = "rhs_fim92_mag";

if(_parameterCorrect) then {
	clearWeaponCargoGlobal _x;
	clearMagazineCargoGlobal _x;
	_x addWeaponCargoGlobal [_atLauncher,2];
	_x addWeaponCargoGlobal [_aaLauncher,2];
	_x addMagazineCargoGlobal [_aaAmmo,2];
};
