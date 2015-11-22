/*
	Author: FETT, SpecOp0

	Description:
	Adds to all Curators an EventHandler if a unit and group is placed.

	Returns:
	true
*/

{
	_x addEventHandler ["CuratorGroupPlaced",{ _this remoteExecCall ["Spec_fnc_groupPlaced",2,false]; }];
	_x addEventHandler ["CuratorObjectPlaced",{ _this remoteExecCall ["Spec_fnc_objectPlaced",2,false]; }];
} forEach allCurators;
true
