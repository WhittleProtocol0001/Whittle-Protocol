import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/maps/HPCBetaPRMap.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';
import 'package:engine_id/algorithims/utility_methods.dart';


//compressor calculations
cmPBetaPR(var Tentry_comp,var P_entry,var pressureratio,
    var isen_e,var mdot,
    var beta_selected, var nc_des_selected){

  var CW;
  var P2;
  var wc1;
  var SF_Wc;
  var SF_Eff;
  var SF_PR;
  var hpc_map_values;
  var scaled_map_Wc;
  var scaled_map_Eff;
  var scaled_map_PR;


  // call HPC Beta-PR map
  hpc_map_values = HPCBetaPrMap();
  wc1 = CorrectedMassFlow(Tentry_comp, P_entry, mdot);

  // derive scale factors for the corresponding maps
  SF_Wc = derive_scale_factor_beta_ncdes(wc1, beta_selected,
      nc_des_selected, hpc_map_values[0], hpc_map_values[1], hpc_map_values[2]);

  SF_Eff = derive_scale_factor_beta_ncdes(isen_e, beta_selected,
      nc_des_selected, hpc_map_values[0], hpc_map_values[1], hpc_map_values[3]);

  SF_PR = derive_scale_factor_beta_ncdes(pressureratio, beta_selected,
      nc_des_selected, hpc_map_values[0], hpc_map_values[1], hpc_map_values[4]);


  // derive scaled maps
  scaled_map_Wc = scale_map(SF_Wc, hpc_map_values[2]);
  scaled_map_Eff = scale_map(SF_Eff, hpc_map_values[3]);
  scaled_map_PR = scale_map(SF_PR, hpc_map_values[4]);

  // determine on design performance
  var iterate_T2_Cp =  iterate_cp_and_T2_compressor(Tentry_comp, pressureratio, isen_e);
  var cpT2 = iterate_T2_Cp[4];
  var T2 = iterate_T2_Cp[0];
  var cpT1 = iterate_T2_Cp[5];
  var T2i = iterate_T2_Cp[1];

  CW=mdot*((cpT2[0]*T2)-(cpT1*Tentry_comp));
  P2=pressureratio*P_entry;

  return [iterate_T2_Cp[2],iterate_T2_Cp[3],T2,T2i,CW,P2,mdot,Tentry_comp,
    scaled_map_Wc, scaled_map_Eff, scaled_map_PR,];

}


cmPBetaPR_OD(var Tentry_comp,var P_entry, var mdot, var scaled_corrected_mass_flow_map, var eff_map, var PR_map){

  var CW;
  var P2;

  var hpc_map_values = HPCBetaPrMap();
  var wc1 = CorrectedMassFlow(Tentry_comp, P_entry, mdot);

  var beta_and_ncdes = find_beta_and_ncdes_values(wc1, scaled_corrected_mass_flow_map, hpc_map_values[0], hpc_map_values[1]);

  var isen_eff_od = get_eff_pr_dhqt_from_beta_ncdes(beta_and_ncdes[0], hpc_map_values[0],
      beta_and_ncdes[1], hpc_map_values[1], eff_map);


  var PR_od = get_eff_pr_dhqt_from_beta_ncdes(beta_and_ncdes[0], hpc_map_values[0],
      beta_and_ncdes[1], hpc_map_values[1], PR_map);

  var iterate_T2_Cp =  iterate_cp_and_T2_compressor(Tentry_comp, PR_od, isen_eff_od);
  var cpT2 = iterate_T2_Cp[4];
  var T2 = iterate_T2_Cp[0];
  var cpT1 = iterate_T2_Cp[5];
  var T2i = iterate_T2_Cp[1];

  CW=mdot*((cpT2[0]*T2)-(cpT1*Tentry_comp));
  P2=PR_od*P_entry;

  return [iterate_T2_Cp[2],iterate_T2_Cp[3],T2,T2i,CW,P2,mdot,Tentry_comp, PR_od, isen_eff_od, beta_and_ncdes, wc1];
}