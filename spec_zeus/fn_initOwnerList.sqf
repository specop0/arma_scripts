/*
	Author: SpecOp0

	Description:
	Initializes a list with the server ID and ID of headless clients on the server.
	In addition for every Curator allUnits will be added.

	Returns:
	true
*/

if(isServer) then {
	// add allUnits to allCurators
	{
		_x addCuratorEditableObjects [allUnits, false];
		_x addCuratorEditableObjects [vehicles, false];
	} forEach allCurators;
	// init ownerList
	if(isNil "Spec_var_ownerList") then {
		Spec_var_ownerList = [];
	};
	if(count Spec_var_ownerList == 0) then {
		private _scriptHandle = [] spawn {
			// sleep because otherwise the serverID is 0
			sleep 20;
			// look for a local unit to get the serverID
			private _serverID = 0;
			{
				if(!isNull _x && {local _x}) then {
					_serverID = owner _x;
					if(_serverID != 0) exitWith {};
				};
			} forEach allUnits;
			if(_serverID != 0) then {
				Spec_var_ownerList pushBack _serverID;
			} else {
				// serverID seems often to be 2 (always?)
				Spec_var_ownerList pushBack 2;
			};

			// push back headless clients
			private ["_hcID"];
			{
				if(!isNull _x && {typeOf _x == "HeadlessClient_F"}) then {
					_hcID = owner _x;
					if(_hcID != 0 && _hcID != _serverID) then {
						Spec_var_ownerList pushBack _hcID;
					};
				};
			} forEach allPlayers;

			// assign AI groups to Server and HC (if HC exist)
			if(count Spec_var_ownerList > 1) then {
				private _playerGroups = [];
				{
					if (!isNull _x && {!((group _x) in _playerGroups)}) then {
						_playerGroups pushBack (group _x);
					};
				} forEach allPlayers;
				private _i = 0;
				private _groupHasAI = false;
				private _id = 2;
				{
					if(!isNull _x) then {
						_groupHasAI = false;
						{
							if (_x isKindOf "Man") exitWith {_groupHasAI = true};
						} forEach (units _x);
						if(_groupHasAI) then {
							_id = [] call Spec_fnc_getNextOwnerID;
							_x setGroupOwner _id;
						};
					};
				} forEach allGroups - _playerGroups;

			};

		};
	};
};
true
