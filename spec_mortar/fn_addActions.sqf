/*
    Author: SpecOp0
    
    Description:
    AddsActions (ACE self interaction) to a player who takes to role of a FAC for Mk6 Mortar.
    - Spawn Target (offroad)
    - Show 4-Liner
    - Show more info about to target for using the RangeTable
    - Show Solution (similar to RangeTable)
    
    Parameter(s):
    0: OBJECT - player who is a FAC
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_object",objNull,[objNull]] ];
if(_parameterCorrect && hasInterface) then {
    // spawn target (event handler etc. only local to FAC)
    _object = player;
    [_object,1,["ACE_SelfActions",ACTION_NEW_TARGET_ID]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionNewTarget = [ACTION_NEW_TARGET_ID, ACTION_NEW_TARGET_NAME, "", {
        params ["_target","_caller"];
        private _mortarTarget = _caller getVariable [MORTAR_TARGET_VAR,objNull];
        if(isNull _mortarTarget || {damage _mortarTarget == 1}) then {
            _mortarTarget = "C_Offroad_01_F" createVehicle getPos _caller;
            _caller setVariable [MORTAR_TARGET_VAR,_mortarTarget];
            // add eventHandler to indicate damage
            _mortarTarget addEventHandler ["Dammaged",{
                params ["_unit","_selectionName","_damage"];
                hint format ["Hit!\n%1 Schaden erhalten", _damage];
            }];
            _mortarTarget addEventHandler ["Killed",{
                params ["_unit","_selectionName","_damage"];
                if(!isNull _unit) then { deleteVehicle _unit };
                private _scriptHandle = [] spawn {
                    sleep 1;
                    hint "Hit!\nZiel zerstoert";
            };
            }];
        } else {
            _mortarTarget setDamage 0;
        };
        // select new position for vehicle
        private _placementRadius = 2000;
        for "_i" from 0 to 10 do {
            _mortarTarget setVehiclePosition [(getPos _caller),[],_placementRadius,"NONE"];
            if(getPosASL _mortarTarget select 2 >= 0) exitWith {};
        };
    }, {true}] call ace_interact_menu_fnc_createAction;
    [_object,1,["ACE_SelfActions"], _actionNewTarget] call ace_interact_menu_fnc_addActionToObject;
    // show liner
    [_object,1,["ACE_SelfActions",ACTION_LINER_ID]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionShowLiner = [ACTION_LINER_ID, ACTION_LINER_NAME, "", {
        params ["_target","_caller"];
        private _mortarTarget = _caller getVariable [MORTAR_TARGET_VAR,objNull];
        if(isNull _mortarTarget) then {
            hint "Kein Ziel vorhanden.\nDerjenige, der das Ziel anfordert erhaelt den Liner";
        } else {
            private _commandType = floor(random 2) + 1;
            private _attackType = "Punktangriff";
            private _posASL = getPosASL _mortarTarget;
            private _xCoord = round((_posASL select 0)/10.0);
            private _yCoord = round((_posASL select 1)/10.0);
            private _height = round(_posASL select 2);
            private _shellType = "HE";
            private _shellNumbers = 2;
            // format string in a way that the coordinates have 4 digits
            private _xCoordString = "";
            private _xCoordTemp = _xCoord;
            while {_xCoordTemp < 1000.0 } do {
                _xCoordString = format ["0%1",_xCoordString];
                _xCoordTemp = _xCoordTemp * 10.0;
            };
            _xCoordString = format ["%1%2",_xCoordString,_xCoord];
            private _yCoordString = "";
            private _yCoordTemp = _yCoord;
            while {_yCoordTemp < 1000.0 } do {
                _yCoordString = format ["0%1",_yCoordString];
                _yCoordTemp = _yCoordTemp * 10.0;
            };
            _yCoordString = format ["%1%2",_yCoordString,_yCoord];
            // show liner
            hint parseText format["
                <t align='center'>Liner wie folgt:</t><br />
                <t align='left'>Typ</t><t align='right'>%1</t><br />
                <t align='left'>Art</t><t align='right'>%2</t><br />
                <t align='left'>Koordinaten</t><t align='right'>%3-%4</t><br />
                <t align='left'>Hoehe</t><t align='right'>%5m</t><br />
                <t align='left'>Geschossart</t><t align='right'>%6</t><br />
                <t align='left'>Anzahl</t><t align='right'>%7</t>",
                _commandType,_attackType,_xCoordString,_yCoordString,_height,_shellType,_shellNumbers];
        };
    }, {!isNull((_this select 0) getVariable [MORTAR_TARGET_VAR,objNull])}] call ace_interact_menu_fnc_createAction;
    [_object,1,["ACE_SelfActions"], _actionShowLiner] call ace_interact_menu_fnc_addActionToObject;
    // show tips
    [_object,1,["ACE_SelfActions",ACTION_TIP_ID]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionShowTip = [ACTION_TIP_ID, ACTION_TIP_NAME, "", {
        params ["_target","_caller"];
        private _mortarTarget = _caller getVariable [MORTAR_TARGET_VAR,objNull];
        if(isNull _mortarTarget) then {
            hint "Kein Ziel vorhanden.\nDerjenige, der das Ziel anfordert erhaelt die Tipps";
        } else {
            private _result = [_mortarTarget,_caller] call Spec_mortar_fnc_compute;
            private _distance = round(_result select 0);
            private _azimuth = _result select 1;
            private _altitudeDiff = round((getPosASL _caller select 2) - (getPosASL _mortarTarget select 2));
            // show tip
            hint parseText format["
                <t align='center'>Daten fuer die Rangetabelle:</t><br />
                <t align='left'>Distanz</t><t align='right'>%1m</t><br />
                <t align='left'>Azimuth</t><t align='right'>%2mil</t><br />
                <t align='left'>Hoehenunterschied</t><t align='right'>%3m</t>",
                _distance,_azimuth,_altitudeDiff];
        };
    }, {!isNull((_this select 0) getVariable [MORTAR_TARGET_VAR,objNull])}] call ace_interact_menu_fnc_createAction;
    [_object,1,["ACE_SelfActions"], _actionShowTip] call ace_interact_menu_fnc_addActionToObject;
    // show result
    [_object,1,["ACE_SelfActions",ACTION_SOLUTION_ID]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionShowResult = [ACTION_SOLUTION_ID, ACTION_SOLUTION_NAME, "", {
        params ["_target","_caller"];
        private _mortarTarget = _caller getVariable [MORTAR_TARGET_VAR,objNull];
        if(isNull _mortarTarget) then {
            hint "Kein Ziel vorhanden.\nDerjenige, der das Ziel anfordert erhaelt die Tipps";
        } else {
            private _result = [_mortarTarget,_caller] call Spec_mortar_fnc_compute;
            private _distance = round(_result select 0);
            private _azimuth = _result select 1;
            private _altitudeDiff = round((getPosASL _caller select 2) - (getPosASL _mortarTarget select 2));
            private _charge0 = _result select 2;
            private _charge1 = _result select 3;
            private _charge2 = _result select 4;
            // show tip
            hint parseText format["
                <t align='center'>Daten fuer den Moerser:</t><br />
                <t align='left'>Azimuth</t><t align='right'>%1mil</t><br />
                <t align='center'>Elevation fuer Charges</t><br />
                <t align='left'>Charge 0</t><t align='right'>%2mil</t><br />
                <t align='left'>Charge 1</t><t align='right'>%3mil</t><br />
                <t align='left'>Charge 2</t><t align='right'>%4mil</t><br />
                <t align='center'>Hoehenunterschied von %5m bei einer Entfernung von %6m nicht beruecksichtigt!</t><br />",
                _azimuth,_charge0,_charge1,_charge2,_altitudeDiff,_distance];
        };
    }, {!isNull((_this select 0) getVariable [MORTAR_TARGET_VAR,objNull])}] call ace_interact_menu_fnc_createAction;
    [_object,1,["ACE_SelfActions"], _actionShowResult] call ace_interact_menu_fnc_addActionToObject;
};
true
