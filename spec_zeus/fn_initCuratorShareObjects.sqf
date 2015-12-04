/*
	Author: FETT, SpecOp0

	Description:
	Adds to all Curators an EventHandler if a unit and group is placed.
	Adds to all Players an EventHandler to assign its (respawned) unit to allCurators.

	Returns:
	true
*/

if(isServer) then {
	{
		_x addEventHandler ["CuratorGroupPlaced",{ _this remoteExecCall ["Spec_fnc_groupPlaced",2,false]; }];
		_x addEventHandler ["CuratorObjectPlaced",{ _this remoteExecCall ["Spec_fnc_objectPlaced",2,false]; }];
	} forEach allCurators;
};
if(hasInterface) then {
	[player] call Spec_fnc_assignToAllCurators;
	player addEventHandler ["respawn", Spec_fnc_assignToAllCurators];
};
true
