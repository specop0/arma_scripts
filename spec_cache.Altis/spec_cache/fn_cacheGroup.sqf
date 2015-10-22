local _returnValue = false;
if(isServer) then {
	local _parameterCorrect = params [["_unitToCache",objNull],["_noGroupToCache",-1,[0]]];
		if(_parameterCorrect) then {
			if(_unitToCache isKindof "Man") then {
				local _noGroupToCacheRounded = round _noGroupToCache;
				if(_noGroupToCache == _noGroupToCacheRounded && _noGroupToCache >= 0) then {
					if(isNil "specCachedGroups") then {
						specCachedGroups = [];
					};
					local _sizeCachedGroups = count specCachedGroups;
					local _noGroupToCacheAvailable = false;
					if(_noGroupToCache < _sizeCachedGroups) then {
						if( count (specCachedGroups select _noGroupToCache) == 0) then {
							specCachedGroups set [_noGroupToCache, 1];
							_noGroupToCacheAvailable = true;
						};
					} else {
						_noGroupToCacheAvailable = true;
						while {_noGroupToCache >= _sizeCachedGroups} do {
							specCachedGroups pushBack [];
							_sizeCachedGroups = _sizeCachedGroups + 1;
						};
						specCachedGroups set [_noGroupToCache, 1];
					};
					if(_noGroupToCacheAvailable) then {
						_cachedGroupArray = [_unitToCache, _noGroupToCache] call Spec_fnc_cacheGroup_data;
						if(count _cachedGroupArray == 5) then {
							specCachedGroups set [_noGroupToCache, _cachedGroupArray];
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
