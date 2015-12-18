/*
	Author: SpecOp0

	Description:
	Chooses a owner ID to assign a group to.
	Possible IDs are in a list generated at mission start.

	In consecutive execution the next entry is chosen (or first if we shoot over).
	Race condition to get and modify the index variable (as a result an entry
	could be chosen twice/multiple times before increasing).

	Returns:
	NUMBER - owner ID (default value: 2)
*/
private _returnValue = 2;
if(isServer) then {
	if(!isNil "Spec_var_ownerList") then {
		private _size = count Spec_var_ownerList;
		// if multiple entries choose according to Spec_var_ownerIndex
		if(_size > 1) then {
			if(isNil "Spec_var_ownerIndex") then{
				// TODO AI not on server? then index = 1 if _size > 1
				Spec_var_ownerIndex = 0;
			};
			// race condition: copy and increase variable or set 0
			private _i = Spec_var_ownerIndex;
			if((_i + 1) < _size) then {
				Spec_var_ownerIndex = _i + 1;
			} else {
				// TODO AI not on server? then index = 1 if _size > 1
				Spec_var_ownerIndex = 0;
			};
			_returnValue = Spec_var_ownerList select _i;
		} else {
			// if only one entry exists use this
			if(_size == 1) then {
				_returnValue = Spec_var_ownerList select 0;
			};
		};
	};
} else {
	"Wrong Usage: This function should only be called on the server." call BIS_fnc_error;
};
_returnValue
