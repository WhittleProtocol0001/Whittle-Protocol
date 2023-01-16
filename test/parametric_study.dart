import 'package:engine_id/architectures/no_map/turbofan_two_spool.dart';
import 'package:engine_id/architectures/with_map/turbofan_two_spool_Maps.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('Parametric study', () {
    var altitude = 10668;
    var zeta_dp = 0.7 ;
    var nc_turb_selected = 0.91;
    var zeta_dp_LPT = 0.75 ;
    var nc_turb_selected_LPT = 0.97;
    var TET = [1250,1300,1350,1400,1475,1500,1550,1600,1650,1700,1750,1800,1850,1900];
    var BPR = [4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0,5.1,5.2,5.3,5.4,5.5];
    var FPR = [1.01,1.05,1.3,1.5,1.8,2.0,2.1,2.2];
    var MNVAR = [0.87,0.87,0.85,0.77,0.7,0.6,0.65,0.55];
    var TET_ST = [1250,1400,1700];
    var HPC_PR = [7,8,9,10,11,12,13];
    var del_ISAS = [-20,-15,-10,-5,0,5,10,15,20,25,30];
    var SFC_TET = [];
    var Fn_TET = [];
    var SFC_BPR = [];
    var Fn_BPR = [];
    var SFC_FPR = [];
    var Fn_FPR = [];
    var SFC_specific_thrust = [];
    var Fn_specific_thrust = [];


    for (var i = 0; i < TET.length; i++) {
      // TO DO
      var output3 = turbofan_2spl_Maps(altitude,10,150.74,1.84,1.84,1.45,13.57739498,TET[i],4.64,0.78,0.02,0.027,0.015,0.015,0.015,0.015,43124000,0.01,0.999,0.995,0.89,0.89,0.89,0.875,0.995,0.89,0.90,0.03,1,0.01,0.01,
        0.55,
        0.69, 1.01,
        0.78, 1.012,
        0.75, 1.01,
        0.73, 1.011,
        zeta_dp, nc_turb_selected,
        zeta_dp_LPT, nc_turb_selected_LPT,);

      Fn_TET.add(output3[0]);
      SFC_TET.add(output3[1]);

    }

    print(SFC_TET);
    print(Fn_TET);


    for (var j = 0; j < BPR.length; j++) {
      var output2 = turbofan_2spl_Maps(altitude,10,150.74,1.84,1.84,1.45,13.57739498,1552,BPR[j],0.78,0.02,0.027,0.015,0.015,0.015,0.015,43124000,0.01,0.999,0.995,0.89,0.89,0.89,0.875,0.995,0.89,0.90,0.03,1,0.01,0.01,
        0.55,
        0.69, 1.01,
        0.78, 1.012,
        0.75, 1.01,
        0.73, 1.011,
        zeta_dp, nc_turb_selected,
        zeta_dp_LPT, nc_turb_selected_LPT,);

      Fn_BPR.add(output2[0]);
      SFC_BPR.add(output2[1]);
    }

    print(SFC_BPR);
    print(Fn_BPR);

    for (var k = 0; k < FPR.length; k++) {
      var output1 = turbofan_2spl_no_map(altitude,10,150.74,1.84,FPR[k],1.45,13.57739498,1552,4.63,0.78,0.02,0.027,0.015,0.015,0.015,0.015,43124000,0.01,0.999,0.995,0.89,0.89,0.89,0.875,0.995,0.89,0.90,0.03,1,0.01,0.01,
        MNVAR[k],
        0.69, 1.01,
        0.78, 1.012,
        0.75, 1.01,
        0.73, 1.011,
        zeta_dp, nc_turb_selected,
        zeta_dp_LPT, nc_turb_selected_LPT,);

      Fn_FPR.add(output1[0]);
      SFC_FPR.add(output1[1]);
    }

    print(SFC_FPR);
    print(Fn_FPR);

    for (var i = 0; i < del_ISAS.length; i++) {
        var output0 = turbofan_2spl_Maps(altitude,del_ISAS[i],150.74,1.84,1.84,1.45,13.57739498,1500,4.63,0.78,0.02,0.027,0.015,0.015,0.015,0.015,43124000,0.01,0.999,0.995,0.89,0.89,0.89,0.875,0.995,0.89,0.90,0.03,1,0.01,0.01,
          0.55,
          0.69, 1.01,
          0.78, 1.012,
          0.75, 1.01,
          0.73, 1.011,
          zeta_dp, nc_turb_selected,
          zeta_dp_LPT, nc_turb_selected_LPT,);

        Fn_specific_thrust.add(output0[0]);
        SFC_specific_thrust.add(output0[1]);

      print(SFC_specific_thrust);
      print(Fn_specific_thrust);

    }
//
//    for (var i = 0; i < HPC_PR.length; i++) {
//      var output0 = turbofan_2spl(altitude,10,150.74,1.84,1.84,1.45,HPC_PR[i],1500,4.63,0.78,0.02,0.027,0.015,0.015,0.015,0.015,43124000,0.01,0.999,0.995,0.89,0.89,0.89,0.875,0.995,0.89,0.90,0.03,1,0.01,0.01,
//        0.55,
//        0.69, 1.01,
//        0.78, 1.012,
//        0.75, 1.01,
//        0.73, 1.011,
//        zeta_dp, nc_turb_selected,
//        zeta_dp_LPT, nc_turb_selected_LPT,);
//
//      Fn_specific_thrust_OPR.add(output0[0]);
//      SFC_specific_thrust_OPR.add(output0[1]);
//
//      print(SFC_specific_thrust_OPR);
//      print(Fn_specific_thrust_OPR);
//
//    }

  });
}