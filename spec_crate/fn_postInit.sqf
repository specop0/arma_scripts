/*
    Author: Spec

    Description:
    Runs at post init and fills the crates of given type with the content.
    For example, fills the TTT default ammunition box (BW) with the defined types.

    Parameter(s):
    -

    Returns:
    true
*/

#define PRIMARY_AMMO "30Rnd_556x45_Stanag"
#define MG_AMMO "CUP_100Rnd_TE4_LRT4_White_Tracer_762x51_Belt_M"
#define LMG_AMMO "CUP_200Rnd_TE4_Red_Tracer_556x45_M249"
#define SECONDARY_AMMO "CUP_10Rnd_9x19_Compact"

#define UGL_SMOKE_WHITE "1Rnd_Smoke_Grenade_shell"
#define UGL_SMOKE_RED "1Rnd_SmokeRed_Grenade_shell"
#define UGL_HE "1Rnd_HE_Grenade_shell"

if(isServer) then {
    {
        if(_x isKindOf "ReammoBox_F") then {
            switch (typeOf _x) do {
                // medic
                case ("TTT_Logistik_Medic_Bw") : {
                    [_x,
                        [
                            ["ACE_fieldDressing", 125],
                            ["ACE_packingBandage", 50],
                            ["ACE_elasticBandage", 25],
                            ["ACE_quikclot", 25],
                            ["ACE_tourniquet", 10],
                            ["ACE_salineIV", 25],
                            ["ACE_salineIV_500", 20],
                            ["ACE_morphine", 15],
                            ["ACE_epinephrine", 15],
                            ["ACE_atropine", 10],
                            ["ACE_personalAidKit", 15],
                            ["ACE_surgicalKit", 15],
                            ["ACE_bodyBag", 10]
                        ]
                    ] call Spec_crate_fnc_filler;
                };
                // ammunition
                case ("TTT_Logistik_Standardmunition_Bw") : {
                    [_x,
                        [
                            [PRIMARY_AMMO,34],
                            [MG_AMMO,4],
                            [LMG_AMMO,6],
                            [SECONDARY_AMMO,8],
                            [UGL_SMOKE_WHITE,6],
                            [UGL_SMOKE_RED,6],
                            [UGL_HE,12]
                        ]
                    ] call Spec_crate_fnc_filler;
                };
                // at and aa launcher
                case ("TTT_Logistik_Werfer_Bw") : {
                    [_x,
                        [
                            ["CUP_launch_MAAWS", 2],
                            ["CUP_MAAWS_HEAT_M", 2],
                            ["CUP_optic_MAAWS_Scope", 2],
                            ["rhs_weap_fim92", 2],
                            ["rhs_fim92_mag", 2]
                        ]
                    ] call Spec_crate_fnc_filler;
                };
                // grenades
                case ("TTT_Logistik_Granaten_Bw") : {
                    [_x,
                        [
                            ["SmokeShell",36],
                            ["SmokeShellGreen",12],
                            ["SmokeShellRed",12],
                            ["SmokeShellPurple",12],
                            ["ACE_M84",12],
                            ["ACE_IR_Strobe_Item",12]
                        ]
                    ] call Spec_crate_fnc_filler;
                };
                // enemy crate with some random values
                case ("CUP_TKBasicWeapons_EP1") : {
                    [_x, [
                        ["CUP_30Rnd_556x45_Stanag", floor(random(15)) + 60],
                        ["CUP_100Rnd_TE4_LRT4_Red_Tracer_762x51_Belt_M", 14 + floor(random(4))]
                    ]] call Spec_crate_fnc_filler;
                };
            };
        };
    } forEach vehicles;
};