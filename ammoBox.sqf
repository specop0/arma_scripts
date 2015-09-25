_ammoBoxType = "B_supplyCrate_F";
_parachuteType = "B_Parachute_02_F";

_enemyPatLeaderType = "LOP_NAPA_Infantry_TL";
_enemyPatSoldierAtype = "LOP_NAPA_Infantry_Rifleman";
_enemyPatSoldierBtype = "LOP_NAPA_Infantry_AT";
_enemyPatSide = RESISTANCE;
_enemyPatCycleRadius = 125 + random 100;
_spawnedAmmoBoxHeight = 500;
_enemePatSpawnDistance = 500;

_hintAmmoBoxSpawned = "Die Versorgungskiste wurde ueber Ihnen abgeworfen.\nPassen Sie auf, dass der Feind diese nicht entdeckt!";

params ["",["_caller",objNull]];

if(!isNull _caller) then {
	comment "spawn ammo box with parachute at player position";
	_pos = getPosATL _caller;
	_pos set [2,_spawnedAmmoBoxHeight];

	_spawnedAmmoBox = createVehicle [_ammoBoxType,_pos, [],0,""];
	_parachute =  createVehicle [_parachuteType,_pos, [], 0, "NONE"];
	_spawnedAmmoBox attachTo [_parachute, [0,0,1]];
	
	comment "spawn enemy patrol near player";
	_patGroup = createGroup _enemyPatSide;
	_angle = (random 360);

	_enemySpawnPos = _caller modelToWorld [sin(_angle)*_enemePatSpawnDistance,cos(_angle)*_enemePatSpawnDistance,0];
	_enemySpawnMarker = createMarkerLocal ["AmmoBoxSpawnerMarker#", [_enemySpawnPos select 0, _enemySpawnPos select 1]];
	_enemySpawnMarker = "AmmoBoxSpawnerMarker#";
	_enemySpawnMarker setMarkerPos [_enemySpawnPos select 0, _enemySpawnPos select 1];

	_enemyPatLeader = _patGroup createUnit [_enemyPatLeaderType, getMarkerPos _enemySpawnMarker, [], 25, "FORM"];
	[_enemyPatLeader] join _patGroup;
	_enemyPatSoldierA = _patGroup createUnit [_enemyPatSoldierAtype, getMarkerPos _enemySpawnMarker, [], 25, "FORM"];
	[_enemyPatSoldierA] join _patGroup;
	_enemyPatSoldierB = _patGroup createUnit [_enemyPatSoldierBtype, getMarkerPos _enemySpawnMarker, [], 25, "FORM"];
	[_enemyPatSoldierB] join _patGroup;

	_wp0 = _patGroup addWaypoint [_pos,0];
	_wp0 setWaypointType "MOVE";
	_wp0 setWaypointSpeed "FULL";

	_tempAngle = 41 + random 10;
	_wp1 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],1];
	_wp1 setWaypointSpeed "NORMAL";
	_tempAngle = 131 + random 10;
	_wp2 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],2];
	_tempAngle = 221 + random 10;
	_wp3 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],3];
	_tempAngle = 311 + random 10;
	_wp4 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],4];
	_tempAngle = 45;
	_wp5 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],5];
	_wp5 setWaypointType "CYCLE";
	
	comment "set ammo content here";
	clearWeaponCargoGlobal _spawnedAmmoBox;
	clearMagazineCargoGlobal _spawnedAmmoBox;
	clearItemCargoGlobal _spawnedAmmoBox;
	clearBackpackCargoGlobal _spawnedAmmoBox;

	_spawnedAmmoBox addMagazineCargoGlobal ["30Rnd_556x45_Stanag",26];
	_spawnedAmmoBox addMagazineCargoGlobal ["rhsusf_20Rnd_762x51_m118_special_Mag",5];
	_spawnedAmmoBox addMagazineCargoGlobal ["BWA3_120Rnd_762x51",3];
	_spawnedAmmoBox addMagazineCargoGlobal ["BWA3_200Rnd_556x45",4];

	_spawnedAmmoBox addItemCargoGlobal ["ACE_fieldDressing",50];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_packingBandage",35];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_elasticBandage",10];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_quikclot",10];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_tourniquet",6];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_salineIV_500",10];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_salineIV",10];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_epinephrine",10];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_morphine",10];
	_spawnedAmmoBox addItemCargoGlobal ["ACE_atropine",5];

	_spawnedAmmoBox addItemCargoGlobal ["DemoCharge_Remote_Mag",2];
	_spawnedAmmoBox addWeaponCargoGlobal ["BWA3_Pzf3",1];
	_spawnedAmmoBox addItemCargoGlobal ["BWA3_Pzf3_IT",1];
	
	comment "end of ammo content";
	hint _hintAmmoBoxSpawned;
	
	comment "land ammo box safely (if stuck in tree)";
	_spawnedAmmoBoxOldPos = getPosATL _spawnedAmmoBox;
	sleep 60;
	_spawnedAmmoBoxCurPos = getPosATL _spawnedAmmoBox;
	waitUntil{
		_spawnedAmmoBoxCurPos = getPosATL _spawnedAmmoBox;
		sleep 5;
		if (isNull _parachute) then {
			true
		} else {
			if (_spawnedAmmoBoxOldPos distance _spawnedAmmoBoxCurPos < 2) then {
				_spawnedAmmoBoxCurPos set [2,0];
				detach _spawnedAmmoBox;
				deleteVehicle _parachute;
				_spawnedAmmoBox setPosATL _spawnedAmmoBoxCurPos;
				true
			} else {
				_spawnedAmmoBoxOldPos = _spawnedAmmoBoxCurPos;
				false
			};
		};
	};
} else {
	hint "Script Error: Calling player is Null";
};