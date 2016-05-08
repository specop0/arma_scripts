/*
    Author: SpecOp0
    
    Description:
    Adds KeyHandler to changes offset to (locally) attached object of unit/player if arrow key are pressed.
    see const.hpp to disable KeyHandler
    
    Parameter(s):
    -
    
    Returns:
    NUMBER - id of added displayEventHandler (-1 if nothing added)
*/
#include "const.hpp"

private _eventHandlerID = -1;
if(hasInterface && SPEC_BUILD_USE_KEY_HANDLER) then {
    private _display = findDisplay 46;
    _eventHandlerID = _display displayAddEventHandler ["KeyDown","_this call Spec_construct_fnc_changeOffsetKeyHandler"];
};
_eventHandlerID
