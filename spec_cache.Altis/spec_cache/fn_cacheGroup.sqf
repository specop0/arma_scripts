local _returnValue = false;
if(isServer) then {
	local _parameterCorrect = params [["_unitToCache",objNull],["_noGroupToCache",-1,[0]]];
		if(_parameterCorrect) then {
			if(_unitToCache isKindof "Man") then {
				local _noGroupToCacheRounded = round _noGroupToCache;
				if(_noGroupToCache == _noGroupToCacheRounded && _noGroupToCache >= 0) then {
					if(isNil "Spec_var_cachedGroups") then {
						Spec_var_cachedGroups = [];
					};
					local _sizeCachedGroups = count Spec_var_cachedGroups;
					local _noGroupToCacheAvailable = false;
					if(_noGroupToCache < _sizeCachedGroups) then {
						if( count (Spec_var_cachedGroups select _noGroupToCache) == 0) then {
							Spec_var_cachedGroups set [_noGroupToCache, 1];
							_noGroupToCacheAvailable = true;
						};
					} else {
						_noGroupToCacheAvailable = true;
						while {_noGroupToCache >= _sizeCachedGroups} do {
							Spec_var_cachedGroups pushBack [];
							_sizeCachedGroups = _sizeCachedGroups + 1;
						};
						Spec_var_cachedGroups set [_noGroupToCache, 1];
					};
					if(_noGroupToCacheAvailable) then {
						_cachedGroupArray = [_unitToCache, _noGroupToCache] call Spec_fnc_cacheGroup_data;
						if(count _cachedGroupArray == 5) then {
							Spec_var_cachedGroups set [_noGroupToCache, _cachedGroupArray];
							_returnValue = true;
						} else {
							"Script Error: Array from unit did not save enough information" call BIS_fnc_error;
						};
					} else {
						["Wrong usage: Cached Group number (%1) is already used",_noGroupToCache] call BIS_fnc_error;
					};
				} else {
					["Wrong parameter: expected positive Integer or 0 got (%1)",_noGroupToCache] call BIS_fnc_error;
				};
			} else {
				"Wrong parameter: unit does not inherit from Man (for vehicles: spawn empty vehicle and cache crew with getin waypoint)" call BIS_fnc_error;
			};
	} else {
		"Wrong parameter: expected [unit,number]" call BIS_fnc_error;
	};
};
_returnValue
