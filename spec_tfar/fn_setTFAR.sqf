local _parameterCorrect = params [["_unitName",objNull,[objNull]]];
local _arrayTypeName = "ARRAY";

if(_parameterCorrect) then {
	local _swFreq = _unitName getVariable ["Spec_var_swFreq", ["30"]];
	if(typeName _swFreq == _arrayTypeName && call TFAR_fnc_haveSWRadio) then {
		_swFreq resize (count _swFreq min 8);
		local _swRadio = call TFAR_fnc_activeSwRadio;
		{
			[_swRadio, (_forEachIndex + 1), _x] call TFAR_fnc_SetChannelFrequency;
		} foreach _swFreq;
	};

	local _lrFreq = _unitName getVariable ["Spec_var_lrFreq", ["30"]];
	if(typeName _lrFreq == _arrayTypeName && call TFAR_fnc_haveLRRadio) then {
		_lrFreq resize (count _lrFreq min 9);
		local _lrRadio = call TFAR_fnc_activeLrRadio;
		{
			[_lrRadio, (_forEachIndex + 1), _x] call TFAR_fnc_SetChannelFrequency;
		} foreach _lrFreq;
	};
};
