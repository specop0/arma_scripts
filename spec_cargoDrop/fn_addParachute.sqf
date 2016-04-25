/*
    Author: SpecOp0
    
    Description:
    Adds Parachute to given item (optional with delay).
    
    Object will then land safely and adjusted if it is
    stuck in a tree (will spawn in a scheduled environment).
    
    Parameter(s):
    0: OBJECT - dropped object
    1 (Optional): NUMBER - delay after deploying parachute (default: 0)
    
    Returns:
    true
*/

_this spawn {
    params [ ["_object",objNull,[objNull]], ["_delay",0,[0]] ];
    if(!isNull _object) then {
        sleep _delay;
        // test if parachute is still needed after delay
        if !(getPosATL _object select 2 <= 0.01) then {
            // spawn and attach parachute (createVehicle position has offset from current position)
            private _objectCurPos = getPosASL _object;
            private _objectOldPos = getPosASL _object;
            private _parachute =  createVehicle ["B_Parachute_02_F", getPosATL _object, [], 0, "NONE"];
            _parachute setPosASL _objectOldPos;
            _object attachTo [_parachute, [0,0,1]];
            
            // sleep to let parachute deploy safely
            sleep 20;
            waitUntil{
                _objectCurPos = getPosASL _object;
                sleep 5;
                // check if parachute is still attached (object still in the air)
                if (isNull _parachute) then {
                    true
                } else {
                    // check if parachute / object is stuck in tree
                    if (_objectOldPos distance _objectCurPos < 2) then {
                        detach _object;
                        deleteVehicle _parachute;
                        true
                    } else {
                        _objectOldPos = _objectCurPos;
                        false
                    };
                };
            };
        };
    };
};
true
