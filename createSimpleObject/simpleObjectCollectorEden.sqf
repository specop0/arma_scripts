// types of classes to ignore (e.g. have doors to use)
private _excludeTypes = [
    // chair (ACE sitting)
    "Land_CampingChair_V1_F",
    // military structures
    "Land_MilOffices_V1_F"
];
// types of commands to ignore (e.g. setObjectTextureGlobal)
private _excludeInitCommands = [
    "setObjectTexture",
    "addAction"
];
// types of base classes to ignore (e.g. flag poles)
// [configfile >> "CfgVehicles" >> "your classname here"] call BIS_fnc_returnParents
private _excludeBaseClasses = [
    "TTT_Notizschild_Base",
    "TTT_Schild_Base",
    "TTT_Tafel_Base",
    "FlagCarrierCore",
    "ReammoBox_F",
    // military structures
    "Land_i_Barracks_V1_F",
    "Cargo_HQ_base_F",
    "Cargo_House_base_F",
    "Cargo_Patrol_base_F",
    "Cargo_Tower_base_F"
];
{
    _excludeInitCommands set [_forEachIndex, toLower _x];
} forEach _excludeInitCommands;

private _type = "";
private _deleted = 0;
private _entitiesToDelete = [];
private _clipboard = 'private ["_simpleObject"];';
{
    _type = typeOf _x;
    if(
        // cache object if thing or static
        (
            _type isKindOf ["Thing", configFile >> "CfgVehicles"] 
            || _type isKindOf ["Static", configFile >> "CfgVehicles"]
        )
        && 
        // and is not an excluded or has a name set
            !(
                _type in _excludeTypes
                || !(_x get3DENAttribute "name" isEqualTo [""])
            )
        ) then {
        // search for base classes
        _ignoreClass = false;
        {
            if(_type isKindOf [_x, configFile >> "CfgVehicles"]) exitWith { _ignoreClass = true; };
        } forEach _excludeBaseClasses;
        if !(_ignoreClass) then {
            // search init field for code
            _initCode = toLower ((_x get3DENAttribute "init") select 0);
            // ignore init if empty
            _ignoreInit = _initCode isEqualTo "";
            if !(_ignoreInit) then {
                // else search if any excluded commands are present
                _ignoreInit = true;
                {
                    // if excluded command is present don't ignore the init and keep the object
                    if( ([_initCode, _x] call CBA_fnc_find) >= 0 ) exitWith { _ignoreInit = false };
                } forEach _excludeInitCommands;
            };
            if (_ignoreInit) then {
                // get data
                _position = getPosWorld _x;
                _vectorDirUp = [vectorDir _x, vectorUp _x];
                _model = getModelInfo _x select 1;
                // prepare for deletion
                _deleted = _deleted + 1;
                _entitiesToDelete pushBack _x;
                // generate string for initServer.sqf
                _clipboard = formatText ['%1
                    _simpleObject = createSimpleObject ["%2", %3];
                    _simpleObject setVectorDirAndUp %4;
                    ',
                    _clipboard,_model,_position,_vectorDirUp];
                _x set3DENAttribute ["objectIsSimple",true];
            };
        };
    };
} forEach (all3DENEntities select 0);
copyToClipboard str _clipboard;
//delete3DENEntities _entitiesToDelete;
systemChat format ["%1 deleted", _deleted];
{
    _type = _x;
    {
        if( _type isKindOf [_x, configFile >> "CfgVehicles"] ) exitWith {
            systemChat format ["%1 type excluded with base class %2",_type,_x];
        };
    } forEach _excludeBaseClasses;
} forEach _excludeTypes;