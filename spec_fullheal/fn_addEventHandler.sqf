/*
    Author: SpecOp0
    
    Description:
    Adds a full heal event (handler) to the given unit.
    
    If the unit gets into a vehicle which provides a full heal,
    the player will be healed with an ACE personal aid kit
    and some medical material is placed in the backpack (if not already exists).
    
    Parameter(s):
    0: OBJECT - unit to assign the full heal event handler to
    
    Returns:
    true
*/
#define FULL_HEAL_BOOL_STRING "isFullHealVehicle"

params [ ["_unit",objNull,[objNull]] ];

_unit addEventHandler ["GetInMan", {
    params ["_unit", "_position", "_vehicle", "_turret"];
    if(_vehicle getVariable [FULL_HEAL_BOOL_STRING, false]) then {
        private _scriptHandle = [_unit] spawn {
            params ["_unit"];
            playSound "fullheal";
            // sleep before healing - else the player bugs into the air and takes damage multiple time
            sleep 2;
            [_unit,_unit] call ACE_medical_fnc_treatmentAdvanced_fullHeal;
            // add medical items
            private _expectedItemAndCount = [
                ["ACE_fieldDressing", 9],
                ["ACE_packingBandage", 3],
                ["ACE_tourniquet", 1]
            ];
            // only look if items are present in the backpack
            private _itemNamesAndCount = getItemCargo backpackContainer _unit;
            private ["_index", "_count"];
            {
                _x params ["_itemName", "_itemCount"];
                _index = (_itemNamesAndCount select 0) find _itemName;
                _count = 0;
                if(_index != -1) then {
                    _count = (_itemNamesAndCount select 1) select _index;
                };
                if(_count < _itemCount) then {
                    for "_i" from 1 to (_itemCount - _count) do {
                        _unit addItemToBackpack _itemName;
                    };
                };
            } foreach _expectedItemAndCount;
        };
    };
}];
true
