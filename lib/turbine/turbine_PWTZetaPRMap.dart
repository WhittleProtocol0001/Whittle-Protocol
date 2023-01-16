import 'package:engine_id/algorithims/utility_methods.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';


PWTTurBZetaPR(var P4,var T4, var mdot, var FAR, var CW, var eta_t, var Mach_exit,
    int fuel_type, var height, var nc_des_selected, var zeta_selected){

  var TW;
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


  var gamma_guess=cp(T4,FAR,fuel_type)[2];

  P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);

  var T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/eta_t);

  var gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];

  var residual=((gamma45-gamma_guess)/gamma45).abs();

  while (residual>0.0005){
    gamma_guess--;
    P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);
    T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/eta_t);
    gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];
    residual=((gamma45-gamma_guess)/gamma45).abs();
  }

  var cp45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[0];

  TW=mdot*cp45(T4-T5_guess);

  //return[mdot,P5,T5_guess,TW];
  return[T5_guess,cp45,P5,mdot,TW, scaled_map_Wc,scaled_map_Eff];

}

