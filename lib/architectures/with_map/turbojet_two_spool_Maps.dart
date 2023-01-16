import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';
import 'package:engine_id/turbine/turbine_LPTZetaPRMap.dart';


turbojet_2spl_Maps(var height, var delISA, var mdot,var cmPrLPC,var cmPrHPC,var TET, var Mach, var delP_i, var delP_cmb,var delP_nzl,
    var LHV,var FAR_guess, var eta_mech_LP, var eta_mech_HP, var eta2_25, var eta25_3, var eta_34, var eta4_45, var eta45_5, var fuel_type, var beta_selected_LPC,
    var nc_des_cmp_selected_LPC, var beta_selected_HPC,
    var nc_des_cmp_selected_HPC, var zeta_selected_HPT, var nc_des_turb_selected_HPT,
    var zeta_selected_LPT, var nc_des_turb_selected_LPT,){

  var Inlet;
  var CompressorLPC;
  var CompressorHPC;
  var Combustor;
  var TurbineHPT;
  var TurbineLPT;
  var Nozzle;
  var Fn;
  var SFC;

  //atmosphere
  Inlet=subInlet(height, delISA, delP_i,Mach,mdot,0,2);

  CompressorLPC = cmPBetaPR(Inlet[4],Inlet[3],cmPrLPC,eta2_25,Inlet[0],beta_selected_LPC,nc_des_cmp_selected_LPC);

  CompressorHPC = cmPBetaPR(CompressorLPC[2],CompressorLPC[5],cmPrHPC,eta25_3,CompressorLPC[6],beta_selected_HPC,nc_des_cmp_selected_HPC);

  Combustor=comB(CompressorHPC[2],CompressorHPC[5],delP_cmb,FAR_guess,TET,LHV,eta_34,CompressorHPC[6],fuel_type);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot,scaled_map_Wc,scaled_map_Eff]
  TurbineHPT=HPTTurBZetaPR(Combustor[7],Combustor[4],Combustor[6],Combustor[1],CompressorHPC[4],eta4_45,eta_mech_HP,fuel_type,
      nc_des_turb_selected_HPT, zeta_selected_HPT);

  TurbineLPT=LPTTurBZetaPR(TurbineHPT[3],TurbineHPT[0], TurbineHPT[4], Combustor[1], CompressorLPC[4], eta45_5, eta_mech_LP,
  fuel_type, nc_des_turb_selected_LPT, zeta_selected_LPT);

  //nozzle-->[P18s,Ve,Ae,mdot]

  Nozzle=nozArb(TurbineLPT[4],TurbineLPT[3],TurbineLPT[0],delP_nzl,atmosphere(height)[1],Combustor[1],fuel_type);

  // Fn & SFC calculation

  Fn=(mdot*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(height)[1]));
  SFC=(Combustor[5]/Fn) ;


  // Wc, eff, Pr
  var scaled_compressor_maps_LPC = [CompressorLPC[8], CompressorLPC[9], CompressorLPC[10]];
  var scaled_compressor_maps_HPC = [CompressorHPC[8], CompressorHPC[9], CompressorHPC[10]];

  // Wc, eff
  var scaled_turbine_maps_HPT = [TurbineHPT[5], TurbineHPT[6]];
  var scaled_turbine_maps_LPT = [TurbineLPT[5], TurbineLPT[6]];


  return[Fn,SFC*1000000,TurbineHPT[0], scaled_compressor_maps_LPC, scaled_compressor_maps_HPC, scaled_turbine_maps_HPT, scaled_turbine_maps_LPT,Combustor[7],
    Combustor[4],Combustor[6],Combustor[1],CompressorLPC[4],eta4_45, Inlet[2], Nozzle[2]];

}