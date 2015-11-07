private ["_parameterCorrect", "_returnValue"];
_parameterCorrect = params [ ["_sign",objNull,[objNull]], ["_pictureNumber",0,[0]], ["_pictureDirectory","pictures",["STRING"]] ];
_returnValue = false;
if(isServer) then {
	if(_parameterCorrect) then {
		private ["_pictureString", "_ctrl"];
		if(_pictureNumber < 100) then {
			if(_pictureNumber < 10) then {
				_pictureString = format ["presentation_00%1.jpg", _pictureNumber];
			} else {
				_pictureString = format ["presentation_0%1.jpg", _pictureNumber];
			};
		} else {
			_pictureString = format ["presentation_%1.jpg", _pictureNumber];
		};
		_pictureString = format ["%1\%2", _pictureDirectory, _pictureString];

		_ctrl = findDisplay 0 ctrlCreate ["RscHTML", -1];
		_ctrl htmlLoad _pictureString;
		_returnValue = ctrlHTMLLoaded _ctrl;
		ctrlDelete _ctrl;
		
		if(_returnValue) then {
			_sign setObjectTextureGlobal [0,_pictureString];
		} else {
			format ["%1 does not exist", _pictureString] call BIS_fnc_error;
		};
	};
} else {
	"Wrong Usage: showSlide should only be called from server" call BIS_fnc_error;
};
_returnValue