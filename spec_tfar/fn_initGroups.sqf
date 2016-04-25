/*
    Author: SpecOp0

    Description:
    Initializes for a unit variables needed for setting TFAR frequencies
    and set names for BFT system.
    Variables are chosen based on variable "Spec_var_TFARgroup".
    
    Example in init-field add: this setVariable ["Spec_var_TFARgroup",0];
    
    Parameter(s):
    0: OBJECT - unit/player which variables need to be initialized

    Returns:
    true
*/
private _parameterCorrect = params [["_unitName",objNull,[objNull]]];

if(_parameterCorrect) then {
    private _groupID = _unitName getVariable ["Spec_var_TFARgroup", 0];
    private ["_swFreq", "_lrFreq", "_callsign", "_BFTicon", "_BFTremarks"];
    _BFTicon = "b_inf";
    _BFTremarks = name _unitName;
    
    switch _groupID do {
        case 0 : {
            _swFreq = ["100"];
            _lrFreq = ["30","31","41","42","43","51","61"];
            _callsign = "Gelb";
            _BFTicon = "b_hq";
        };
        case 1 : {
            _swFreq = ["111","110","112","113","114"];
            _lrFreq = ["31","30"];
            _callsign = "Gruen";
        };
        case 2 : {
            _swFreq = ["112","110","111","113","114"];
            _lrFreq = ["31","30"];
            _callsign = "Schwarz";
        };
        case 3 : {
            _swFreq = ["113","110","111","112","114"];
            _lrFreq = ["31","30"];
            _callsign = "Blau";
        };
        case 4 : {
            _swFreq = ["114","110","111","112","113"];
            _lrFreq = ["31","30"];
            _callsign = "Rot";
        };
        case 5 : {
            _swFreq = ["141","140"];
            _lrFreq = ["41","30","31","42","43","51","61"];
            _callsign = "Weiss";
            _BFTicon = "b_med";
        };
        case 6 : {
            _swFreq = ["142","140"];
            _lrFreq = ["42","30","31","41","43","51","61"];
            _callsign = "Adler";
            _BFTicon = "b_plane";
        };
        case 7 : {
            _swFreq = ["143","140"];
            _lrFreq = ["43","30","31","41","42","51","61"];
            _callsign = "Silber - 1";
            _BFTicon = "b_service";
        };
        case 8 : {
            _swFreq = ["143","140"];
            _lrFreq = ["43","30","31","41","42","51","61"];
            _callsign = "Silber - 2";
            _BFTicon = "b_service";
        };
        case 9 : {
            _swFreq = ["143","140"];
            _lrFreq = ["43","30","31","41","42","51","61"];
            _callsign = "Silber - 3";
            _BFTicon = "b_service";
        };
        case 10 : {
            _swFreq = ["151"];
            _lrFreq = ["51","30","31","41","42","43","61"];
            _callsign = "Gold";
            _BFTicon = "b_recon";
        };
        case 11 : {
            _swFreq = ["161"];
            _lrFreq = ["61","30","31","41","42","43","51"];
            _callsign = "Bronze - 1";
            _BFTicon = "b_armor";
        };
        case 12 : {
            _swFreq = ["161"];
            _lrFreq = ["61","30","31","41","42","43","51"];
            _callsign = "Bronze - 2";
            _BFTicon = "b_armor";
        };
        default {
            _swFreq = ["100"];
            _lrFreq = ["30"];
            _callsign = "Default";
        };
    };
    // set frequency variables
    _unitName setVariable ["Spec_var_swFreq", _swFreq];
    _unitName setVariable ["Spec_var_lrFreq", _lrFreq];

    // BFT Settings
    _unitName setGroupIdGlobal [_callsign];
    _unitName setVariable ["BG_BFT_groupId", _callsign, true];
    _unitName setVariable ["BG_BFT_icon", _BFTicon, true]; 
    _unitName setVariable ["BG_BFT_remarks", _BFTremarks, true];
    if(count _swFreq > 0) then {
        _unitName setVariable ["BG_BFT_radioSR", (_swFreq select 0), true];
    };
    if(count _lrFreq > 0) then {
        _unitName setVariable ["BG_BFT_radioLR", (_lrFreq select 0), true];
    };
    
};
true
