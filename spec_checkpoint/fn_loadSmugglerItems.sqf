/*
	Author: SpecOp0
	
	Description:
	Loads smuggler items in radius of 10m in ACE Cargo of given vehicle.
	
	See const.hpp for smuggler items.
	
	Parameter(s):
	0: OBJECT - vehicle of smuggler
	
	Returns:
	true
*/
#include "const.hpp"
private _parameterCorrect = params [ ["_vehicle",objNull,[objNull]] ];

if(_parameterCorrect && isServer) then {
	private _smugglerItemsNearby = nearestObjects [_vehicle, SPEC_ARRAY_SMUGGLER_ITEMS, 10];
	{
		[_x,_vehicle] call ace_cargo_fnc_loadItem;
	} forEach _smugglerItemsNearby;
};
true
