import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_no_map.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/turbine/turbine_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';

//turbojet calculation
igt_2spl_no_map(var height, var delISA, var mdot,var cmPrL, var cmPrH,var TET, var Mach, var delP_i,
    var delP_cmb,var delP_nzl,var LHV,var FAR_guess, var eta_mech1, var eta_mech2, var eta_2_25, var eta_25_3, var eta_34, var eta_4_45, var eta_45_5,var fuel_type,
    var Mach_exit, var eta_5){

  var Inlet;
  var LPC;
  var HPC;
  var Combustor;
  var HPT;
  var LPT;
  var pwt;
  var SpecificPower;

  //atmosphere

  //inlet

  Inlet=subInlet(height,delISA,delP_i,Mach,mdot,0,2);

  //LPC compressor

  LPC=cmP(Inlet[4],Inlet[3],cmPrL,eta_2_25,Inlet[0]);

  //HPC compressor

  HPC=cmP(LPC[2],LPC[5],cmPrH,eta_25_3,LPC[6]);

  //combustor

  Combustor=comB(HPC[2],HPC[5],delP_cmb,FAR_guess,TET,LHV,eta_34,HPC[6],fuel_type);

  //HPT

  HPT=TurB(Combustor[7],Combustor[4],Combustor[6],Combustor[1],LPC[4],eta_4_45,eta_mech1,fuel_type);
  //[T5_guess,cp4_guess,cp45,P5,mdot]
  //LPT

  LPT=TurB(HPT[3],HPT[0],HPT[4],Combustor[1],HPC[4],eta_45_5,eta_mech2,fuel_type);

  //Power Turbine
  pwt = PWT(LPT[3],LPT[0], LPT[4], Combustor[1], Mach_exit, eta_5, fuel_type, height);

  var TW = pwt[3];

  // Fn & SFC calculation
  SpecificPower=Combustor[5]/TW;

  return[TW,SpecificPower*1000000,LPT[0]];


}