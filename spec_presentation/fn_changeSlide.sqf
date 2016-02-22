/*
	Author: SpecOp0

	Description:
	Changes slide of object to next or previous slide.
	Has to be called via addAction entry.
	
	If first or last slide is shown and previous or next slide
	should be shown a hint is displayed for the caller.

	Parameter(s):
	0: OBJECT - object to show pictures (i.e. billboard sign)
	1: OBJECT - player which selected the addAction entry
	2: NUMBER
	3: ARRAY - arguments of addAction entry
		0: NUMBER - indication if next slide (1), previous slide (-1) or current slide (0)
		1: STRING - picture directory

	Returns:
	true
*/

if(isServer) then {
	private _parameterCorrect = params [ ["_sign",objNull,[objNull]], ["_caller",objNull,[objNull]], "_idAction"];
	_addActionParameterCorrect = (_this select 3) params [ ["_type",0,[0]], ["_pictureDirectory","pictures",["STRING"]] ];
	if(_parameterCorrect && _addActionParameterCorrect) then {
		private ["_pictureNumber","_validSlide","_numberOfSlides"];
		_numberOfSlides = _sign getVariable ["Spec_presentation_var_numberOfSlides", -1];
		_pictureNumber = _sign getVariable ["Spec_presentation_var_currentSlide", 0];
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
		if(_pictureNumber >= _numberOfSlides) then {
			"Currently last slide is shown\nCould not load next slide." remoteExec ["hint", _caller];
		} else {
			if(_validSlide) then {
				if([_sign, _pictureNumber, _pictureDirectory] call Spec_presentation_fnc_showSlide) then {
					_sign setVariable ["Spec_presentation_var_currentSlide", _pictureNumber];
				};
			} else {
				"Currently first slide is shown.\nCould not load previous slide." remoteExec ["hint", _caller];
			};
		};
	} else {
		"Script Error: parsing arguments failed" call BIS_fnc_error;
	};
} else {
	_this remoteExec ["Spec_presentation_fnc_changeSlide", 2];
};
true
