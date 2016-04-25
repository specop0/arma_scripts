/*
    Author: SpecOp0

    Description:
    If player uses ACE Action he can click on the map and on clicked position
    a marker called will be placed (ID and displayed name defined in const.hpp).
    
    This placed marker can be used for the Helicopter Taxi script.

    Parameter(s):
    -

    Returns:
    true
*/
#include "const.hpp"

if(hasInterface) then {
    onMapSingleClick {
        if(player getVariable [MOVE_MARKER_A_BOOL_VAR, false]) then {
            deleteMarker MARKER_A_ID;
            private _marker = createMarker [MARKER_A_ID, [0,0]];
            _marker setMarkerPos _pos;
            _marker setMarkerShape "ICON";
            _marker setMarkerType "hd_pickup";
            _marker setMarkerText MARKER_A_NAME;
            _marker setMarkerColor MARKER_A_COLOR_SIDE;
            _marker setMarkerSize [1,1];
            player setVariable [MOVE_MARKER_A_BOOL_VAR, false];
        };
    };

    [player,1,["ACE_SelfActions",ACTION_MOVE_MARKER_A_ID]] call ace_interact_menu_fnc_removeActionFromObject;
    _action = [ACTION_MOVE_MARKER_A_ID, ACTION_MOVE_MARKER_A_NAME, "", {(_this select 0) setVariable [MOVE_MARKER_A_BOOL_VAR, true]}, {true}] call ace_interact_menu_fnc_createAction;
    [player,1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};