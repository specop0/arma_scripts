/*
    Author: SpecOp0
    
    Description:
    Adds Action to unpack (previously packed) supply crate.
    
    See const.hpp for name of action.
    
    Parameter(s):
    0: OBJECT - supply crate to unpack
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_supplyCrate",objNull,[objNull]] ];

if(_parameterCorrect && hasInterface) then {

    private _actionUnpack = [SPEC_ACTION_UNPACK_ID, SPEC_ACTION_UNPACK_NAME, "", {
        _this remoteExec ["Spec_cargoDrop_fnc_unpack",2];
    }, {true}] call ace_interact_menu_fnc_createAction;
    [_supplyCrate,0, ["ACE_MainActions"], _actionUnpack] call ace_interact_menu_fnc_addActionToObject;
};
true
