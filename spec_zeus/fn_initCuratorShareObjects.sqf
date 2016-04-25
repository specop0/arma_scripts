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
        _x addEventHandler ["CuratorGroupPlaced",{ _this remoteExecCall ["Spec_zeus_fnc_groupPlaced",2,false]; }];
        _x addEventHandler ["CuratorObjectPlaced",{ _this remoteExecCall ["Spec_zeus_fnc_objectPlaced",2,false]; }];
        _x addEventHandler ["CuratorObjectEdited",{
            params ["_curator","_entity"];
            if(!local _entity) then {
                private _dir = direction _entity;
                [_entity,_dir] remoteExec ["setDir",_entity];
            };
        }];
    } forEach allCurators;
    // assign Player to Curator Modules
    [player] remoteExec ["Spec_zeus_fnc_assignToAllCurators",2];
    player addEventHandler ["Respawn", {_this remoteExec ["Spec_zeus_fnc_assignToAllCurators",2];}];
};
if(isServer) then {
    // add allUnits to allCurators
    {
        _x addCuratorEditableObjects [allUnits, false];
        _x addCuratorEditableObjects [vehicles, false];
    } forEach allCurators;
};
true
