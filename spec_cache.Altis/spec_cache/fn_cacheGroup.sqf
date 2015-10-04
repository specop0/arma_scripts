_returnValue = false;
if(isServer) then {
	_parameterCorrect = params [["_unitToCache",objNull],["_noGroupToCache",-1,[0]]];
		if(_parameterCorrect) then {
			if(_unitToCache isKindof "AllVehicles") then {
				_noGroupToCacheRounded = round _noGroupToCache;
				if(_noGroupToCache == _noGroupToCacheRounded && _noGroupToCache >= 0) then {
					if(isNil "specCachedGroups") then {
						specCachedGroups = [];
					};
					_sizeCachedGroups = count specCachedGroups;
					_noGroupToCacheAvailable = false;
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
						specCachedGroups set [_noGroupToCache, _cachedGroupArray];
						_returnValue = true;
					} else {
						["Wrong usage: Cached Group number (%1) is already used",_noGroupToCache] call BIS_fnc_error;
					};
				} else {
					["Wrong parameter: expected positive Integer or 0 got (%1)",_noGroupToCache] call BIS_fnc_error;
				};
			} else {
				"Wrong parameter: unit does not inherit from AllVehicles" call BIS_fnc_error;
			};
	} else {
		"Wrong parameter: expected [unit,number]" call BIS_fnc_error;
	};
};
_returnValue
