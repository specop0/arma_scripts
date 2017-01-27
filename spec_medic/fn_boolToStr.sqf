/*
    Author: SpecOp0
    
    Description:
    Converts a boolean value to a string representation.
    
    Parameter(s):
    0: BOOL - the boolean value
    
    Returns:
    STRING - the string representation of given bool value.
*/

params [ ["_bool",false,[true]] ];
private _returnValue = if(_bool) then { "Ja" } else { "Nein" };
_returnValue
