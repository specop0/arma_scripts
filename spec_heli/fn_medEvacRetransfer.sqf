/*
    Author: SpecOp0

    Description:
    Adds Action to (hardcoded) helicopter to allow retransfer of unit.
    Positions are saved in helicopter (from heli_medevac script).
    
    Edit name of helicopter or allowing of retransfer in const.hpp.

    Parameter(s):
    0: -

    Returns:
    true
*/
#include "const.hpp"

private _helicopter = MEDEVAC_ID;

if(isNil "_helicopter" || {isNull _helicopter}) then {
    hint format ["Script Error: Helicopter '%1' not found", str _helicopter];
} else {
    if(hasInterface && ALLOW_RETRANSFER_WITH_MEDEVAC == 1) then {
        // add ace action for retransfering units to frontline
        [_helicopter,1,["ACE_SelfActions",ACTION_MEDEVAC_RETRANSFER_ID]] call ace_interact_menu_fnc_removeActionFromObject;
        private _action = [ACTION_MEDEVAC_RETRANSFER_ID, ACTION_MEDEVAC_RETRANSFER_NAME, "", {
            params ["_target","_caller"];
            private _landingPadPos = _target getVariable [MEDEVAC_HELIPAD_LAST_LZ_VAR, position _target];
            private _landingPadBasePos =  _target getVariable [MEDEVAC_HELIPAD_BASE_VAR, position _target];
            private _crewGroup = group _target;
            private _wp0 = _crewGroup addWaypoint [_landingPadPos,0];
            _wp0 setWaypointType "TR UNLOAD";
            private _wp1 = _crewGroup addWaypoint [_landingPadBasePos,0];
            _wp1 setWaypointType "TR UNLOAD";
        }, {true}] call ace_interact_menu_fnc_createAction;
        [_helicopter,1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
};
true
