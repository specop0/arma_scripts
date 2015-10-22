local _parameterCorrect = params [["_x",objNull,[objNull]]];

local _standardWeapon = "hlc_rifle_auga3";
local _standardWeaponGL = "hlc_rifle_auga3_GL";
local _lmg = "rhs_weap_m249_pip_L";
local _mg = "hlc_lmg_m60";


if(_parameterCorrect) then {
	clearWeaponCargoGlobal _x;
	_x addWeaponCargoGlobal [_standardWeapon,4];
	_x addWeaponCargoGlobal [_standardWeaponGL,1];
	_x addWeaponCargoGlobal [_lmg,2];
	_x addWeaponCargoGlobal [_mg,1];
};
