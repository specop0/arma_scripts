/*
	Author: SpecOp0

	Description:
	Sets Short Range according to array "Spec_var_swFreq" of unit
	and Long Range according to array "Spec_var_lrFreq" of unit.
	
	Example in init-field add: this setVariable ["Spec_var_swFreq",["101","100"]];
	
	Parameter(s):
	0: OBJECT - unit/player whose frequency should be set

	Returns:
	true
*/
private _parameterCorrect = params [["_unitName",objNull,[objNull]]];
private _arrayTypeName = "ARRAY";

if(_parameterCorrect) then {
	private _swFreq = _unitName getVariable ["Spec_var_swFreq", ["30"]];
	if(typeName _swFreq == _arrayTypeName && call TFAR_fnc_haveSWRadio) then {
		_swFreq resize (count _swFreq min 8);
		private _swRadio = call TFAR_fnc_activeSwRadio;
		{
			[_swRadio, (_forEachIndex + 1), _x] call TFAR_fnc_SetChannelFrequency;
		} foreach _swFreq;
	};

	private _lrFreq = _unitName getVariable ["Spec_var_lrFreq", ["30"]];
	if(typeName _lrFreq == _arrayTypeName && call TFAR_fnc_haveLRRadio) then {
		_lrFreq resize (count _lrFreq min 9);
		private _lrRadio = call TFAR_fnc_activeLrRadio;
		{
			[_lrRadio, (_forEachIndex + 1), _x] call TFAR_fnc_SetChannelFrequency;
		} foreach _lrFreq;
	};
};
true
