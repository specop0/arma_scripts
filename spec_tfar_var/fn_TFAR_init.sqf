// TFR mod configuration
#include "\task_force_radio\functions\common.sqf";

TF_give_personal_radio_to_regular_soldier = true; //inverted module setting
tf_no_auto_long_range_radio = true; //inverted module setting
TF_terrain_interception_coefficient = 7;
tf_radio_channel_name = "LaufendeMission";
tf_radio_channel_password = "130";
if(isServer) then {
	tf_same_sw_frequencies_for_side = true;
	tf_same_lr_frequencies_for_side = true;
};

if(hasInterface) then {
	["Spec_setTFAR", "OnRadiosReceived", Spec_fnc_setTFAR, player] call TFAR_fnc_addEventHandler;
};
