/*
	Author: SpecOp0

	Description:
	If player uses ACE Action he can click on the map and on clicked position
	a marker called Spec_marker_LZ (text 'LZ Alpha') will be placed.
	
	This placed marker can be used for the Helicopter Taxi script.

	Parameter(s):
	-

	Returns:
	true
*/

if(hasInterface) then {
	onMapSingleClick {
		if(player getVariable ["Spec_var_selectLZ", false]) then {
			deleteMarker "Spec_marker_LZ";
			private _marker = createMarker ["Spec_marker_LZ", [0,0]];
			_marker setMarkerPos _pos;
			_marker setMarkerShape "ICON";
			_marker setMarkerType "hd_pickup";
			_marker setMarkerText "LZ Alpha";
			_marker setMarkerColor "ColorBLUFOR";
			_marker setMarkerSize [1,1];
			player setVariable ["Spec_var_selectLZ", false];
		};
	};

	[player,1,["ACE_SelfActions","Spec_action_moveMarkerLZ"]] call ace_interact_menu_fnc_removeActionFromObject;
	_action = ["Spec_action_moveMarkerLZ", "Bewege LZ", "", {(_this select 0) setVariable ["Spec_var_selectLZ", true]}, {true}] call ace_interact_menu_fnc_createAction;
	[player,1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};