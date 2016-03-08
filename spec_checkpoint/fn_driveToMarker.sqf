/*
	Author: SpecOp0
	
	Description:
	Unit will get in nearest (or pre-defined) vehicle and
	drive to destination (given marker).
	If unit reaches destination and has items defined as smuggler
	items (const.hpp) counter will be increased.
	
	See const.hpp for name of action and fn_addPassCheckAction.sqf.
	
	Parameter(s):
	0: OBJECT - unit 
	1: STRING - name of marker
	
	Returns:
	true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]], ["_marker","",[""]] ];

if(_parameterCorrect && isServer) then {
	// get in vehicle if outside
	if(vehicle _unit == _unit) then {
		private _wpGetIn = group _unit addWaypoint [_unit getVariable [SPEC_VAR_VEHICLE_OF_CIVILIAN,_unit],0];
		_wpGetIn setWaypointType "GETIN NEAREST";
	};
	// move to marker
	private _wpMove = group _unit addWaypoint [getMarkerPos _marker, 0];
	_wpMove setWaypointSpeed "NORMAL";
	// if smuggler increase value
	private _vehicle = _unit getVariable [SPEC_VAR_VEHICLE_OF_CIVILIAN,_unit];
	private _loaded = _vehicle getVariable ["ace_cargo_loaded",[]];
	private _smuggler = false;
	private _class = "";
	{
		_class = if (_x isEqualType "") then {_x} else {typeOf _x};
		if(_class in SPEC_ARRAY_SMUGGLER_ITEMS) exitWith { _smuggler = true; };
	} forEach _loaded;
	if(_smuggler) then {
		if(isNil {SPEC_VAR_SMUGGLER_COUNT}) then {
			SPEC_VAR_SMUGGLER_COUNT = 0;
		};
		private _statement = {SPEC_VAR_SMUGGLER_COUNT = SPEC_VAR_SMUGGLER_COUNT + 1;} call ace_common_fnc_codeToString;
		_wpMove setWaypointStatements ["true", _statement];
//	} else {
//		_wpMove setWaypointStatements ["true", "[this] call Spec_fnc_deleteGroup;"];
	};
	_unit setVariable [SPEC_VAR_VEHICLE_OF_CIVILIAN,nil];
};
true
