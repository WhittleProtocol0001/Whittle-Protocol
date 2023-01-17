import 'package:engine_id/algorithims/utility_methods.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';
import 'package:engine_id/maps/HPTZetaPRMap.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';
import 'package:engine_id/algorithims/off_design_scaling_HPT.dart';


//turbine calculations
HPTTurBZetaPR(var P4,var T4, var mdot, var FAR, var CW, var eta_t, var eta_mech,
    int fuel_type, var nc_des_selected, var zeta_selected){

  var TW;
  var LHS;
  var gamma;
  var P5;

  // call HPT Zeta-PR map
  var hpt_map_values = HPTZetaPRMap();
  var wc1 = CorrectedMassFlow(T4, P4, mdot);

  //var value_for_scaling, var beta_select, var ncdes_select, var beta, var ncdes, var map_list
  // derive scale factors for the corresponding maps
  var SF_Wc = derive_scale_factor_beta_ncdes_special_case(wc1, zeta_selected,
      nc_des_selected, hpt_map_values[0], hpt_map_values[1], hpt_map_values[2]);


  var SF_Eff = derive_scale_factor_beta_ncdes_special_case(eta_t, zeta_selected,
      nc_des_selected, hpt_map_values[0], hpt_map_values[1], hpt_map_values[3]);

  //the scale factors for Wc and eff are skewed in order to ensure a wider range of corrected mass flows
  var skewed_SF_Wc = sf_array(hpt_map_values[1],nc_des_selected,SF_Wc);
  var skewed_SF_eff = sf_array(hpt_map_values[1],nc_des_selected,SF_Eff);

  // derive skewed-scaled maps
  var scaled_map_Wc = scale_map_skewewd(skewed_SF_Wc, hpt_map_values[2]);
  var scaled_map_Eff = scale_map(SF_Eff, hpt_map_values[3]);

  TW=(CW)/(eta_mech);
  LHS=TW/mdot;
  var iterz = iterate_cp_T5_zeta_map(T4, FAR, fuel_type, mdot, TW, eta_t);
  var T5_guess = iterz[0];
  var T5_ideal = iterz[1];
  var cp4_guess = iterz[2];
  var cp45 = iterz[3];

  gamma=cp(T5_ideal,FAR,fuel_type)[2];
  P5=P4*pow((T5_ideal/T4),(gamma/(gamma-1)));


  return[T5_guess,cp4_guess,cp45,P5,mdot,scaled_map_Wc,scaled_map_Eff];

}


//turbine calculations
LPTTurBZetaPR_OD(var P5,var T5, var mdot, var FAR, var CW,
    int fuel_type, var zeta_dp, var nc_turb_selected, var scaled_corrected_mass_flow_map,
    var eff_map, var zeta_threshold, var eta_mech, var map_values){

  return HPTTurBZetaPR_OD(P5, T5, mdot, FAR, CW, fuel_type, zeta_dp, nc_turb_selected,
      scaled_corrected_mass_flow_map, eff_map, zeta_threshold, eta_mech, map_values);
}


HPTTurBZetaPR_OD(var P4,var T4, var mdot, var FAR, var CW,
    int fuel_type, var zeta_dp, var nc_turb_selected, var scaled_corrected_mass_flow_map,
    var eff_map, var zeta_threshold, var eta_mech, var map_values){

  var TW;
  var LHS;
  var gamma;
  var P5;

//  var hpt_map_values = HPTZetaPRMap();
  var wc1 = CorrectedMassFlow(T4, P4, mdot);

  var isen_eff = find_eff_turb_simplified(wc1, scaled_corrected_mass_flow_map, zeta_dp,
      nc_turb_selected,map_values[0], map_values[1], zeta_threshold, eff_map);


  TW=(CW)/(eta_mech);
  LHS=TW/mdot;

  var iterz = iterate_cp_T5_zeta_map(T4, FAR, fuel_type, mdot, TW, isen_eff[2]);
  var T5_guess = iterz[0];
  var T5_ideal = iterz[1];
  var cp4_guess = iterz[2];
  var cp45 = iterz[3];

  gamma=cp(T5_ideal,FAR,fuel_type)[2];
  P5=P4*pow((T5_ideal/T4),(gamma/(gamma-1)));

  return [T5_guess,cp4_guess,cp45,P5,mdot,isen_eff];

}
