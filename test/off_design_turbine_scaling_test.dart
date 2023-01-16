import 'package:engine_id/architectures/with_map/turbojet_one_spool_Maps.dart';
import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/turbine/turbine_HPTZetaPRMap.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';
import 'package:engine_id/compressor/compressor_HPCBetaPRMap.dart';
import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';

void main() {

  test('HPTZetaMAp', () {

    var altitude = 10500;
    var delP_inlet = 0.02;
    var delP_nzl = 0.05;
    var Mach_inlet_OD = 0.9;
    var LHV_OD = 43124000;
    var eta_34_OD = 0.995;
    var delISA = 0;


    var zeta_dp = 0.7 ;
    var nc_turb_selected = 0.85;
    var TET_OD = 1300;
    var zeta_threshold = 0.3;
    var zeta_od = 0.75 ;
    var nc_turb_od = 0.86;

    var output = turbojet_1spl_Maps(10500,0,50,12,1500, 0.92, 0.02, 0.03,0.05,43124000,0.02, 0.99, 0.87, 0.995, 0.88,1, 0.5, 0.9, zeta_dp, nc_turb_selected);
    var wc_map_cmp = output[3][0];
    var eff_map_cmp = output[3][1];
    var PR_map_cmp = output[3][2];
    var wc_map_turb = output[4][0];
    var eff_map_turb = output[4][1];


    var Inlet;
    var Compressor;
    var Combustor;
    var Turbine;
    var Nozzle;
    var Fn;
    var SFC;

    Inlet=subInlet_OD(altitude, delISA,delP_inlet,Mach_inlet_OD,[output[11]],2, 100, 1);

    Compressor = cmPBetaPR_OD(Inlet[4], Inlet[3], Inlet[0], wc_map_cmp, eff_map_cmp, PR_map_cmp);
//
    Combustor=comB(Compressor[2],Compressor[5],0.05,0.02,TET_OD,LHV_OD,eta_34_OD,Compressor[6],1);

    Turbine = HPTTurBZetaPR_OD(Combustor[7], TET_OD, Combustor[6], Combustor[1], Compressor[4], 1,
        zeta_od, nc_turb_od, wc_map_turb, eff_map_turb, zeta_threshold, 0.995, HPTZetaPRMap());


    Nozzle=nozCore_OD(Turbine[4],Turbine[3],Turbine[0],delP_nzl,atmosphere(altitude)[1],Combustor[1],1,output[12]);

    // Fn & SFC calculation

    Fn=(Inlet[0]*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(altitude)[1]));
    SFC=Combustor[5]/Fn;

    print(Fn);
    print(SFC*100000);

  });
}