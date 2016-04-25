/*
    Author: SpecOp0
    
    Description:
    Computes elevation for Mk6 Mortar (ACE, 3CB BAF) with given velocity.
    
    Parameter(s):
    0: NUMBER - distance between mortar an target (in m)
    1: NUMBER - altitude difference (in m)
    1: NUMBER - velocity of round
    
    Returns:
    0: NUMBER - elevation (in mil)
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_distance",0.0,[0.0]], ["_altitudeDiff",0.0,[0.0]], ["_velocity",0.0,[0.0]] ];
private _returnValue = 0;
if(_parameterCorrect) then {
    private _root = _velocity ^ 4.0 - GRAVITATION_CONST * (GRAVITATION_CONST * (_distance ^ 2.0) + 2.0 * _altitudeDiff * (_velocity ^ 2.0));
    if(_root >= 0) then {
        _returnValue = (GRAVITATION_CONST * _distance) atan2 (_velocity ^ 2.0 - sqrt _root);
        _returnValue = _returnValue DEGREE_TO_MIL;
    };
};
_returnValue
