/*
    Author: SpecOp0
    
    Description:
    Shows the medic data for given unit.
    
    Parameter(s):
    0: OBJECT - the unit to show the medic data for.
    
    Returns:
    true
*/

params [ ["_unit", objNull, [objNull]] ];

if !(isNull _unit) then {
    hintSilent format [
        "Patient: %1\nPuls: %2\nBlutdruck: %3 zu %4\nBlutvolumen: %5\nBewusstlos? %6\nRevive State A? %7\nRevive State B? %8\nZeit in Revive State B: %9s\nTod? %10",
        name _unit,
        _unit getVariable ["ace_medical_heartRate", 80],
        _unit getVariable ["ace_medical_bloodPressure", [80,120]] select 1,
        _unit getVariable ["ace_medical_bloodPressure", [80,120]] select 0,
        _unit getVariable ["ace_medical_bloodVolume", 100],
        ([_unit] call ace_medical_fnc_getUnconsciousCondition) call Spec_medic_fnc_boolToStr,
        (_unit getVariable ["ace_medical_inCardiacArrest", false]) call Spec_medic_fnc_boolToStr,
        (_unit getVariable ["ace_medical_inReviveState", false]) call Spec_medic_fnc_boolToStr,
        round(CBA_missionTime - (_unit getVariable ["ace_medical_reviveStartTime", CBA_missionTime])),
        (_unit getVariable ["ACE_isDead", false]) call Spec_medic_fnc_boolToStr
    ];
};
true
