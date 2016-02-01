/*
	Author: SpecOp0

	Description:
	Adds Action to (hardcoded) helicopter to allow retransfer of unit.
	Positions are saved in helicopter (from heli_medevac script).

	Parameter(s):
	0: -

	Returns:
	true
*/

comment "Edit these Entries";

comment "Name of Helicopter";
private _helicopter = weiss;

comment "Name of addAction";
private _addActionFlyback = "Fliege Sie uns zurueck an die Front.";

if(isNil "_helicopter" || {isNull _helicopter}) then {
	hint format ["Script Error: Helicopter '%1' not found", str _helicopter];
} else {
	if(hasInterface) then {
		// add ace action for retransfering units to frontline
		[_helicopter,1,["ACE_SelfActions","Spec_action_medevacRetransfer"]] call ace_interact_menu_fnc_removeActionFromObject;
		private _action = ["Spec_action_medevacRetransfer", _addActionFlyback, "", {
			params ["_target","_caller"];
			private _landingPadPos = _target getVariable ["Spec_var_landingPadPos", position _target];
			private _landingPadBasePos =  _target getVariable ["Spec_var_landingPadBasePos", position _target];
			private _crewGroup = group _target;
			private _wp0 = _crewGroup addWaypoint [_landingPadPos,0];
			_wp0 setWaypointType "TR UNLOAD";
			private _wp1 = _crewGroup addWaypoint [_landingPadBasePos,0];
			_wp1 setWaypointType "TR UNLOAD";
		}, {true}] call ace_interact_menu_fnc_createAction;
		[_helicopter,1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	};
};
true
