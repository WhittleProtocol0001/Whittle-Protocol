import 'package:engine_id/algorithims/utility_methods.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';
import 'package:engine_id/maps/LPTZetaPRMap.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';
import 'package:engine_id/algorithims/off_design_scaling_HPT.dart';


PWTTurBZetaPR(var P4,var T4, var mdot, var FAR, var eta_t, var Mach_exit,
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

  var P5s = P5/pow((1+((gamma_guess-1)/2)*pow(Mach_exit,2)),(gamma_guess/(gamma_guess-1)));
  var T5s = T5_guess/ (1+((gamma_guess-1)/2)*pow(Mach_exit,2));
  var a = pow(gamma_guess*T5s*cp(T5s,FAR,fuel_type)[1],0.5);
  var Ve = Mach_exit*a;
  var rho = P5s/(cp(T5s,FAR,fuel_type)[1]*T5s);
  var Ae = mdot/(rho*Ve);

  //return[mdot,P5,T5_guess,TW];
  return[T5_guess,cp45,P5,mdot,TW, scaled_map_Wc,scaled_map_Eff, Ae];

}

PWTTurBZetaPR_OD(var P4,var T4, var mdot, var FAR, var Mach_exit,
    int fuel_type, var height, var zeta_dp, var nc_turb_selected, var scaled_corrected_mass_flow_map,
    var eff_map, var zeta_threshold, var map_values, var Area){

  var wc1 = CorrectedMassFlow(T4, P4, mdot);

  var isen_eff = find_eff_turb_simplified(wc1, scaled_corrected_mass_flow_map, zeta_dp,
      nc_turb_selected,map_values[0], map_values[1], zeta_threshold, eff_map);

  var gamma_guess=cp(T4,FAR,fuel_type)[2];

  var P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);

  var T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/isen_eff[2]);

  var gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];

  var residual=((gamma45-gamma_guess)/gamma45).abs();

  while (residual>0.0005){
    gamma_guess--;
    P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);
    T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/isen_eff[2]);
    gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];
    residual=((gamma45-gamma_guess)/gamma45).abs();
  }

  var cp45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[0];

  var TW=mdot*cp45(T4-T5_guess);

  var P5s = P5/pow((1+((gamma_guess-1)/2)*pow(Mach_exit,2)),(gamma_guess/(gamma_guess-1)));
  var T5s = T5_guess/ (1+((gamma_guess-1)/2)*pow(Mach_exit,2));
  var a = pow(gamma_guess*T5s*cp(T5s,FAR,fuel_type)[1],0.5);
  var Ve = Mach_exit*a;
  var rho = P5s/(cp(T5s,FAR,fuel_type)[1]*T5s);
  var Ae = mdot/(rho*Ve);

  var residual2 = ((Ae-Area)/Ae);

  while (residual2>0.0005){
    Mach_exit--;
    P5s = P5/pow((1+((gamma_guess-1)/2)*pow(Mach_exit,2)),(gamma_guess/(gamma_guess-1)));
    T5s = T5_guess/ (1+((gamma_guess-1)/2)*pow(Mach_exit,2));
    a = pow(gamma_guess*T5s*cp(T5s,FAR,fuel_type)[1],0.5);
    Ve = Mach_exit*a;
    rho = P5s/(cp(T5s,FAR,fuel_type)[1]*T5s);
    residual2 = ((Ae-Area)/Ae);
  }

  while (residual2<-0.0005){
    Mach_exit++;
    P5s = P5/pow((1+((gamma_guess-1)/2)*pow(Mach_exit,2)),(gamma_guess/(gamma_guess-1)));
    T5s = T5_guess/ (1+((gamma_guess-1)/2)*pow(Mach_exit,2));
    a = pow(gamma_guess*T5s*cp(T5s,FAR,fuel_type)[1],0.5);
    Ve = Mach_exit*a;
    rho = P5s/(cp(T5s,FAR,fuel_type)[1]*T5s);
    residual2 = ((Ae-Area)/Ae);
  }

  return[T5_guess,cp45,P5,mdot,TW];

}

