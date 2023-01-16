import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';

turbojet_1spl_OD(var design_point_one_spool_turbojet, var altitude_OD, var Mach_inlet_OD, var delP_inlet, var delISA,
    var mdot_OD, var BPR_OD, var LHV_OD, var eta_34_OD, var delP_D3, var delP_D1, var delP_D2, var delP_nzl, var delPCmb, var eta_mech1, var eta_mech2,
    var FAR_OD_guess, var TET_OD, var zeta_od_HPT, var nc_turb_od_HPT, var zeta_od_LPT, var nc_turb_od_LPT, var zeta_threshold){


  var wc_map_cmp_HPC = design_point_one_spool_turbojet[3][0];
  var PR_map_cmp_HPC = design_point_one_spool_turbojet[3][2];
  var eff_map_cmp_HPC = design_point_one_spool_turbojet[3][1];

  var wc_map_turb_HPT = design_point_one_spool_turbojet[4][0];
  var eff_map_turb_HPT = design_point_one_spool_turbojet[4][1];

  var Inlet;
  var HPC;
  var Combustor;
  var HPT;
  var Nozzle;
  var Fn;
  var SFC;


  Inlet=subInlet_OD(altitude_OD, delISA, delP_inlet,Mach_inlet_OD,[design_point_one_spool_turbojet[11]],2,BPR_OD, mdot_OD);

  HPC = cmPBetaPR_OD(Inlet[4], Inlet[3], Inlet[0], wc_map_cmp_HPC, eff_map_cmp_HPC, PR_map_cmp_HPC);

  Combustor=comB(HPC[2],HPC[5],0.05,0.02,TET_OD,LHV_OD,eta_34_OD,HPC[6],1);

  HPT = HPTTurBZetaPR_OD(Combustor[7], TET_OD, Combustor[6], Combustor[1], HPC[4], 1, zeta_od_HPT, nc_turb_od_HPT,
      wc_map_turb_HPT, eff_map_turb_HPT, zeta_threshold, 0.995, HPTZetaPRMap());


  Nozzle=nozCore_OD(HPT[4],HPT[3],HPT[0],delP_nzl,atmosphere(altitude_OD)[1],Combustor[1],1,design_point_one_spool_turbojet[12]);

// Fn & SFC calculation

  Fn=(Inlet[0]*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(altitude_OD)[1]));
  SFC=Combustor[5]/Fn;

  return[Fn, SFC];

}


