import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';

//inlet
subInlet(var height, var delISA, var delP,var Mach,var mdot,var BPR,var turbo){

  var T0;
  var P0;
  var gamma;
  var Ts;
  var Ps;
  var rho;
  var Vi;
  var mdot_core;
  var mdot_fan;
  var Ao_core;
  var Ao_bypass;
  var NDMP_fan;
  var NDMP_core;

  if (turbo==1){
    Ts = (atmosphere(height)[0] + delISA)+273;
    Ps = atmosphere(height)[1];

    gamma=cp(Ts,0,0)[2];
    T0 = Ts * (1+((gamma-1)/2)*pow(Mach,2));
    P0 = (Ps * pow((1+((gamma-1)/2)*pow(Mach,2)),(gamma/(gamma-1))))*(1-delP);


    rho=(Ps*1000)/(Ts*cp(Ts,0,0)[1]);
    Vi=Mach*sqrt(gamma*cp(Ts,0,0)[1]*Ts);

    mdot_core=mdot/(BPR+1);
    mdot_fan=mdot_core*BPR;

    NDMP_fan = mdot_fan * sqrt(T0)/P0;
    NDMP_core = mdot_core * sqrt(T0)/P0;


    Ao_core = mdot_core/(rho*Vi);
    Ao_bypass = mdot_fan/(rho*Vi);

    return[mdot_core, mdot_fan, Vi, Ao_core, P0, T0, Ao_bypass, NDMP_fan, NDMP_core];

  }

  else if (turbo==2){

    Ts=(atmosphere(height)[0] + delISA) +273;
    Ps=atmosphere(height)[1]*(1-delP);

    gamma=cp(Ts,0,0)[2];
    T0 = Ts * (1+((gamma-1)/2)*pow(Mach,2));
    P0 = (Ps * pow((1+((gamma-1)/2)*pow(Mach,2)),(gamma/(gamma-1))))*(1-delP);


    rho=(Ps*1000)/(Ts*cp(Ts,0,0)[1]);
    Vi=Mach*sqrt(gamma*cp(Ts,0,0)[1]*Ts);
    Ao_core=mdot/(rho*Vi);

    NDMP_core = mdot * sqrt(T0)/P0;

    return [mdot,Vi,Ao_core,P0,T0, NDMP_core];

  }

}

subInlet_OD(var height, var delISA, var delP,var Mach, var Areas, var turbo, var BPR, var mdot){

  var T0;
  var P0;
  var gamma;
  var Ts;
  var Ps;
  var rho;
  var Vi;
  var mdot_core;
  var mdot_fan;
  var Ao_core;
  var Ao_bypass;

  if (turbo==1){
    Ts = (atmosphere(height)[0] + delISA)+273;
    Ps = atmosphere(height)[1];


    gamma=cp(Ts,0,0)[2];
    T0 = Ts * (1+((gamma-1)/2)*pow(Mach,2));
    P0 = (Ps * pow((1+((gamma-1)/2)*pow(Mach,2)),(gamma/(gamma-1))))*(1-delP);

    rho=(Ps*1000)/(Ts*cp(Ts,0,0)[1]);
    Vi=Mach*sqrt(gamma*cp(Ts,0,0)[1]*Ts);

    Ao_core = Areas[0];
    Ao_bypass = Areas[1];

    mdot_core=mdot/(BPR+1);
    mdot_fan=mdot_core*BPR;

    var Vi_fan = mdot_fan/rho*Ao_bypass;
    var Vi_core = mdot_core/rho*Ao_core;
    var Vi_avg = (Vi_fan + Vi_core)/2;
    var residual = ((Vi_avg-Vi)/Vi).abs();
    if (residual>0.01){
      print('Velocity error');
    }

    return[mdot_core, mdot_fan, Vi, P0, T0, BPR];

  }

  else if (turbo==2){

    Ts = (atmosphere(height)[0] + delISA)+273;
    Ps = atmosphere(height)[1];


    gamma=cp(Ts,0,0)[2];
    T0 = Ts * (1+((gamma-1)/2)*pow(Mach,2));
    P0 = (Ps * pow((1+((gamma-1)/2)*pow(Mach,2)),(gamma/(gamma-1))))*(1-delP);

    rho=(Ps*1000)/(Ts*cp(T0,0,0)[1]);
    Vi=Mach*sqrt(gamma*cp(T0,0,0)[1]*Ts);
    Ao_core = Areas[0];
    mdot=Ao_core * rho * Vi;

    return[mdot,Vi,Ao_core,P0,T0];

  }

}