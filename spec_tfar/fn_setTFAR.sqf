local _parameterCorrect = params [["_unitName",objNull,[objNull]]];

if(_parameterCorrect) then {
	local _groupID = _unitName getVariable ["Spec_var_TFARgroup", 0];
	
	local _swRadio = [];
	local _lrRadio = [];
	
	switch _groupID do {
		case 0 : {
			_swRadio = ["100"];
			_lrRadio = ["30","31","32","41","42","43","51","52"];
		};
		case 1 : {
			_swRadio = ["111","110","112","113"];
			_lrRadio = ["31","30"];
		};
		case 2 : {
			_swRadio = ["112","110","111","113"];
			_lrRadio = ["31","30"];
		};
		case 3 : {
			_swRadio = ["113","110","111","112"];
			_lrRadio = ["31","30"];
		};
		case 4 : {
			_swRadio = ["121","120","122","123"];
			_lrRadio = ["32","30"];
		};
		case 5 : {
			_swRadio = ["122","120","121","123"];
			_lrRadio = ["32","30"];
		};
		case 6 : {
			_swRadio = ["123","120","121","122"];
			_lrRadio = ["32","30"];
		};
		case 7 : {
			_swRadio = ["141","140"];
			_lrRadio = ["41","30","31","32","42","43","51","52"];
		};
		case 8 : {
			_swRadio = ["142","140"];
			_lrRadio = ["42","30","31","32","41","43","51","52"];
		};
		case 9 : {
			_swRadio = ["143","140"];
			_lrRadio = ["43","30","31","32","41","42","51","52"];
		};
		case 10 : {
			_swRadio = ["151","150","152"];
			_lrRadio = ["51","30","31","32","52"];
		};
		case 11 : {
			_swRadio = ["152","150","151"];
			_lrRadio = ["52","30","31","32","51"];
		};
		default {
			_swRadio = ["100"];
			_lrRadio = ["30"];
		};
	};
	
	if(call TFAR_fnc_haveSWRadio) then {
		_swFreq resize (count _swFreq min 8);
		local _swRadio = call TFAR_fnc_activeSwRadio;
		{
			[_swRadio, (_forEachIndex + 1), _x] call TFAR_fnc_SetChannelFrequency;
		} foreach _swFreq;
	};

	if(typeName _lrFreq == _arrayTypeName && call TFAR_fnc_haveLRRadio) then {
		_lrFreq resize (count _lrFreq min 9);
		local _lrRadio = call TFAR_fnc_activeLrRadio;
		{
			[_lrRadio, (_forEachIndex + 1), _x] call TFAR_fnc_SetChannelFrequency;
		} foreach _lrFreq;
	};
};
