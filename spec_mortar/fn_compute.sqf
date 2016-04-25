/*
    Author: SpecOp0
    
    Description:
    Computes distance, azimuth and elevation for Mk6 Mortar (ACE, 3CB BAF).
    
    Parameter(s):
    0: OBJECT - target for Mk6 Mortar
    1: OBJECT - player (near MK6 Mortar)
    
    Returns:
    0: NUMBER - distance (in m)
    1: NUMBER - azimuth (in mil)
    2: NUMBER - elevation for charge 0 (in mil)
    3: NUMBER - elevation for charge 1 (in mil)
    4: NUMBER - elevation for charge 2 (in mil)
*/
#include "const.hpp"

private _parameterCorrect = params [ ["_target",objNull,[objNull]], ["_caller",objNull,[objNull]] ];
private _returnValue = [0,0,0,1,2];
if(_parameterCorrect && {!isNull _target}) then {
    // distance
    private _xTarget = getPosASL _target select 0;
    private _yTarget = getPosASL _target select 1;
    private _xCaller = getPosASL _caller select 0;
    private _yCaller = getPosASL _caller select 1;
    private _distance = [_xCaller,_yCaller] distance [_xTarget,_yTarget];
    _returnValue set [0, _distance];
    // direction
    // v1.55 private _azimuth = _caller getDir _target;
    private _azimuth = (_xTarget - _xCaller) atan2 (_yTarget - _yCaller);
    _azimuth = _azimuth DEGREE_TO_MIL;
    if(_azimuth < 0.0) then {
        _azimuth = _azimuth + 360 DEGREE_TO_MIL;
    };
    _returnValue set [1, round(_azimuth)];
    // altitude difference (not working with formula)
    private _altitudeDiff = ((getPosASL _target select 2) - (getPosASL _caller select 2));
    _altitudeDiff = 0.0;
    // elevation
    private _velocities = [70.0,140.0,200.0];
    {
        private _elevation = [_distance,_altitudeDiff,_x] call Spec_mortar_fnc_computeData;
        _returnValue set [_forEachIndex + 2, _elevation];
    } forEach _velocities;
};
_returnValue
