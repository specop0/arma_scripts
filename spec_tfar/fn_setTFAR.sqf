local _parameterCorrect = params [["_unitName",objNull,[objNull]]];
local _arrayTypeName = "ARRAY";

if(_parameterCorrect) then {
	local _swFreq = _unitName getVariable "Spec_var_swFreq";
	if(!isNil "_swFreq") then {
		if(typeName _swFreq == _arrayTypeName && call TFAR_fnc_haveSWRadio) then {
			local _size = count _swFreq;
			local _i = 0;
			local _swRadio = call TFAR_fnc_activeSwRadio;
			while {_i < 9 && _i < _size} do {
				[_swRadio, (_i + 1), (_swFreq select _i)] call TFAR_fnc_SetChannelFrequency;
				_i = _i + 1;
			};
		};
	};

	local _lrFreq = _unitName getVariable "Spec_var_lrFreq";
	if(!isNil "_lrFreq") then {
		if(typeName _lrFreq == _arrayTypeName && call TFAR_fnc_haveLRRadio) then {
			local _size = count _lrFreq;
			local _i = 0;
			local _lrRadio = call TFAR_fnc_activeLrRadio;
			while {_i < 10 && _i < _size} do {
				[_lrRadio, (_i+1), (_lrFreq select _i)] call TFAR_fnc_SetChannelFrequency;
				_i = _i + 1;
			};
		};
	};
};
