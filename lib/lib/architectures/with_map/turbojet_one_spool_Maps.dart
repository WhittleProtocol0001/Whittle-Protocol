import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';


//turbojet calculation

turbojet_1spl_Maps(var height, var delISA, var mdot,var cmPr,var TET, var Mach, var delP_i, var delP_cmb,var delP_nzl,
    var LHV,var FAR_guess, var eta_mech, var eta_23, var eta_34, var eta_45, var fuel_type, var beta_selected,
    var nc_des_cmp_selected, var zeta_selected, var nc_des_turb_selected){

  var Inlet;
  var Compressor;
  var Combustor;
  var Turbine;
  var Nozzle;
  var Fn;
  var SFC;

  //atmosphere

  //inlet--> return[mdot,Vi,Ao,P0,T0];

  Inlet=subInlet(height, delISA, delP_i,Mach,mdot,0,2);

  //compressor-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];

  Compressor=cmPBetaPR(Inlet[4],Inlet[3],cmPr,eta_23,Inlet[0],beta_selected,nc_des_cmp_selected);

  //combustor-->[residual,FAR,cp_T4[0],cp_T3[0],T4,mdot_f,m_exit,P4]

  Combustor=comB(Compressor[2],Compressor[5],delP_cmb,FAR_guess,TET,LHV,eta_34,Compressor[6],fuel_type);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot]
  Turbine=HPTTurBZetaPR(Combustor[7],Combustor[4],Combustor[6],Combustor[1],Compressor[4],eta_45,eta_mech,fuel_type, nc_des_turb_selected, zeta_selected);

  //nozzle-->[P18s,Ve,Ae,mdot]

  Nozzle=nozCore(Turbine[4],Turbine[3],Turbine[0],delP_nzl,atmosphere(height)[1],Combustor[1],fuel_type);

  // Fn & SFC calculation

  Fn=(mdot*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(height)[1]));
  SFC=(Combustor[5]/Fn) ;


  // Wc, eff, Pr
  var scaled_compressor_maps = [Compressor[8], Compressor[9], Compressor[10]];
  print(scaled_compressor_maps[2]);
  // Wc, eff
  var scaled_turbine_maps = [Turbine[5], Turbine[6]];


  return[Fn,SFC*1000000,Turbine[0], scaled_compressor_maps, scaled_turbine_maps, Combustor[7],Combustor[4],Combustor[6],Combustor[1],Compressor[4],eta_45, Inlet[2], Nozzle[2]];

  //turbojet_1spl(10500,30,6,1400, 0.92, 0.02, 0.05,0.05,43124000,0.02, 0.99, 0.87, 0.995, 0.88,1)

}