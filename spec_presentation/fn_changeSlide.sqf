if(isServer) then {
	private ["_parameterCorrect"];
	_parameterCorrect = params [ ["_sign",objNull,[objNull]], "_caller", "_idAction"];
	_addActionParameterCorrect = (_this select 3) params [ ["_type",0,[0]], ["_pictureDirectory","pictures",["STRING"]] ];
	if(_parameterCorrect && _addActionParameterCorrect) then {
		private ["_pictureNumber","_validSlide"];
		_pictureNumber = _sign getVariable ["Spec_var_presentationSlideNo", 0];
		_validSlide = true;
		switch (_type) do {
			case 1: {
				_pictureNumber = _pictureNumber + 1;
			};
			case -1: {
				if(_pictureNumber > 0) then {
					_pictureNumber = _pictureNumber - 1;		
				} else {
					_validSlide = false;
				};
			};
		};
		
		if(_validSlide) then {
			if([_sign, _pictureNumber, _pictureDirectory] call Spec_fnc_showSlide) then {
				_sign setVariable ["Spec_var_presentationSlideNo", _pictureNumber, true];
			};
		} else {
			hint "Currently first slide is shown.";
		};
	} else {
		"Script Error: parsing arguments failed" call BIS_fnc_error;
	};
} else {
	[_this,"Spec_fnc_changeSlide", false] call BIS_fnc_MP;
};