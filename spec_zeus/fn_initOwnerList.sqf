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
			};
			// TODO pushback headless client list
		};
	};
};
true