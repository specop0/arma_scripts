/*
	Author: SpecOp0

	Description:
	Spawns multiple cached group in scheduled environment with sleep to avoid heavy load.
	The groups are spawned from a starting to an ending index (including this index).

	Parameter(s):
	0: NUMBER - unique index of first cached group to spawn (must be positive or zero and unit has to beached with cacheGroup)
	1: NUMBER - unique index of last  cached group to spawn (must be positive or zero and unit has to beached with cacheGroup)
	2 (Optional): NUMBER - sleep time in seconds (default 0.5) 

	Returns:
	BOOL - true if spawning is successful (otherwise errors are shown in addition)
*/

private ["_scriptHandle"];
_scriptHandle = _this spawn {
	private ["_parameterCorrect"];
	_parameterCorrect = params [ ["_start",0,[0]], ["_end",-1,[0]] ];
	if(_parameterCorrect) then {
		if(_start >= 0) then {
			params [ "", "", ["_sleepTime",0.5,[0]] ];
			private ["_i"];
			_i = _start;
			while { _i <= _end } do {
				[_i] call Spec_fnc_spawnGroup;
				sleep _sleepTime;
				_i = _i + 1;
			};
		} else {
			["Wrong Parameter: Start value is negative (%1) - expected positive value.", _start] call BIS_fnc_error;
		};
	} else {
		["Wrong Parameter: Expected start and end value to be (positive) numbers - optional parameter sleepTime."] call BIS_fnc_error;
	};
};
