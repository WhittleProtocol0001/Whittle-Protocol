import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';
import 'package:engine_id/algorithims/utility_methods.dart';

//turbine calculations
TurB(var P4,var T4, var mdot, var FAR, var CW, var eta_t, var eta_mech,int fuel_type){

  var TW;
  var gamma;
  var P5;


  TW=(CW)/(eta_mech);
  var LHS=TW/mdot;

  var iter_cp_T5 = iterate_cp_and_T5_turbine(T4, FAR, fuel_type, mdot, eta_t, TW);
  var T5_guess = iter_cp_T5[0];
  var T5_ideal = iter_cp_T5[1];
  var cp4_guess = iter_cp_T5[2];
  var cp45 = iter_cp_T5[3];


  gamma=cp(T5_ideal,FAR,fuel_type)[2];
  P5=P4*pow((T5_ideal/T4),(gamma/(gamma-1)));


  return[T5_guess,cp4_guess,cp45,P5,mdot];

}


// Power Turbine
PWT(var P4,var T4, var mdot, var FAR, var Mach_exit, var eta_t, int fuel_type, var height){

  var TW;
  var gamma_guess;
  var T5_guess;
  var gamma45;
  var cp45;
  var P5;
  var residual;


  gamma_guess=cp(T4,FAR,fuel_type)[2];

  P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);

  T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/eta_t);

  gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];

  residual=((gamma45-gamma_guess)/gamma45).abs();

  while (residual>0.0005){
    gamma_guess--;
    P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);
    T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/eta_t);
    gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];
    residual=((gamma45-gamma_guess)/gamma45).abs();
  }

  cp45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[0];

  TW=mdot*cp45(T4-T5_guess);

  return[mdot,P5,T5_guess,TW];
}