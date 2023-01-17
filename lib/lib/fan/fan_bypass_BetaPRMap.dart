import 'package:engine_id/algorithims/utility_methods.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';
import 'fan_core_BetaPRMap.dart';


FanBPBetaPR(var Tentry_comp,var P_entry,var pressureratio,
    var isen_e,var mdot,
    var beta_selected, var nc_des_selected, var compressormap){

  var CW;
  var P2;
  var wc1;

  // call Fan-BP Beta-PR map
  var fan_bp_map_values = compressormap;
  wc1 = CorrectedMassFlow(Tentry_comp, P_entry, mdot);

  // derive scale factors for the corresponding maps
  var SF_Wc = derive_scale_factor_beta_ncdes(wc1, beta_selected,
      nc_des_selected, fan_bp_map_values[0], fan_bp_map_values[1], fan_bp_map_values[2]);


  var SF_Eff = derive_scale_factor_beta_ncdes(isen_e, beta_selected,
      nc_des_selected, fan_bp_map_values[0], fan_bp_map_values[1], fan_bp_map_values[3]);

  var SF_PR = derive_scale_factor_beta_ncdes(pressureratio, beta_selected,
      nc_des_selected, fan_bp_map_values[0], fan_bp_map_values[1], fan_bp_map_values[4]);

  if (SF_PR<1){
    SF_PR = 1;
  }

  // derive scaled maps
  var scaled_map_Wc = scale_map(SF_Wc, fan_bp_map_values[2]);
  var scaled_map_Eff = scale_map(SF_Eff, fan_bp_map_values[3]);
  var scaled_map_PR = scale_map(SF_PR, fan_bp_map_values[4]);

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

FanBPBetaPR_OD(var Tentry_comp,var P_entry, var mdot, var scaled_corrected_mass_flow_map, var eff_map, var PR_map, var map_values){

  return FanCoreBetaPR_OD(Tentry_comp, P_entry, mdot, scaled_corrected_mass_flow_map, eff_map, PR_map, map_values);

}