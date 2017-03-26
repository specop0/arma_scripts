/*
    Author: Reimchen, ???

    Description:
    Fills a crate with given items.
    
    Parameter(s):
    0: OBJECT - The crate to fill.
    1: ARRAY - The items to fill (classname and count)
        0: STRING - The classname of a item
        1: NUMBER - The count of the item.

    Returns:
    true
*/

params [ ["_crate",objNull,[objNull]], ["_content",[],[[]]] ];

if(isServer) then {
    clearWeaponCargoGlobal _crate;
    clearMagazineCargoGlobal _crate;
    clearItemCargoGlobal _crate;
    clearBackpackCargoGlobal _crate;
    {
        _x params ["_objectType", "_objectCount"];
        if (_objectType isKindOf ["ItemCore", configFile >> "CfgWeapons"]) then {
            _crate addItemCargoGlobal _x;
        } else {
            if (isClass(configFile >> "CfgMagazines" >> _objectType)) then {
                _crate addMagazineCargoGlobal _x;
            } else {
                if (_objectType isKindOf "Bag_Base") then {
                    _crate addBackpackCargoGlobal _x;
                } else {
                    if (isClass(configFile >> "CfgWeapons" >> _objectType)) then {
                        _crate addWeaponCargoGlobal _x;
                    };
                };
            };
        };
    } forEach _content;
};
true
