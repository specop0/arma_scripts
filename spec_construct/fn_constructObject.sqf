/*
	Author: SpecOp0
	
	Description:
	Construct given object (globally).
	
	Parameter(s):
	0: OBJECT - unit/player who wants to construct something
	1: STRING - type of object to build
	2: POSITION - position of object (posASL)
	3: NUMBER - direction of object
	2: NUMBER - number of animations to display before finishing the construction
	3: STRING - name of variable (via getVariable) to reactivate parent construction action if construction is aborted
	
	Returns:
	true
*/
#include "const.hpp"

params [
	["_unit",objNull,[objNull]],
	["_objectTypeToBuild","",[""]],
	["_posASL",[0,0,0],[[]]],
	["_direction",0,[0]], 
	["_currentAnimation",0,[0]],
	["_numberOfAnimations",1,[0]],
	["_buildingAvailableBoolString","",[""]]
];

// position query
if(!isNull _unit && !("" in [_objectTypeToBuild,_buildingAvailableBoolString])) then {
	_currentAnimation = _currentAnimation + 1;
	if(_currentAnimation <= _numberOfAnimations) then {
		_unit playMove SPEC_ACTION_BUILD_ANIMATION;
		[
			SPEC_ACTION_BUILD_ANIMATION_TIME,
			[_unit,_objectTypeToBuild,_posASL,_direction,_currentAnimation,_numberOfAnimations,_buildingAvailableBoolString],
			{
				(_this select 0) call SPEC_FNC_CONSTRUCT_ACTION;
			},
			{
				(_this select 0) params ["_unit","","","","","","_buildingAvailableBoolString"];
				_unit switchMove "";
				_unit setVariable [_buildingAvailableBoolString,true];
			},
			format [SPEC_ACTION_BUILD_STATUS_TEXT,_currentAnimation, _numberOfAnimations] 
		] call ace_common_fnc_progressBar;
	} else {
		_unit switchMove "";
		private _object = _objectTypeToBuild createVehicle position _unit;
		_object setDir _direction;
		_object setPosASL _posASL;
		// don't change owner ship because of static object
	};
};
true
