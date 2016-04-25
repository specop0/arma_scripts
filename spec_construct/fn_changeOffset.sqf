/*
    Author: SpecOp0
    
    Description:
    Changes offset to (locally) attached object of unit/player.
    Increase/Decrease Height/Distance (see const.hpp)
    
    Parameter(s):
    0: OBJECT - unit/player who wants to construct something
    1: NUMBER - increase or decrease offset (1 or -1 or see const.hpp)
    2: STRING - change offset of distance or height (see const.hpp)
    
    Returns:
    true
*/
#include "const.hpp"

private _parameterCorrect = params [
    ["_unit",objNull,[objNull]],
    ["_change",1,[0]],
    ["_changeTypeString","",[""]]
];

if(_parameterCorrect) then {
    private _attachedObject = _unit getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull];
    if(!isNull _attachedObject && _change in [SPEC_VAR_OFFSET_INCREASE,SPEC_VAR_OFFSET_DECREASE,0]) then {
        detach _attachedObject;

        private _heightOffset = _unit getVariable [SPEC_VAR_OFFSET_HEIGHT,0];
        if(_changeTypeString == SPEC_VAR_OFFSET_TYPE_HEIGHT) then {
            _heightOffset = _heightOffset + _change * SPEC_BUILD_OFFSET_MULTI;
            _unit setVariable [SPEC_VAR_OFFSET_HEIGHT,_heightOffset];
        };
        
        private _distanceOffset = _unit getVariable [SPEC_VAR_OFFSET_DISTANCE,0];
        if(_changeTypeString == SPEC_VAR_OFFSET_TYPE_DISTANCE) then {
            _distanceOffset = _distanceOffset + _change * SPEC_BUILD_OFFSET_MULTI;
            _unit setVariable [SPEC_VAR_OFFSET_DISTANCE,_distanceOffset];
        };
        
        private _boundingBox = boundingBoxReal _attachedObject;
        private _width = ((_boundingBox select 1) select 1) + SPEC_ATTACHED_OBJECT_EXTRA_DISTANCE;
        private _height = -((_boundingBox select 0) select 2);
        
        _attachedObject attachTo [_unit, [0,(_width + _distanceOffset),(_height + _heightOffset)]];
    };
};
true
