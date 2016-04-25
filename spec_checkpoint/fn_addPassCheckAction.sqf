/*
    Author: SpecOp0
    
    Description:
    Adds ACE Actions to unit and it's vehicle (vehicle is saved into variable).
    If Action is activated unit will drive to destination (given marker).
    
    See const.hpp for name of action and fn_driveToMarker.sqf for called function.
    
    Parameter(s):
    0: OBJECT - unit
    1: STRING - name of marker
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]], ["_marker","",[""]] ];

if(_parameterCorrect && isServer) then {
    if(vehicle _unit != _unit) then {
        _unit setVariable [SPEC_VAR_VEHICLE_OF_CIVILIAN, vehicle _unit];
    };
    [-1,
    {
        if(hasInterface) then {
            params [ ["_unit",objNull,[objNull]], ["_marker","",[""]] ];
            // addAction to unit
            private _actionPassCheck = 
            [
                SPEC_ACTION_PASS_CHECK_ID,
                SPEC_ACTION_PASS_CHECK_NAME,
                "",
                {
                    params ["_target","_caller"];
                    (_this select 2) params ["_marker"];
                    [_target,_marker] remoteExec ["Spec_checkpoint_fnc_driveToMarker",2];
                },
                {
                    params ["_target","_caller"];
                    alive _target
                }, {}, [_marker]
            ] call ace_interact_menu_fnc_createAction;
            [_unit,0,["ACE_MainActions"], _actionPassCheck] call ace_interact_menu_fnc_addActionToObject;
            // addAction to vehicle
            if(vehicle _unit != _unit) then {
                private _actionPassCheckVehicle = 
                [
                    SPEC_ACTION_PASS_CHECK_ID,
                    SPEC_ACTION_PASS_CHECK_NAME,
                    "",
                    {
                        params ["_target","_caller"];
                        (_this select 2) params ["_marker"];
                        [leader group _target,_marker] remoteExec ["Spec_checkpoint_fnc_driveToMarker",2];
                    },
                    {
                        params ["_target","_caller"];
                        !isNull group _target && {!isPlayer leader group _target && alive leader group _target}
                    }, {}, [_marker]
                ] call ace_interact_menu_fnc_createAction;
                [vehicle _unit,0,["ACE_MainActions"], _actionPassCheckVehicle] call ace_interact_menu_fnc_addActionToObject;
            };
        };
    }, [_unit,_marker] ] call CBA_fnc_globalExecute;
};
true
