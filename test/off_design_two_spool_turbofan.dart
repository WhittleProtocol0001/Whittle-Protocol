import 'package:engine_id/architectures/with_map/turbofan_two_spool_Maps.dart';
import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';
import 'package:engine_id/compressor/compressor_IPCBetaPRMap.dart';
import 'package:engine_id/fan/fan_bypass_BetaPRMap.dart';
import 'package:engine_id/fan/fan_core_BetaPRMap.dart';
import 'package:engine_id/maps/FanBypassBetaPRMap.dart';
import 'package:engine_id/maps/FanCoreBetaPRMap.dart';
import 'package:engine_id/duct components/interstage_ducts_no_map.dart';
import 'package:engine_id/sas_components/coolingbleed_no_map.dart';
import 'package:engine_id/sas_components/cooling_mixing_no_map.dart';
import 'package:engine_id/maps/IPCBetaPRMap.dart';


void main() {

  test('2-spool TF', () {

    var altitude = 10668;
    var altitude_OD = 10668;
    var delP_inlet = 0.015;
    var delP_nzl = 0.0;
    var Mach_inlet_OD = 0.78;
    var mdot_OD = 140.9;
    var BPR_OD = 5.1;
    var LHV_OD = 43124000;
    var eta_34_OD = 0.995;
    var delP_D3 = 0.02;
    var delISA = 0;
    var delPCmb = 0.035;
    var FAR_OD_guess = 0.02;


    var zeta_dp = 0.7 ;
    var nc_turb_selected = 0.91;
    var zeta_dp_LPT = 0.75 ;
    var nc_turb_selected_LPT = 0.97;
    var TET_OD = 1357;
    var zeta_threshold = 0.3;
    var zeta_od_HPT = 0.70 ;
    var nc_turb_od_HPT = 0.9;
    var zeta_od_LPT = 0.5;
    var nc_turb_od_LPT = 0.9;
    var delP_D1 = 0.02;
    var delP_D2 = 0.015;
    var coolflow = 0.03;
    var Mach_BP_OD = 0.516;

    //double check input data

    var output = turbofan_2spl_Maps(altitude,10,150.74,1.84,1.84,1.45,13.57739498,1552,4.64,0.78,0.02,0.027,0.015,0.015,0.015,0.015,43124000,0.01,0.999,0.995,0.89,0.89,0.89,0.875,0.995,0.89,0.90,0.03,1,0.01,0.01,
      0.55,
      0.69, 1.01,
      0.78, 1.012,
      0.75, 1.01,
      0.73, 1.011,
      zeta_dp, nc_turb_selected,
      zeta_dp_LPT, nc_turb_selected_LPT,);


    var wc_map_FAN_BP = output[3][0];
    var eff_map_FAN_BP = output[3][1];
    var PR_map_FAN_BP = output[3][2];

    var wc_map_FAN_CORE = output[4][0];
    var PR_map_FAN_CORE = output[4][2];
    var eff_map_FAN_CORE = output[4][1];

    var wc_map_LPC = output[5][0];
    var eff_map_LPC = output[5][1];
    var PR_map_LPC = output[5][2];

    var wc_map_HPC = output[6][0];
    var eff_map_HPC = output[6][1];
    var PR_map_HPC = output[6][2];

    var wc_map_turb_HPT = output[7][0];
    var eff_map_turb_HPT = output[7][1];

    var wc_map_turb_LPT = output[8][0];
    var eff_map_turb_LPT = output[8][1];


    var Fn;
    var SFC;


    var Inlet_OD=subInlet_OD(altitude_OD, delISA, delP_inlet,Mach_inlet_OD,[output[15], output[16]],1, BPR_OD, mdot_OD);


    //Bypass
    var fan_bypass = FanBPBetaPR_OD(Inlet_OD[4],Inlet_OD[3],Inlet_OD[1], wc_map_FAN_BP, eff_map_FAN_BP, PR_map_FAN_BP, FanBypassBetaPrMap());


    var Bypass_duct = Duct(fan_bypass[5],fan_bypass[2],fan_bypass[6],delP_D3);

    var Nozzle_bypass=nozFan_OD(Bypass_duct[2], Bypass_duct[0], Bypass_duct[1], Mach_BP_OD, output[18]);


    //Core
    var fan_hub = FanCoreBetaPR_OD(Inlet_OD[4],Inlet_OD[3],Inlet_OD[0], wc_map_FAN_CORE, eff_map_FAN_CORE, PR_map_FAN_CORE, FanCoreBetaPrMap());

    var LPC = IPCBetaPR_OD(fan_hub[2], fan_hub[5], fan_hub[6], wc_map_LPC, eff_map_LPC, PR_map_LPC, IPCBetaPrMap());

    var D1 = Duct(LPC[5],LPC[2],LPC[6],delP_D1);

    var HPC = cmPBetaPR_OD(D1[1], D1[0], D1[2], wc_map_HPC, eff_map_HPC, PR_map_HPC);

    var CB_CDP = coolingbleed(HPC[6],HPC[2],HPC[5],coolflow);

    var Combustor = comB(CB_CDP[2],CB_CDP[3],delPCmb,FAR_OD_guess,TET_OD,LHV_OD,eta_34_OD,CB_CDP[0],1);

    var CB_rmod = cooling_mixing(Combustor[6],CB_CDP[1], Combustor[1],Combustor[7],CB_CDP[3],Combustor[4],CB_CDP[2]);

    var HPT = HPTTurBZetaPR_OD(CB_rmod[2], CB_rmod[1], CB_rmod[0], CB_rmod[3], HPC[4], 1, zeta_od_HPT, nc_turb_od_HPT,
        wc_map_turb_HPT, eff_map_turb_HPT, zeta_threshold, 0.995, HPTZetaPRMap());

    var D2 = Duct(HPT[3],HPT[0],HPT[4],delP_D2);

    var LPT = LPTTurBZetaPR_OD(D2[0], D2[1], D2[2], CB_rmod[3], (LPC[4] + fan_hub[4] + fan_bypass[4]), 1, zeta_od_LPT, nc_turb_od_LPT,
        wc_map_turb_LPT, eff_map_turb_LPT, zeta_threshold, 0.995, LPTZetaPRMap());

    // properly investigate
    var Nozzle = nozArb_OD(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(altitude_OD)[1], CB_rmod[3],1,output[17]);
//    var Nozzle=nozCore_OD(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(altitude_OD)[1], CB_rmod[3],1,output[17]);


    var Fn_core=(Nozzle[2]*Nozzle[1]) - (Inlet_OD[0]*Inlet_OD[2]) + (output[17]*(Nozzle[0]-atmosphere(altitude_OD)[1]));

    var Fn_bypass=(Inlet_OD[1]*(Nozzle_bypass[1]-Inlet_OD[2]))+(output[18]*(Nozzle_bypass[0]-atmosphere(altitude_OD)[1]));

    Fn=Fn_core+Fn_bypass;
    SFC=Combustor[5]*1000000/(Fn);


    print('Off design');
    print(fan_bypass);
    print(fan_hub);
    print(LPC);
    print(HPC);
    print(Fn);
    print(SFC);


  });


}