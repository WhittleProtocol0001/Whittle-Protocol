import 'package:engine_id/algorithims/utility_methods.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';


LPTTurBZetaPR(var P4,var T4, var mdot, var FAR, var CW, var eta_t, var eta_mech,
    int fuel_type, var nc_des_selected, var zeta_selected){

  var TW;
  var gamma;
  var P5;

  // call HPT Zeta-PR map
  var lpt_map_values = LPTZetaPRMap();
  var wc1 = CorrectedMassFlow(T4, P4, mdot);

  //var value_for_scaling, var beta_select, var ncdes_select, var beta, var ncdes, var map_list
  // derive scale factors for the corresponding maps
  var SF_Wc = derive_scale_factor_beta_ncdes_special_case(wc1, zeta_selected,
      nc_des_selected, lpt_map_values[0], lpt_map_values[1], lpt_map_values[2]);


  var SF_Eff = derive_scale_factor_beta_ncdes_special_case(eta_t, zeta_selected,
      nc_des_selected, lpt_map_values[0], lpt_map_values[1], lpt_map_values[3]);


  var skewed_SF_Wc = sf_array(lpt_map_values[1],nc_des_selected,SF_Wc);

  var scaled_map_Wc = scale_map_skewewd(skewed_SF_Wc, lpt_map_values[2]);


  var scaled_map_Eff = scale_map(SF_Eff, lpt_map_values[3]);


  TW=(CW)/(eta_mech);
  var LHS=TW/mdot;
  var iterz = iterate_cp_T5_zeta_map(T4, FAR, fuel_type, mdot, TW, eta_t);
  var T5_guess = iterz[0];
  var T5_ideal = iterz[1];
  var cp4_guess = iterz[2];
  var cp45 = iterz[3];

  gamma=cp(T5_ideal,FAR,fuel_type)[2];
  P5=P4*pow((T5_ideal/T4),(gamma/(gamma-1)));

  return[T5_guess,cp4_guess,cp45,P5,mdot,scaled_map_Wc,scaled_map_Eff];

}