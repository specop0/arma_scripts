/*
	Author: SpecOp0

	Description:
	Initializes a list with the serverID on the server.
	(TODO add HeadlessClients)
	In addition for every Curator allUnits will be added.

	Returns:
	true
*/

if(isServer) then {
	// add allUnits to allCurators
	{
		_x addCuratorEditableObjects [allUnits, false];
	} forEach allCurators;
	// init ownerList
	if(isNil "Spec_var_ownerList") then {
		Spec_var_ownerList = [];
	};
	if(count Spec_var_ownerList == 0) then {
		private _scriptHandle = [] spawn {
			// sleep because otherwise the serverID is 0
			sleep 20;
			// look for local unit to get serverID
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
		};
	};
};
true
