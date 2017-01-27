/*
    Author: SpecOp0
    
    Description:
    AddsActions (ACE interaction) to object which is a training station for spawning meddic dummy (ACE Advanced Medical).
    - Spawn medic dummy: deactivate move, add ACE wounds
    - Clean up medic dummy
    - Spawn crate with medic material (which can be deleted)
    - (De)activate a loop to show medic data
    
    Needs ACE Advanced Medical Module with setting "Remote Controlled AI" = false / Disabled
    
    Parameter(s):
    0: OBJECT - object which is a training station
    1: OBJECT - object at which a dummy should be spawned (e.g. a sleeping mat)
    2: STRING - name of medic dummy (used for display string and internal variable name)
    
    Returns:
    true
*/
#define SPEC_MEDIC_ACTIVATE_VAR "Spec_medic_activateMedicData"
params [ ["_object",objNull,[objNull]], ["_trainingObject",objNull,[objNull]], ["_name","Medic Dummy",[""]] ];

if(hasInterface) then {
    // medic supply crate
    [_object,0,["ACE_MainActions","medic_dummy_crate"]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionSpawnMedicCrate = ["medic_dummy_crate", "Spawne Medic-Kiste", "", {
        params ["_target", "_caller"];
        private _crate = "TTT_Logistik_Medic_Us" createVehicle getPosASL _caller;
        private _actionDeleteCrate = ["crate_delete", "Lösche Kiste", "", {
            params ["_target", "_caller"];
            deleteVehicle _target;
        }, {true}] call ace_interact_menu_fnc_createAction;
        [_crate,0,["ACE_MainActions"], _actionDeleteCrate] remoteExecCall ["ace_interact_menu_fnc_addActionToObject"];
    }, {true}] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionSpawnMedicCrate] call ace_interact_menu_fnc_addActionToObject;

    // medic dummy
    private _actionMedicDummy = [_name, _name, "", {
        params ["_target","_caller","_argv"];
        _argv params ["_trainingObject","_name"];
        // delete previous dummy
        private _previousDummy = _trainingObject getVariable [_name, objNull];
        deleteVehicle _previousDummy;
        // create new dummy
        private _dummy = [_trainingObject] call Spec_medic_fnc_spawnDummy;
        // add wounds
        [_dummy, 0.3, "body", "stab"] call ace_medical_fnc_addDamageToUnit;
        [_dummy, 0.3, "hand_r", "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;
        [_dummy, 0.3, "hand_l", "shell"] call ace_medical_fnc_addDamageToUnit;
        [_dummy, 0.8, "leg_r", "bullet"] call ace_medical_fnc_addDamageToUnit;
        [_dummy, 0.5, "leg_l", "falling"] call ace_medical_fnc_addDamageToUnit;
        // save object
        _trainingObject setVariable [_name, _dummy, true];
        hint format ["%1 erstellt.", _name];
    }, {true}, {}, [_trainingObject,_name] ] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionMedicDummy] call ace_interact_menu_fnc_addActionToObject;
    private _actionMedicCleanup = [
        format ["%1_delete", _name],
        format ["Lösche '%1'", _name], "",
    {
        params ["_target","_caller","_argv"];
        _argv params ["_trainingObject","_name"];
        // delete previous dummy
        private _previousDummy = _trainingObject getVariable [_name, objNull];
        deleteVehicle _previousDummy;
        // save object
        _trainingObject setVariable [_name, objNull, true];
        hint format ["%1 gelöscht.", _name];
    }, {
        params ["_target","_caller","_argv"];
        _argv params ["_trainingObject","_name"];
        !isNull (_trainingObject getVariable [_name, objNull])
    }, {}, [_trainingObject,_name] ] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionMedicCleanup] call ace_interact_menu_fnc_addActionToObject;
    
    // assign as medic
    [_object,0,["ACE_MainActions","assignMedic"]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionAssignMedic = [
        "assignMedic",
        "Ich bin Medic", "", {
            params ["_target", "_caller"];
            _caller setVariable ["ace_medical_medicClass", 2, true];
            hint "Lassen Sie mich Arzt, ich bin durch!";
        }, {
            params ["_target", "_caller"];
            !([_caller] call ace_medical_fnc_isMedic)
        }
    ] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionAssignMedic] call ace_interact_menu_fnc_addActionToObject;
    
    // unassign medic
    [_object,0,["ACE_MainActions","unassignMedic"]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionUnassignMedic = [
        "unassignMedic",
        "Ich bin kein Medic", "", {
            params ["_target", "_caller"];
            _caller setVariable ["ace_medical_medicClass", 0, true];
            [false] call Spec_medic_fnc_showMedicDataLoop;
            hint "Ihre Doktorarbeit konnte der Plagiatsprüfung nicht standhalten. Ihnen wurde der Doktortitel aberkannt.";
        }, {
            params ["_target", "_caller"];
            [_caller] call ace_medical_fnc_isMedic
        }
    ] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionUnassignMedic] call ace_interact_menu_fnc_addActionToObject;
    
    // show medic data
    [_object,0,["ACE_MainActions","showMedicData"]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionActivateMedicData = [
        "showMedicData",
        "Zeige medizinische Daten", "", {
            params ["_target", "_caller"];
            [true] call Spec_medic_fnc_showMedicDataLoop;
            hint "Loop aktiviert";
        }, {
            params ["_target", "_caller"];
            [_caller] call ace_medical_fnc_isMedic && !(missionNamespace getVariable [SPEC_MEDIC_ACTIVATE_VAR, false])
        }
    ] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionActivateMedicData] call ace_interact_menu_fnc_addActionToObject;
    
    // hide medic data
    [_object,0,["ACE_MainActions","hideMedicData"]] call ace_interact_menu_fnc_removeActionFromObject;
    private _actionDeactivateMedicData = [
        "hideMedicData",
        "Verstecke medizinische Daten", "", {
            params ["_target", "_caller"];
            [false] call Spec_medic_fnc_showMedicDataLoop;
            hint "";
        }, {
            params ["_target", "_caller"];
            missionNamespace getVariable [SPEC_MEDIC_ACTIVATE_VAR, false]
        }
    ] call ace_interact_menu_fnc_createAction;
    [_object,0,["ACE_MainActions"], _actionDeactivateMedicData] call ace_interact_menu_fnc_addActionToObject;
};
true
