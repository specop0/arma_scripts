_parameterCorrect = params [ ["_sign",objNull,[objNull]], ["_pictureDirectory","pictures",["STRING"]] ];
comment "optional parameter picture directory";
if(!isNull _sign) then {
	comment "curator objects after init.sqf assigned?";
	_sign addAction ["Next Slide", Spec_fnc_changeSlide, [1, _pictureDirectory], 2];
	_sign addAction ["Previous Slide", Spec_fnc_changeSlide, [-1, _pictureDirectory], 1];
	
	if(isServer) then {
		[_sign, 0, 0, [0, _pictureDirectory]] call Spec_fnc_changeSlide;
	};
} else {
	"Wrong Parameter: expected [object] or [object,pictureDirectoryString]" call BIS_fnc_error;
};