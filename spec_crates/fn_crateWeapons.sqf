_parameterCorrect = params [["_x",objNull,[objNull]]];

_standardWeapon = "hlc_rifle_auga3";
_standardWeaponGL = "hlc_rifle_auga3_GL";
_lmg = "rhs_weap_m249_pip_L";
_mg = "hlc_lmg_m60";


if(_parameterCorrect) then {
	clearWeaponCargoGlobal _x;
	_x addWeaponCargoGlobal [_standardWeapon,4];
	_x addWeaponCargoGlobal [_standardWeaponGL,1];
	_x addWeaponCargoGlobal [_lmg,2];
	_x addWeaponCargoGlobal [_mg,1];
};
