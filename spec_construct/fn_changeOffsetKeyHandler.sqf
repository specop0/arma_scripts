/*
    Author: SpecOp0
    
    Description:
    Changes offset to (locally) attached object of unit/player if arrow key are pressed.
    Increase/Decrease Height/Distance (see const.hpp)
    
    Parameter(s):
    1: NUMBER - keyboard code
    
    Returns:
    BOOL - true if keyboard code was handled
*/
#include "const.hpp"
#define DIK_RETURN 28
#define DIK_NUMPADENTER 156

#define DIK_UPARROW 200
#define DIK_DOWNARROW 208
#define DIK_LEFTARROW 203
#define DIK_RIGHTARROW 205

private _handled = false;
if !(isNull (player getVariable [SPEC_VAR_ATTACHED_OBJECT,objNull])) then {
    params ["_control","_keyboardCode"];
    switch (_keyboardCode) do {
        // up arrow -> height++
        case DIK_UPARROW : {
            [player,SPEC_VAR_OFFSET_INCREASE,SPEC_VAR_OFFSET_TYPE_HEIGHT] call SPEC_FNC_OFFSET_CONSTRUCTION;
            _handled = true;
        };
        // down arrow -> height--
        case DIK_DOWNARROW : {
            [player,SPEC_VAR_OFFSET_DECREASE,SPEC_VAR_OFFSET_TYPE_HEIGHT] call SPEC_FNC_OFFSET_CONSTRUCTION;
            _handled = true;
        };
        // left arrow -> distance++
        case DIK_LEFTARROW : {
            [player,SPEC_VAR_OFFSET_INCREASE,SPEC_VAR_OFFSET_TYPE_DISTANCE] call SPEC_FNC_OFFSET_CONSTRUCTION;
            _handled = true;
        };
        // right arrow -> distance--
        case DIK_RIGHTARROW : {
            [player,SPEC_VAR_OFFSET_DECREASE,SPEC_VAR_OFFSET_TYPE_DISTANCE] call SPEC_FNC_OFFSET_CONSTRUCTION;
            _handled = true;
        };
    };
};
_handled
