/*
	Author: SpecOp0

	Description:
	Initializes a list with the serverID on the server.
	(TODO add HeadlessClients)

	Returns:
	true
*/

if(isServer) then {
	if(isNil "Spec_var_ownerList") then {
		Spec_var_ownerList = [];
	};
	if(count Spec_var_ownerList == 0) then {
		private ["_scriptHandle"];
		_scriptHandle = [] spawn {
			// sleep because otherwise the serverID is 0
			sleep 20;
			// look for local unit to get serverID
			private ["_serverID"];
			_serverID = 0;
			{
				if(local _x) then {
					_serverID = owner _x;
					if(_serverID != 0) exitWith {};
				};
			} forEach allUnits;
			if(_serverID != 0) then {
				Spec_var_ownerList pushBack _serverID;
			} else {
				// serverID seems to be 2 (always?)
				Spec_var_ownerList pushBack 2;
			};
			// TODO pushback headless client list
		};
	};
};
true
