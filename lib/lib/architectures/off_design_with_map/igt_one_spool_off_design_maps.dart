import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';
import 'package:engine_id/turbine/turbine_PWTZetaPRMap.dart';


igt_1spl_OD(var design_point_one_spool_igt, var altitude_OD, var Mach_inlet_OD, var delP_inlet, var delISA,
    var mdot_OD, var BPR_OD, var LHV_OD, var eta_34_OD, var delP_D3, var delP_D1, var delP_D2, var delP_nzl, var delPCmb, var eta_mech1, int fuel_type,
    var FAR_OD_guess, var TET_OD, var Mach_exit, var zeta_od_HPT, var nc_turb_od_HPT, var nc_turb_od_PWT, var zeta_od_PWT,  var zeta_threshold_HPT, var zeta_threshold_PWT){


  var wc_map_cmp_HPC = design_point_one_spool_igt[3][0];
  var PR_map_cmp_HPC = design_point_one_spool_igt[3][2];
  var eff_map_cmp_HPC = design_point_one_spool_igt[3][1];

  var wc_map_turb_HPT = design_point_one_spool_igt[4][0];
  var eff_map_turb_HPT = design_point_one_spool_igt[4][1];

  var wc_map_turb_PWT = design_point_one_spool_igt[5][0];
  var eff_map_turb_PWT = design_point_one_spool_igt[5][1];

  var Inlet;
  var HPC;
  var Combustor;
  var HPT;


  Inlet=subInlet_OD(altitude_OD, delISA, delP_inlet,Mach_inlet_OD,[design_point_one_spool_igt[12]],2,BPR_OD, mdot_OD);

  HPC = cmPBetaPR_OD(Inlet[4], Inlet[3], Inlet[0], wc_map_cmp_HPC, eff_map_cmp_HPC, PR_map_cmp_HPC);

  Combustor=comB(HPC[2],HPC[5],0.05,0.02,TET_OD,LHV_OD,eta_34_OD,HPC[6],1);

  HPT = HPTTurBZetaPR_OD(Combustor[7], TET_OD, Combustor[6], Combustor[1], HPC[4], fuel_type, zeta_od_HPT, nc_turb_od_HPT,
      wc_map_turb_HPT, eff_map_turb_HPT, zeta_threshold_HPT, 0.995, HPTZetaPRMap());


  var PWT = PWTTurBZetaPR_OD(HPT[3],HPT[0], HPT[4], Combustor[1], Mach_exit,
  fuel_type, altitude_OD, zeta_od_PWT, nc_turb_od_PWT, wc_map_turb_PWT,
  eff_map_turb_PWT, zeta_threshold_PWT, LPTZetaPRMap(), design_point_one_spool_igt[13]);


  // TW & Specific Power calcs
  var TW = PWT[4];
  var SpecificPower=Combustor[5]/TW;

  return[TW, SpecificPower*100000];

}


