/*
	Author: SpecOp0
	
	Description:
	AddsActions (ACE interaction) to object which is a training station for Mk6 Mortar (ACE, 3CB BAF).
	- Spawn Crate with Mortar
	- Spawn Crate with Mortar Ammo
	- Delete Crates
	- Assign player as FAC (see Spec_mortar_fnc_addActions)
	- Unassign player as FAC
	
	Parameter(s):
	0: OBJECT - object which is a training station
	
	Returns:
	true
*/
private _parameterCorrect =  params [ ["_object",objNull,[objNull]] ];

if(_parameterCorrect && hasInterface) then {
	private _crateMortarName = "Spawn Moerser";
	private _crateMortarAmmoName = "Spawn Moerser Munition";
	private _crateDeleteName = "Loesche Kisten";
	private _addActionsName = "Ich bin FAC";
	private _removeActionsName ="Ich bin kein FAC";
	// mortar crate
	[_object,0,["ACE_MainActions","Spec_action_mortar_crateMortar"]] call ace_interact_menu_fnc_removeActionFromObject;
	private _actionCrateMortar = ["Spec_action_mortar_crateMortar", _crateMortarName, "", {
		params ["_target","_caller"];
		private _crate = "UK3CB_BAF_Static_Weapons_L16_Box" createVehicle getPos _target;
		_crate addItemCargoGlobal ["ACE_MapTools",3];
		_crate addItemCargoGlobal ["ACE_microDAGR",3];
		_crate addItemCargoGlobal ["ACE_Vector",3];
		_crate addBackpackCargoGlobal ["tf_rt1523g_big",2];
	}, {true}] call ace_interact_menu_fnc_createAction;
	[_object,0,["ACE_MainActions"], _actionCrateMortar] call ace_interact_menu_fnc_addActionToObject;
	// mortar ammo crate
	[_object,0,["ACE_MainActions","Spec_action_mortar_crateMortarAmmo"]] call ace_interact_menu_fnc_removeActionFromObject;
	private _actionCrateMortar = ["Spec_action_mortar_crateMortarAmmo", _crateMortarAmmoName, "", {
		params ["_target","_caller"];
		"UK3CB_BAF_Static_Weapons_L16_ammo" createVehicle getPos _target;
	}, {true}] call ace_interact_menu_fnc_createAction;
	[_object,0,["ACE_MainActions"], _actionCrateMortar] call ace_interact_menu_fnc_addActionToObject;
	// delete crates
	[_object,0,["ACE_MainActions","Spec_action_mortar_deleteCrates"]] call ace_interact_menu_fnc_removeActionFromObject;
	private _actionDeleteCrates = ["Spec_action_mortar_deleteCrates", _crateDeleteName, "", {
		params ["_target","_caller"];
		private _crates = nearestObjects [getPos _caller, ["UK3CB_BAF_Static_Weapons_L16_Box","UK3CB_BAF_Static_Weapons_L16_ammo"], 50];
		{
			if(!isNull _x) then {
				deleteVehicle _x;
			};
		} forEach _crates;
	}, {true}] call ace_interact_menu_fnc_createAction;
	[_object,0,["ACE_MainActions"], _actionDeleteCrates] call ace_interact_menu_fnc_addActionToObject;
	// add actions to player
	[_object,0,["ACE_MainActions","Spec_action_mortar_addActions"]] call ace_interact_menu_fnc_removeActionFromObject;
	private _actionAddActions = ["Spec_action_mortar_addActions", _addActionsName, "", {
		params ["_target","_caller"];
		_caller call Spec_mortar_fnc_addActions;
	}, {true}] call ace_interact_menu_fnc_createAction;
	[_object,0,["ACE_MainActions"], _actionAddActions] call ace_interact_menu_fnc_addActionToObject;
	// remove actions from player
	[_object,0,["ACE_MainActions","Spec_action_mortar_removeActions"]] call ace_interact_menu_fnc_removeActionFromObject;
	private _actionAddActions = ["Spec_action_mortar_removeActions", _removeActionsName, "", {
		params ["_target","_caller"];
		[_caller,1,["ACE_SelfActions","Spec_action_mortar_newTarget"]] call ace_interact_menu_fnc_removeActionFromObject;
		[_caller,1,["ACE_SelfActions","Spec_action_mortar_liner"]] call ace_interact_menu_fnc_removeActionFromObject;
		[_caller,1,["ACE_SelfActions","Spec_action_mortar_tip"]] call ace_interact_menu_fnc_removeActionFromObject;
		[_caller,1,["ACE_SelfActions","Spec_action_mortar_result"]] call ace_interact_menu_fnc_removeActionFromObject;
		private _mortarTarget = _caller getVariable ["Spec_var_mortar_target",objNull];
		if(!isNull _mortarTarget) then {
			deleteVehicle _mortarTarget;
			_caller setVariable ["Spec_var_mortar_target",objNull];
		};
	}, {true}] call ace_interact_menu_fnc_createAction;
	[_object,0,["ACE_MainActions"], _actionAddActions] call ace_interact_menu_fnc_addActionToObject;
};
true
