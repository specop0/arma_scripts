/*
	Author: FETT, SpecOp0

	Description:
	Adds to all Curators an EventHandler if a unit and group is placed.
	Adds to all Players an EventHandler to assign its (respawned) unit to allCurators.
	
	In addition for every Curator allUnits will be added.

	Returns:
	true
*/
if(hasInterface) then {
	// add EventHandler to Curator Modules
	{
		_x addEventHandler ["CuratorGroupPlaced",{ _this remoteExecCall ["Spec_fnc_groupPlaced",2,false]; }];
		_x addEventHandler ["CuratorObjectPlaced",{ _this remoteExecCall ["Spec_fnc_objectPlaced",2,false]; }];
	} forEach allCurators;
	// assign Player to Curator Modules
	[player] remoteExec ["Spec_fnc_assignToAllCurators",2];
	player addEventHandler ["Respawn", {_this remoteExec ["Spec_fnc_assignToAllCurators",2];}];
};
if(isServer) then {
	// add allUnits to allCurators
	{
		_x addCuratorEditableObjects [allUnits, false];
		_x addCuratorEditableObjects [vehicles, false];
	} forEach allCurators;
};
true
