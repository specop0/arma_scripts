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
