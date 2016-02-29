/*
	Author: SpecOp0
	
	Description:
	Packs small crates (NATO_Box_Base) into big supply crate.
	
	For each crate (ACE) animation has to be completed.
	Afterwards crates will be attached to supply crate and
	hidden (on server).
	
	See const.hpp for parameters (e.g. pack speed, animation).
	
	Parameter(s):
	0: OBJECT - player who packs the crates
	1 (Optional): NUMBER - number of crate to pack (default: 0)
	2 (Optional): ARRAY of OBJECT - crates to pack (default: [])
	
	Returns:
	true
*/
#include "const.hpp"

params [ ["_unit",objNull,[objNull]], ["_currentCrate",0,[0]], ["_nearCrates",[],[[objNull]]] ];

if(!isNull _unit) then {
	// search for nearest crates
	private _posATL = getPosATL _unit;
	if(_currentCrate == 0) then {
		// search for crates which are not hidden (attached to other crate)
		private _allNearCrates = nearestObjects [_posATL, ["NATO_Box_Base"], CRATE_RADIUS_TO_SEARCH];
		_nearCrates = [];
		{
			if(!isNull _x && {!isObjectHidden _x}) then {
				_nearCrates pushBack _x;
			};
			if(count _nearCrates == MAX_CRATES) exitWith {};
		} forEach _allNearCrates;
	};
	_nearCrates resize ((count _nearCrates) min MAX_CRATES);

	// play animation with ace progress bar for each crate
	_currentCrate = _currentCrate + 1;
	if(_currentCrate <= count _nearCrates) then {
		_unit playMove SPEC_ACTION_PACK_ANIMATION;
		[
			SPEC_ACTION_PACK_ANIMATION_TIME,
			[_unit,_currentCrate,_nearCrates],
			{
				(_this select 0) call Spec_cargoDrop_fnc_pack;
			},
			{
				(_this select 0) params ["_unit"];
				_unit switchMove "";
			},
			format [SPEC_ACTION_PACK_STATUS_TEXT,_currentCrate, count _nearCrates] 
		] call ace_common_fnc_progressBar;
	} else {
		if(count _nearCrates > 0) then {
			_unit switchMove "";
			
			// spawn supply crate
			private _supplyCrate = createVehicle ["B_supplyCrate_F", _posATL, [],0,""];
			clearBackpackCargoGlobal _supplyCrate;
			clearMagazineCargoGlobal _supplyCrate;
			clearItemCargoGlobal _supplyCrate;
			clearWeaponCargoGlobal _supplyCrate;
			_supplyCrate allowDamage false;

			// set crate in front of unit
			private _direction = direction _unit;
			private _offset = 1.5;
			_posATL = [(_posATL select 0) + (_offset * (sin _direction)), (_posATL select 1) + (_offset * (cos _direction)), 0];
			_supplyCrate setPosATL _posATL;
			_supplyCrate setDir (_direction + 90);

			// attach nearest creates to supply crate
			_supplyCrate setVariable [SPEC_ATTACHED_CRATES_VAR,_nearCrates,true];
			{
				_x attachTo [_supplyCrate,[0,0,-100]];
				// hide object (on server) else parachute will not attach safely
				[_x,true] remoteExec ["hideObjectGlobal",2];
			} forEach _nearCrates;

			// addAction to detach crates
			[_supplyCrate] remoteExec ["Spec_cargoDrop_fnc_addUnpackAction"];
		} else {
			hint SPEC_ACTION_PACK_NO_CRATE_FOUND;
		};
	};
};
true
