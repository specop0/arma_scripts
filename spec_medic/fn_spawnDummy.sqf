/*
    Author: SpecOp0
    
    Description:
    Spawns a dummy AI with ACE Advanced Medical support and disable MOVE.
    
    Parameter(s):
    0: OBJECT - the object to use for positioning the dummy.
    
    Returns:
    OBJECT - the spawned dummy
*/
params [ ["_positionObject",player,[objNull]] ];

// spawn undamaged medic dummy
#define DUMMY_CLASS_NAME "B_Soldier_VR_F"
private _group = createGroup CIVILIAN;
private _dummy = _group createUnit [DUMMY_CLASS_NAME, _positionObject, [], 0, "NONE"];
_dummy setPosASL (getPosASL _positionObject);
_dummy disableAI "MOVE";
_dummy setUnitPos "DOWN";
// activate ace medic (needs advanced medic settings and remote controlled AI false)
_dummy setVariable ["bis_fnc_moduleRemoteControl_owner", _dummy, true];
_dummy setVariable ["ace_medical_enableMedical", true, true];
[_dummy] call ace_medical_fnc_init;

_dummy
