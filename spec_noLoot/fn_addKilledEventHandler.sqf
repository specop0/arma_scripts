/*
    Author: SpecOp0

    Description:
    Adds a killed event handler to given unit to remove loot.
    Removes content which a player may want to loot:
    - magazines
    - medical items
    - gps

    Parameter(s):
    0: OBJECT - unit to add the event handler to

    Example:
    [player] call Spec_noLoot_fnc_addKilledEventHandler;

    Returns:
    true
*/

params [ ["_unit",objNull,[objNull]] ];

if (!isNull _unit && !isPlayer _unit) then {
    _unit addEventHandler ["Killed",{
        params ["_unit", "_killer"];
        if (!isPlayer _unit) then {
            removeAllItems _unit;
            removeAllAssignedItems _unit;
            // remove all magazines
            {
                _unit removeMagazine _x;
            } forEach magazines _unit;
        };
    }];
};
true
