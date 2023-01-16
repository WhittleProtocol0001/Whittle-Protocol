import 'package:engine_id/architectures/with_map/turbojet_two_spool_Maps.dart';
import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'file:///C:/Users/Sebastiampillai/AndroidStudioProjects/engine_id/lib/algorithims/off_design_scaling.dart';
import 'file:///C:/Users/Sebastiampillai/AndroidStudioProjects/engine_id/lib/algorithims/off_design_scaling_HPT.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';

void main() {

  test('LPTZetaMAp', () {

    var altitude = 10500;
    var delP_inlet = 0.02;
    var delP_nzl = 0.05;
    var Mach_inlet_OD = 0.9;
    var LHV_OD = 43124000;
    var eta_34_OD = 0.995;
    var delISA = 0;


    var zeta_dp = 0.7 ;
    var nc_turb_selected = 0.85;
    var zeta_dp_LPT = 0.7 ;
    var nc_turb_selected_LPT = 0.97;
    var TET_OD = 1500;
    var zeta_threshold = 0.3;
    var zeta_od_HPT = 0.705 ;
    var nc_turb_od_HPT = 0.852;
    var zeta_od_LPT = 0.705;
    var nc_turb_od_LPT = 0.91;


    var output = turbojet_2spl_Maps(altitude,0, 100,3,3, 1500, 0.90, 0.02, 0.03,0.05,43124000, 0.02, 0.99, 0.99, 0.87,
        0.86, 0.995, 0.88,0.87, 1, 0.7, 0.9, 0.7,0.9,zeta_dp, nc_turb_selected, zeta_dp_LPT, nc_turb_selected_LPT);
    var wc_map_cmp_LPC = output[3][0];
    var eff_map_cmp_LPC = output[3][1];
    var PR_map_cmp_LPC = output[3][2];

    var wc_map_cmp_HPC = output[4][0];
    var PR_map_cmp_HPC = output[4][2];
    var eff_map_cmp_HPC = output[4][1];

    var wc_map_turb_HPT = output[5][0];
    var eff_map_turb_HPT = output[5][1];

    var wc_map_turb_LPT = output[6][0];
    var eff_map_turb_LPT = output[6][1];

    var Inlet;
    var LPC;
    var HPC;
    var Combustor;
    var HPT;
    var LPT;
    var Nozzle;
    var Fn;
    var SFC;


    Inlet=subInlet_OD(altitude, delISA, delP_inlet,Mach_inlet_OD,[output[13]],2,100, 1);

    LPC = cmPBetaPR_OD(Inlet[4], Inlet[3], Inlet[0], wc_map_cmp_LPC, eff_map_cmp_LPC, PR_map_cmp_LPC);

    HPC = cmPBetaPR_OD(LPC[2],LPC[5], LPC[6], wc_map_cmp_HPC, eff_map_cmp_HPC, PR_map_cmp_HPC);

    Combustor=comB(HPC[2],HPC[5],0.05,0.02,TET_OD,LHV_OD,eta_34_OD,HPC[6],1);

    HPT = HPTTurBZetaPR_OD(Combustor[7], TET_OD, Combustor[6], Combustor[1], HPC[4], 1, zeta_od_HPT, nc_turb_od_HPT,
        wc_map_turb_HPT, eff_map_turb_HPT, zeta_threshold, 0.995, HPTZetaPRMap());

    LPT = LPTTurBZetaPR_OD(HPT[3], HPT[0], HPT[4], Combustor[1], LPC[4], 1, zeta_od_LPT, nc_turb_od_LPT,
        wc_map_turb_LPT, eff_map_turb_LPT, zeta_threshold, 0.995, LPTZetaPRMap());

    Nozzle=nozCore_OD(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(altitude)[1],Combustor[1],1,output[14]);

    // Fn & SFC calculation

    Fn=(Inlet[0]*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(altitude)[1]));
    SFC=Combustor[5]/Fn;

    print(Fn);
    print(SFC*100000);

  });


}