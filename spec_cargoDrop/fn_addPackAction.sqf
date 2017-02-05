/*
    Author: SpecOp0
    
    Description:
    Adds Action to a player which is then able to pack small crates (NATO_Box_Base)
    into big supply crate.
    
    See const.hpp for name of action.
    
    Parameter(s):
    0: OBJECT - player who is allowed to pack crates
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]] ];

if(_parameterCorrect && hasInterface && local _unit) then {
    private _actionPack = [SPEC_ACTION_PACK_ID, SPEC_ACTION_PACK_NAME, "", {
        params ["_target","_caller"];
        [_caller] call Spec_cargoDrop_fnc_pack;
    },
    {
        params ["_target","_caller"];
        count ( nearestObjects [getPosATL _caller, ["NATO_Box_Base"], CRATE_RADIUS_TO_SEARCH] ) > 0
    }] call ace_interact_menu_fnc_createAction;
    [_unit,1, ["ACE_SelfActions",SPEC_ACTION_PACK_ID]] call ace_interact_menu_fnc_removeActionFromObject;
    [_unit,1, ["ACE_SelfActions"], _actionPack] call ace_interact_menu_fnc_addActionToObject;
};
true
