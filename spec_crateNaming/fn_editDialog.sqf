/*
    Author: SpecOp0

    Description:
    Edit the display name of the crate by requesting user input.

    Parameter(s):
    0 - OBJECT: The crate to change the display name for.

    Return Value:
    None

    Example:
    [_crate] call Spec_crateNaming_fnc_editDialog;
*/
#include "script_component.hpp"

params [ ["_crate",objNull,[objNull]] ];

if (isNull _crate) exitWith {
    hint "Error: No Crate found.";
};

disableSerialization;

// get display name defined by user or default one
private _userDisplayName = _crate getVariable [QGVAR(displayName), ""];
if (_userDisplayName isEqualTo "") then {
    _userDisplayName = getText (configfile >> "CfgVehicles" >> (typeOf _crate) >> "displayName");
};

private _dialogResult =
[
    "Kiste umbennen",
    [
        ["Name", "", _userDisplayName, true]
    ]
] call Ares_fnc_ShowChooseDialog;

if (_dialogResult isEqualTo []) exitWith {};

// parse result
_dialogResult params ["_newDisplayName"];
if (([_newDisplayName] call CBA_fnc_removeWhitespace) isEqualTo "") then {
    _newDisplayName = "";
};

// save the display name
_crate setVariable [QGVAR(displayName), _newDisplayName, true];

true
