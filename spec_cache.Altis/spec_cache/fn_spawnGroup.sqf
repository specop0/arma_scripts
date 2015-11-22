/*
	Author: SpecOp0

	Description:
	Spawns cached group.

	Parameter(s):
	0: NUMBER - unique index to spawn a cached group (must be positive or zero and unit has to beached with cacheGroup)

	Returns:
	BOOL - true if spawning is successful (otherwise errors are shown in addition)
*/

local _returnValue = false;
if(isServer) then {
	local _parameterCorrect = params [["_noGroupToSpawn",-1,[0]]];
	local _noCachedGroups = count Spec_var_cachedGroups;

	if(_parameterCorrect) then {
		local _noGroupToSpawnRounded = round _noGroupToSpawn;
		if(_noGroupToSpawn == _noGroupToSpawnRounded) then {
			if(_noGroupToSpawn < _noCachedGroups && _noGroupToSpawn >= 0) then {
				local _cachedGroupArray = Spec_var_cachedGroups select _noGroupToSpawn;
				local _sizeCachedGroupArray = count _cachedGroupArray;
				if(_sizeCachedGroupArray != 0) then {
					if( _sizeCachedGroupArray == 5) then {
						_returnValue = [(_cachedGroupArray select 0),( _cachedGroupArray select 1), (_cachedGroupArray select 2), (_cachedGroupArray select 3), (_cachedGroupArray select 4)] call Spec_fnc_spawnGroup_data;
						Spec_var_cachedGroups set [_noGroupToSpawn,[]];
					} else {
						["Script Error: Group number (%1) should have been cached, but entry is wrong, size is (%2)", _noGroupToSpawn, count _cachedGroupArray] call BIS_fnc_error;
					};
				} else {
					["Wrong Index for cached group: Group with number (%1) has not been cached yet or was already spawned", _noGroupToSpawn] call BIS_fnc_error;
				};
			} else {
				["Wrong Index for cached group: We have cached group from 0 to (%1), got (%2)", (_noCachedGroups - 1), _noGroupToSpawn] call BIS_fnc_error;
			};
		} else {
			["Wrong parameter: expected Integer got (%1)",_noGroupToSpawn] call BIS_fnc_error;
		};
	} else {
		"Wrong parameter: expected Number" call BIS_fnc_error;
	};
};
_returnValue
