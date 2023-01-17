import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/compressor/compressor_no_map.dart';
import 'package:engine_id/fan/fan_no_map.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/duct components/interstage_ducts_no_map.dart';
import 'package:engine_id/sas_components/coolingbleed_no_map.dart';
import 'package:engine_id/sas_components/cooling_mixing_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';
import 'package:engine_id/sas_components/customer_bleed_no_map.dart';
import 'package:engine_id/turbine/turbine_no_map.dart';

turbofan_2spl_no_map(var height, var delISA, var mdot,var cmPr_fan_hub,var cmPr_fan_bp,var cmPr1,var cmPr2,var TET, var BPR,
    var Mach, var delP_i, var delP_cmb,var delP_nzl,var delP_nzlBP, var delP_D1, var delP_D2,
    var LHV,var FAR_guess, var eta_mech,var eta_mech1, var eta_18,var eta_18_hub,var eta_2_25, var eta_25_3,
    var eta_34, var eta_4_45, var eta_45_5, var coolflow, var fuel_type, var delP_D3, var customer_bleed_percentage, var MachBP,
    var beta_fan_bp, var ncdes_fan_bp,
    var beta_fan_core, var ncdes_fan_core,
    var beta_ipc, var ncdes_ipc,
    var beta_hpc, var ncdes_hpc,
    var zeta_selected_HPT, var nc_des_turb_selected_HPT,
    var zeta_selected_LPT, var nc_des_turb_selected_LPT,
    ){

  var Inlet;
  var fan_hub;
  var fan_bypass;
  var LPC;
  var D1;
  var HPC;
  var CB_CDP;
  var Combustor;
  var CB_rmod;
  var HPT;
  var D2;
  var D_BP;
  var LPT;
  var Nozzle;
  var Nozzle_bypass;
  var Fn_core;
  var Fn_bypass;
  var Fn;
  var SFC;
  var CB;
  //var CW; // Low spool compressor work


  //inlet--> [mdot_core,mdot_fan,Vi,Ao,P0,T0];
//
  Inlet=subInlet(height,delISA,delP_i,Mach,mdot,BPR,1);

//  cmPBetaPR(Inlet[4],Inlet[3],cmPrLPC,eta2_25,Inlet[0],beta_selected_LPC,nc_des_cmp_selected_LPC);
  fan_bypass=fan_bypass_no_map(Inlet[5],Inlet[4],cmPr_fan_bp,eta_18,Inlet[1]);

  //Duct(var P_entry,var T_entry, var mdot, var delP)
  D_BP=Duct(fan_bypass[5],fan_bypass[2],fan_bypass[6],delP_D3);

  Nozzle_bypass=nozArb(D_BP[2],D_BP[0],D_BP[1],0.0, atmosphere(height)[1],0,1);
//  Nozzle_bypass = nozFan(D_BP[2],D_BP[0],D_BP[1], MachBP);


  //-----------------------------------------------------------//

  //Core flow

  //fan_hub-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];
  fan_hub=fan_core_no_map(Inlet[5],Inlet[4],cmPr_fan_hub,eta_18_hub,Inlet[0]);


  //LPC-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];

  LPC=cmP(fan_hub[2],fan_hub[5],cmPr1,eta_2_25,fan_hub[6]);

  //inter-connecting duct

  D1=Duct(LPC[5],LPC[2],LPC[6],delP_D1);

  //HPC

  HPC=cmP(D1[1], D1[0], cmPr2, eta_25_3, D1[2]);

  //Customer bleed
  CB = customer_bleed(HPC[6],HPC[2],HPC[5],customer_bleed_percentage);


  //cooling bleed

  CB_CDP=coolingbleed(CB[0],CB[2],CB[3],coolflow);

  //combustor

  Combustor=comB(CB_CDP[2],CB_CDP[3],delP_cmb,FAR_guess,TET,LHV,eta_34,CB_CDP[0],fuel_type);


  //cooling mix module-->[m_exit,T_exit,P_exit,FAR]

  CB_rmod=cooling_mixing(Combustor[6],CB_CDP[1], Combustor[1],Combustor[7],CB_CDP[3],Combustor[4],CB_CDP[2]);


  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot,scaled_map_Wc,scaled_map_Eff]
  HPT=TurB(CB_rmod[2],CB_rmod[1],CB_rmod[0],CB_rmod[3],HPC[4],eta_4_45,eta_mech,fuel_type);

  //inter-connecting duct hot-->return[P_exit,T_exit,mdot]

  D2=Duct(HPT[3],HPT[0],HPT[4],delP_D2);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot]

  LPT=TurB(D2[0],D2[1],D2[2],CB_rmod[3],LPC[4]+fan_bypass[4]+fan_hub[4],eta_45_5,eta_mech,fuel_type);

  //nozzle-->[P18s,Ve,Ae,mdot]

  Nozzle=nozArb(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(height)[1],CB_rmod[3],fuel_type);
  // Fn & SFC calculation-->

  Fn_core=((Nozzle[3]*Nozzle[1]) - (Inlet[0]*Inlet[2])) + (Nozzle[2]*1000*(Nozzle[0]-atmosphere(height)[1]));

  Fn_bypass=(Inlet[1]*(Nozzle_bypass[1]-Inlet[2])) + (Nozzle_bypass[2]*(Nozzle_bypass[0]-atmosphere(height)[1]));
  Fn=Fn_core+Fn_bypass;


  SFC=Combustor[5]*1000000/Fn;


  return[Fn,SFC,HPT[0],Combustor[7],Combustor[4],Combustor[6],Combustor[1], LPC[4],eta_4_45, Inlet[3], Inlet[6],Nozzle[2], Nozzle_bypass[2], Inlet[7], Inlet[8]];


}