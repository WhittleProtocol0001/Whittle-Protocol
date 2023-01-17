import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_no_map.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/turbine/turbine_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';

//turbojet calculation
turbojet_2spl(var height, var delISA, var mdot,var cmPrL, var cmPrH,var TET, var Mach, var delP_i,
    var delP_cmb,var delP_nzl,var LHV,var FAR_guess, var eta_mech1, var eta_mech2, var eta_2_25, var eta_25_3, var eta_34, var eta_4_45, var eta_45_5,var fuel_type){

  var Inlet;
  var LPC;
  var HPC;
  var Combustor;
  var HPT;
  var LPT;
  var Nozzle;
  var Fn;
  var SFC;

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

  //nozzle
  Nozzle=nozArb(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(height)[1],Combustor[1],fuel_type);

  // Fn & SFC calculation

  Fn=(mdot*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(height)[1]));
  SFC=Combustor[5]/Fn;

  return[Fn,SFC*1000000,LPT[0]];


}