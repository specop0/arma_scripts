// TFAR frequencies
private _groupToFrequencies = [[],[["131"],["30"]]] call CBA_fnc_hashCreate;
[_groupToFrequencies, "Gelb", [["131","130"],["30"]]] call CBA_fnc_hashSet;

[_groupToFrequencies, "Schwarz", [["132","130"],[]]] call CBA_fnc_hashSet;
[_groupToFrequencies, "Blau", [["133","130"],[]]] call CBA_fnc_hashSet;
[_groupToFrequencies, "Rot", [["134","130"],[]]] call CBA_fnc_hashSet;
[_groupToFrequencies, "Violett", [["135","130"],[]]] call CBA_fnc_hashSet;

[_groupToFrequencies, "Braun", [["151","150"],["50"]]] call CBA_fnc_hashSet;
[_groupToFrequencies, "Weiß", [["152","150"],["40"]]] call CBA_fnc_hashSet;
[_groupToFrequencies, "Silber", [["153","150"],["40"]]] call CBA_fnc_hashSet;

private _currentGroupName = "";
private _currentGroup = objNull;
private _numberOfGroups = -1;
screenToWorld [0.5,0.5] params ["_positionX", "_positionY"];
{
    _x params ["_groupName","_description","_classname","_loadout"];

    private _useCurrentGroup = _groupName isEqualTo _currentGroupName;
    if(!_useCurrentGroup) then {
        _numberOfGroups = _numberOfGroups + 1;
    };
    private _xDiff = 0.0 + _numberOfGroups * 1.8;
    private _yDiff = 0.0;

    private _unit = objNull;
    if(_useCurrentGroup) then {
        _yDiff = _yDiff - count units _currentGroup * 2.5;
        _unit = _currentGroup create3DENEntity ["Object",_classname,[_positionX + _xDiff,_positionY + _yDiff,0]];
    } else {
        _unit = create3DENEntity ["Object",_classname,[_positionX + _xDiff,_positionY + _yDiff,0]];
        _currentGroupName = _groupName;
        _currentGroup = group _unit;

        _currentGroup set3DENAttribute ["groupID",_currentGroupName];
        _currentGroup set3DENAttribute ["formation",4];
    };
    _unit set3DENAttribute ["description", format ["#%3 - %1@%2", _description, _currentGroupName, count units _currentGroup]];
    _unit set3DENAttribute ["ControlMP", true];
    
    [_groupToFrequencies,_currentGroupName] call CBA_fnc_hashGet params ["_swFrequencies","_lrFrequencies"];
    private _initField = format [
        "this setVariable [""loadout"", ""%1""]; this setVariable [""Spec_var_swFreq"", %2]; this setVariable [""Spec_var_lrFreq"", %3];",
        _loadout,
        str _swFrequencies,
        str _lrFrequencies];
    _unit set3DENAttribute ["init", _initField];
} forEach [
    ["Gelb","Truppführer","B_officer_F","OPL"],
    ["Gelb","stellv. Truppführer","B_officer_F","OPL"],
    
    ["Schwarz","Truppführer","B_Soldier_TL_F","TF"],
    ["Schwarz","stellv. Truppführer","B_Soldier_GL_F","GL"],
    ["Schwarz","LMG-Schütze","B_Soldier_lite_F","LMG"],
    ["Schwarz","AT-Schütze","B_soldier_LAT_F","AT"],
    ["Schwarz","LMG-Schütze","B_Soldier_lite_F","LMG"],
    ["Schwarz","AT-Schütze","B_soldier_LAT_F","AT"],
    
    ["Blau","Truppführer","B_Soldier_TL_F","TF"],
    ["Blau","stellv. Truppführer","B_Soldier_GL_F","GL"],
    ["Blau","MG-Assistent","B_soldier_AAR_F","MGAssi"],
    ["Blau","MG-Schütze","B_soldier_AR_F","MG"],
    ["Blau","AA-Assistent","B_soldier_AAA_F","AAAssi"],
    ["Blau","AA-Schütze","B_soldier_AA_F","AA"],
    
    ["Rot","Truppführer","B_Soldier_TL_F","TF"],
    ["Rot","stellv. Truppführer","B_Soldier_GL_F","GL"],
    ["Rot","LMG-Schütze","B_Soldier_lite_F","LMG"],
    ["Rot","AT-Schütze","B_soldier_LAT_F","AT"],
    ["Rot","LMG-Schütze","B_Soldier_lite_F","LMG"],
    ["Rot","AT-Schütze","B_soldier_LAT_F","AT"],
    
    ["Violett","Truppführer","B_Soldier_TL_F","TF"],
    ["Violett","stellv. Truppführer","B_Soldier_GL_F","GL"],
    ["Violett","MG-Assistent","B_soldier_AAR_F","MGAssi"],
    ["Violett","MG-Schütze","B_soldier_AR_F","MG"],
    ["Violett","AA-Assistent","B_soldier_AAA_F","AAAssi"],
    ["Violett","AA-Schütze","B_soldier_AA_F","AA"],
    
    ["Braun","Truppführer","B_medic_F","Medic"],
    ["Braun","Gefechtssanitäter","B_medic_F","Medic"],
    ["Braun","Gefechtssanitäter","B_medic_F","Medic"],
    ["Braun","Gefechtssanitäter","B_medic_F","Medic"],
    
    ["Weiß","Fahrzeugführer","B_Helipilot_F","Pilot"],
    ["Weiß","Fahrzeugführer","B_Helipilot_F","Pilot"],
    ["Weiß","Feldarzt","B_helicrew_F","Arzt"],
    ["Weiß","Feldarzt","B_helicrew_F","Arzt"],
    
    ["Silber","Logistiker","B_soldier_repair_F","Logistik"],
    ["Silber","Logistiker","B_soldier_repair_F","Logistik"]
];