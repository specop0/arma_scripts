// types of classes to ignore (e.g. have doors to use)
private _excludeTypes = [
	// chair (ACE sitting)
	"Land_CampingChair_V1_F",
	// military structures
	"Land_i_Barracks_V1_F",
	"Land_i_Barracks_V1_dam_F",
	"Land_i_Barracks_V2_F",
	"Land_i_Barracks_V2_dam_F",
	"Land_u_Barracks_V2_F",
	"Land_Cargo_House_V1_F",
	"Land_Cargo_House_V2_F",
	"Land_Cargo_House_V3_F",
	"Land_Cargo_HQ_V1_F",
	"Land_Cargo_HQ_V2_F",
	"Land_Cargo_HQ_V3_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Patrol_V2_F",
	"Land_Cargo_Patrol_V3_F",
	"Land_Cargo_Tower_V1_F",
	"Land_Cargo_Tower_V1_No1_F",
	"Land_Cargo_Tower_V1_No2_F",
	"Land_Cargo_Tower_V1_No3_F",
	"Land_Cargo_Tower_V1_No4_F",
	"Land_Cargo_Tower_V1_No5_F",
	"Land_Cargo_Tower_V1_No6_F",
	"Land_Cargo_Tower_V1_No7_F",
	"Land_Cargo_Tower_V2_F",
	"Land_Cargo_Tower_V3_F",
	"Land_Medevac_house_V1_F",
	"Land_Medevac_HQ_V1_F",
	"Land_MilOffices_V1_F"
];
// types of commands to ignore (e.g. setObjectTextureGlobal)
private _excludeInitCommands = [
	"setObjectTexture"
];
{
	_excludeInitCommands set [_forEachIndex, toLower _x];
} forEach _excludeInitCommands;

/*
Base Classes for military structures (w/o MilOffices)
Land_i_Barracks_V1_F

Cargo_HQ_base_F
Cargo_House_base_F
Cargo_Patrol_base_F
Cargo_Tower_base_F
*/

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
		// and is not an ammo box or has a name set
			!(
				_type in _excludeTypes
				|| _type isKindOf ["ReammoBox_F", configFile >> "CfgVehicles"]
				|| !(_x get3DENAttribute "name" isEqualTo [""])
			)
		) then {
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
		};
	};
} forEach (all3DENEntities select 0);
copyToClipboard str _clipboard;
delete3DENEntities _entitiesToDelete;
systemChat format ["%1 deleted", _deleted];