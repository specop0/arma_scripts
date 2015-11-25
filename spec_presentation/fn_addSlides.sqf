/*
	Author: SpecOp0

	Description:
	Adds addAction entries to a object to enable slide show.
	Names of pictures muste be 'presentation_000.jpg', 'presentation_001.jpg' and so on.

	Parameter(s):
	0: OBJECT - object to show pictures (i.e. billboard sign)
	1: NUMBER - number of pictures (workaround to determine if picture exists)
	2 (Optional) : STRING - directory of pictures (default: pictures)

	Returns:
	true
*/

_parameterCorrect = params [ ["_sign",objNull,[objNull]], ["_noPictures",-1,[0]], ["_pictureDirectory","pictures",["STRING"]] ];
if(!isNull _sign) then {
	_sign addAction ["Next Slide", Spec_fnc_changeSlide, [1, _pictureDirectory], 2];
	_sign addAction ["Previous Slide", Spec_fnc_changeSlide, [-1, _pictureDirectory], 1];
	
	if(isServer) then {
		_sign setVariable ["Spec_var_presentationNumberOfSlides", _noPictures];
		[_sign, _sign, 0, [0, _pictureDirectory]] call Spec_fnc_changeSlide;
	};
} else {
	"Wrong Parameter: expected [object] or [object,pictureDirectoryString]" call BIS_fnc_error;
};
true
