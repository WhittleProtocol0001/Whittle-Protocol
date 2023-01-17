import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
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


turbofan_2spl_OD(var design_point_two_spool_turbofan, var altitude_OD, var Mach_inlet_OD, var delP_inlet, var delISA,
    var mdot_OD, var BPR_OD, var LHV_OD, var eta_34_OD, var delP_D3, var delP_D1, var delP_D2, var delP_nzl, var delPCmb, var eta_mech1, var eta_mech2,
    var FAR_OD_guess, var TET_OD,var coolflow,var Mach_BP_OD, var zeta_od_HPT, var nc_turb_od_HPT, var zeta_od_LPT, var nc_turb_od_LPT, var zeta_threshold){

  var wc_map_FAN_BP = design_point_two_spool_turbofan[3][0];
  var eff_map_FAN_BP = design_point_two_spool_turbofan[3][1];
  var PR_map_FAN_BP = design_point_two_spool_turbofan[3][2];

  var wc_map_FAN_CORE = design_point_two_spool_turbofan[4][0];
  var PR_map_FAN_CORE = design_point_two_spool_turbofan[4][2];
  var eff_map_FAN_CORE = design_point_two_spool_turbofan[4][1];

  var wc_map_LPC = design_point_two_spool_turbofan[5][0];
  var eff_map_LPC = design_point_two_spool_turbofan[5][1];
  var PR_map_LPC = design_point_two_spool_turbofan[5][2];

  var wc_map_HPC = design_point_two_spool_turbofan[6][0];
  var eff_map_HPC = design_point_two_spool_turbofan[6][1];
  var PR_map_HPC = design_point_two_spool_turbofan[6][2];

  var wc_map_turb_HPT = design_point_two_spool_turbofan[7][0];
  var eff_map_turb_HPT = design_point_two_spool_turbofan[7][1];

  var wc_map_turb_LPT = design_point_two_spool_turbofan[8][0];
  var eff_map_turb_LPT = design_point_two_spool_turbofan[8][1];


  var Fn;
  var SFC;


  var Inlet_OD=subInlet_OD(altitude_OD, delISA, delP_inlet,Mach_inlet_OD,[design_point_two_spool_turbofan[15], design_point_two_spool_turbofan[16]],1, BPR_OD, mdot_OD);


  //Bypass
  var fan_bypass = FanBPBetaPR_OD(Inlet_OD[4],Inlet_OD[3],Inlet_OD[1], wc_map_FAN_BP, eff_map_FAN_BP, PR_map_FAN_BP, FanBypassBetaPrMap());


  var Bypass_duct = Duct(fan_bypass[5],fan_bypass[2],fan_bypass[6],delP_D3);

  var Nozzle_bypass=nozFan_OD(Bypass_duct[2], Bypass_duct[0], Bypass_duct[1], Mach_BP_OD, design_point_two_spool_turbofan[18]);


  //Core
  var fan_hub = FanCoreBetaPR_OD(Inlet_OD[4],Inlet_OD[3],Inlet_OD[0], wc_map_FAN_CORE, eff_map_FAN_CORE, PR_map_FAN_CORE, FanCoreBetaPrMap());

  var LPC = IPCBetaPR_OD(fan_hub[2], fan_hub[5], fan_hub[6], wc_map_LPC, eff_map_LPC, PR_map_LPC, IPCBetaPrMap());

  var D1 = Duct(LPC[5],LPC[2],LPC[6],delP_D1);

  var HPC = cmPBetaPR_OD(D1[1], D1[0], D1[2], wc_map_HPC, eff_map_HPC, PR_map_HPC);

  var CB_CDP = coolingbleed(HPC[6],HPC[2],HPC[5],coolflow);

  var Combustor = comB(CB_CDP[2],CB_CDP[3],delPCmb,FAR_OD_guess,TET_OD,LHV_OD,eta_34_OD,CB_CDP[0],1);

  var CB_rmod = cooling_mixing(Combustor[6],CB_CDP[1], Combustor[1],Combustor[7],CB_CDP[3],Combustor[4],CB_CDP[2]);

  var HPT = HPTTurBZetaPR_OD(CB_rmod[2], CB_rmod[1], CB_rmod[0], CB_rmod[3], HPC[4], 1, zeta_od_HPT, nc_turb_od_HPT,
      wc_map_turb_HPT, eff_map_turb_HPT, zeta_threshold, eta_mech1, HPTZetaPRMap());

  var D2 = Duct(HPT[3],HPT[0],HPT[4],delP_D2);

  var LPT = LPTTurBZetaPR_OD(D2[0], D2[1], D2[2], CB_rmod[3], (LPC[4] + fan_hub[4] + fan_bypass[4]), 1, zeta_od_LPT, nc_turb_od_LPT,
      wc_map_turb_LPT, eff_map_turb_LPT, zeta_threshold, eta_mech2, LPTZetaPRMap());

  var Nozzle = nozArb_OD(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(altitude_OD)[1], CB_rmod[3],1,design_point_two_spool_turbofan[17]);

  var Fn_core=(Nozzle[2]*Nozzle[1]) - (Inlet_OD[0]*Inlet_OD[2]) + (design_point_two_spool_turbofan[17]*(Nozzle[0]-atmosphere(altitude_OD)[1]));

  var Fn_bypass=(Inlet_OD[1]*(Nozzle_bypass[1]-Inlet_OD[2]))+(design_point_two_spool_turbofan[18]*(Nozzle_bypass[0]-atmosphere(altitude_OD)[1]));

  Fn=Fn_core+Fn_bypass;
  SFC=Combustor[5]*1000000/(Fn);
  var OPR = fan_hub[8]*LPC[8]*HPC[8]*(1-delP_D1);

  return[Fn, Fn_core, Fn_bypass, SFC, OPR, Fn/mdot_OD];

}