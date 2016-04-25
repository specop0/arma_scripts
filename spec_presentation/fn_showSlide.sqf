/*
    Author: SpecOp0

    Description:
    Shows a slide at an object.

    Parameter(s):
    0: OBJECT - object to show pictures (i.e. billboard sign)
    1: NUMBER - number of slide to show
    2: STRING - picture directory

    Returns:
    true
*/

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
        _returnValue = true;
    
        if(_returnValue) then {
            _sign setObjectTextureGlobal [0,_pictureString];
        } else {
            // file testing with htmlLoad does not work on server (need interface)
            format ["%1 does not exist", _pictureString] call BIS_fnc_error;
        };
    };
} else {
    "Wrong Usage: showSlide should only be called from server" call BIS_fnc_error;
};
_returnValue
