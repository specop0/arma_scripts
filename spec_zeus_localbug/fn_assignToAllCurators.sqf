/*
    Author: SpecOp0

    Description:
    Assigns a Player to all Curators (Respawn/JIP).
    If the Player is a Curator an action entry will be added to assign allUnits manually.

    Parameter(s):
    0: OBJECT - player (or unit) which should be added to the Curators

    Returns:
    true
*/

if(!isServer) then {
    // call this function on server
    _this remoteExec ["Spec_zeus_fnc_assignToAllCurators", 2, false];
} else {
    private _parameterCorrect = params [ ["_player",objNull,[objNull]] ];
    if(_parameterCorrect) then {
        // add respawned (or JIP) player to allCurators
        {
            _x addCuratorEditableObjects [[_player],false];
        } forEach allCurators;

        /*private _scriptHandle = _this spawn {
            // wait for full initialization (1 works as well) otherwise getAssignedCuratorLogic always null
            sleep 20;
            private _parameterCorrect = params [ ["_player",objNull,[objNull]] ];
            if(_parameterCorrect) then {
                // if player is Curator add allUnits action
                if(!isNull (getAssignedCuratorLogic _player) ) then {
                    [_player, ["Assign Units", 
                        {
                            (getAssignedCuratorLogic (_this select 1)) addCuratorEditableObjects [allUnits, false];
                            (getAssignedCuratorLogic (_this select 1)) addCuratorEditableObjects [vehicles, false];
                        }, nil, 1.5, false, true, "", "true"] ] remoteExec ["addAction", _player] ;
                };
            };
        };*/
    } else {
        "Wrong Parameter: Expected (player) object" call BIS_fnc_error;
    };
};
true
