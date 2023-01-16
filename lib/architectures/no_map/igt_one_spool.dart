import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_no_map.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/turbine/turbine_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';

//turbojet calculation
igt_1spl_no_map(var height, var delISA, var mdot,var cmPr,var TET, var Mach, var delP_i,
    var delP_cmb,var delP_nzl,var LHV,var FAR_guess, var eta_mech, var eta_23, var eta_34, var eta_45, var eta_5,
    var Mach_exit, var fuel_type){

  var Inlet;
  var Compressor;
  var Combustor;
  var Turbine;
  var pwt;
  var SpecificPower;

  //atmosphere

  //inlet

  Inlet=subInlet(height,delISA,delP_i,Mach,mdot,0,2);

  //compressor

  Compressor=cmP(Inlet[4],Inlet[3],cmPr,eta_23,Inlet[0]);

  //combustor

  Combustor=comB(Compressor[2],Compressor[5],delP_cmb,FAR_guess,TET,LHV,eta_34,Compressor[6],fuel_type);

  //turbine

  Turbine=TurB(Combustor[7],Combustor[4],Combustor[6],Combustor[1],Compressor[4],eta_45,eta_mech,fuel_type);

  //Power Turbine
  pwt = PWT(Turbine[3],Turbine[0], Turbine[4], Combustor[1], Mach_exit, eta_5, fuel_type, height);

  var TW = pwt[3];

  // Fn & SFC calculation
  SpecificPower=Combustor[5]/TW;

  return[TW,SpecificPower*1000000,Turbine[0]];


}