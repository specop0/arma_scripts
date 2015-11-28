local _parameterCorrect = params [["_unitName",objNull,[objNull]]];

if(_parameterCorrect) then {
	local _groupID = _unitName getVariable ["Spec_var_TFARgroup", 0];
	private ["_swFreq", "_lrFreq", "_callsign", "_BFTicon"];
	_BFTicon = "b_inf";
	
	switch _groupID do {
		case 0 : {
			_swFreq = ["100"];
			_lrFreq = ["30","31","32","41","42","43","51","52"];
			_callsign = "Gelb";
		};
		case 1 : {
			_swFreq = ["111","110","112","113"];
			_lrFreq = ["31","30"];
			_callsign = "Gruen";
		};
		case 2 : {
			_swFreq = ["112","110","111","113"];
			_lrFreq = ["31","30"];
			_callsign = "Schwarz";
		};
		case 3 : {
			_swFreq = ["113","110","111","112"];
			_lrFreq = ["31","30"];
			_callsign = "Blau";
		};
		case 4 : {
			_swFreq = ["121","120","122","123"];
			_lrFreq = ["32","30"];
			_callsign = "Braun";
		};
		case 5 : {
			_swFreq = ["122","120","121","123"];
			_lrFreq = ["32","30"];
			_callsign = "Rot";
		};
		case 6 : {
			_swFreq = ["123","120","121","122"];
			_lrFreq = ["32","30"];
			_callsign = "Violett";
		};
		case 7 : {
			_swFreq = ["141","140"];
			_lrFreq = ["41","30","31","32","42","43","51","52"];
			_callsign = "Weiss";
			_BFTicon = "b_air";
		};
		case 8 : {
			_swFreq = ["142","140"];
			_lrFreq = ["42","30","31","32","41","43","51","52"];
			_callsign = "Adler";
			_BFTicon = "b_air";
		};
		case 9 : {
			_swFreq = ["143","140"];
			_lrFreq = ["43","30","31","32","41","42","51","52"];
			_callsign = "Silber";
			_BFTicon = "b_air";
		};
		case 10 : {
			_swFreq = ["151","150","152"];
			_lrFreq = ["51","30","31","32","52"];
			_callsign = "Gold";
		};
		case 11 : {
			_swFreq = ["152","150","151"];
			_lrFreq = ["52","30","31","32","51"];
			_callsign = "Grau";
		};
		default {
			_swFreq = ["100"];
			_lrFreq = ["30"];
			_callsign = "Default";
		};
	};
	// set frequency variables
	_unitName setVariable ["Spec_var_swFreq", _swFreq];
	_unitName setVariable ["Spec_var_lrFreq", _lrFreq];

	// BFT Settings
	_unitName setGroupID [_callsign];
	_unitName setVariable ["BG_BFT_groupId", _callsign];
	_unitName setVariable ["BG_BFT_icon", _BFTicon]; 
	if(count _swFreq > 0) then {
		_unitName setVariable ["BG_BFT_radioSR", (_swFreq select 0)];
	};
	if(count _lrFreq > 0) then {
		_unitName setVariable ["BG_BFT_radioLR", (_lrFreq select 0)];
	};
	
};
true
