private _excludeTypes = [
	"Land_CampingChair_V1_F",
	"Land_Cargo_House_V3_F",
	"Land_Cargo_HQ_V3_F",
	"Land_Medevac_HQ_V1_F",
	"Land_Cargo_Patrol_V3_F",
	"Land_MapBoard_F",
	"Land_Noticeboard_F",
];

private _type = "";
private _deleted = 0;
private _entitiesToDelete = [];
private _clipboard = 'private ["_simpleObject"];';
{
	_type = typeOf _x;
	if(
		(
			_type isKindOf ["Thing", configFile >> "CfgVehicles"] 
			|| _type isKindOf ["Static", configFile >> "CfgVehicles"]
		)
		&& 
			!(
				_type in _excludeTypes
				|| _type isKindOf ["ReammoBox_F", configFile >> "CfgVehicles"]				
			)
		) then {
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
} forEach (all3DENEntities select 0);
copyToClipboard str _clipboard;
delete3DENEntities _entitiesToDelete;
systemChat format ["%1 deleted", _deleted];