/*
    Author: SpecOp0
    
    Description:
    Tests if in bounding box of object are any man (alive).
    
    Parameter(s):
    0: OBJECT - object to check if bounding box is free
    
    Returns:
    BOOL - true if bounding box is free
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_object",objNull,[objNull]] ];
private _boundBoxIsClear = false;

scopeName "boundingBoxIsClearScript";
if (_parameterCorrect) then {
    private _boundingBox = boundingBoxReal _object;
    private _posASL = getPosASL _object;
    private _boundingBoxFirst = _boundingBox select 0;
    private _boundingBoxSecond = _boundingBox select 1;
    
    private _radius = (-(_boundingBoxFirst select 0) max -(_boundingBoxFirst select 1))
        max
        ((_boundingBoxSecond select 0) max (_boundingBoxSecond select 1));
    
    private _nearestMan = nearestObjects [(_object modelToWorld [0,0,0]),["CAManBase"],_radius + SPEC_BOUNDING_BOX_EXTRA_RADIUS];

    _boundBoxIsClear = true;
    private _modelPosition = [0,0,0];
    //private _boundingBoxModel = boundingBoxReal player;
    //private _boundingBoxModelFirst = [-0.8,-1.15,-0.1];
    //private _boundingBOxModelSecond = [0.8,1.05,1.9];
    {
        if (!isNull _x && {alive _x && _x != player}) then {
            _modelPosition = _object worldToModel position _x;
            _boundBoxIsClear = ((_modelPosition select 0) - 0.8) > (_boundingBoxSecond select 0)
                || ((_modelPosition select 0) + 0.8) < (_boundingBoxFirst select 0)
                || ((_modelPosition select 1) + 1.05) < (_boundingBoxFirst select 1)
                || ((_modelPosition select 1) - 1.15) > (_boundingBoxSecond select 1);
            if !(_boundBoxIsClear) then {
                false breakOut "boundingBoxIsClearScript";
            };
        };
    } foreach _nearestMan;
};
_boundBoxIsClear
