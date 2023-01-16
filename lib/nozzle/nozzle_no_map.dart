import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';


// nozzle test

nozArb(var mdot,var P_entry, var T_entry, var delP,var Pamb,var FAR, var fuel_type ){

  var gamma1=cp(T_entry,FAR,fuel_type)[2];
  var CPR = pow(((gamma1+1)/2),(gamma1/(gamma1-1)));
  var P8 = P_entry*(1-delP);
  var NPR= P8/Pamb;

  if (NPR>CPR){
  // fully choked
    var p8 = (1/CPR)*P8;
    var t8 = (T_entry)/pow((P_entry/p8), (gamma1-1)/gamma1);
    var Ve_check = sqrt(2*cp(T_entry,FAR,fuel_type)[0]*T_entry*(1-pow((1/NPR),(gamma1-1)/gamma1)));
    var Ae = mdot * cp(t8,FAR,fuel_type)[1] * t8/(p8*1000*Ve_check);

    return[p8,Ve_check,Ae,mdot,NPR];
  }
  if (NPR<CPR){

   // not choked
    var p8 = Pamb;
    var t8 = (T_entry)/pow((NPR), (gamma1-1)/gamma1);
    var Cpavg = (cp(T_entry,FAR,fuel_type)[0] + cp(t8,FAR,fuel_type)[0])/2;
    var Ve = sqrt(2*Cpavg*(T_entry-t8));
    var Ae = mdot * cp(t8,FAR,fuel_type)[1] * t8/(p8*1000*Ve);

    return[p8,Ve,Ae,mdot,NPR];

  }

}

nozArb_OD(var mdot,var P_entry, var T_entry, var delP,var Pamb,var FAR, var fuel_type, var Area_nozzle){

  var gamma1=cp(T_entry,FAR,fuel_type)[2];
  var CPR = pow(((gamma1+1)/2),(gamma1/(gamma1-1)));
  var P8 = P_entry*(1-delP);
  var NPR= P8/Pamb;

  if (NPR>CPR){
    // fully choked
    var p8 = (1/CPR)*P8;
    var t8 = (T_entry)/pow((P_entry/p8), (gamma1-1)/gamma1);
    var Ve_check = mdot * cp(t8,FAR,fuel_type)[1] * t8/(p8*1000*Area_nozzle);

    return[p8,Ve_check,mdot,NPR];
  }
  if (NPR<CPR){
    // not choked
    var p8 = Pamb;
    var t8 = (T_entry)/pow((NPR), (gamma1-1)/gamma1);
    var Ve_check = mdot * cp(t8,FAR,fuel_type)[1] * t8/(p8*1000*Area_nozzle);


    return[p8,Ve_check,mdot,NPR];

  }

}
//nozzle-core
nozCore(var mdot,var P_entry, var T_entry, var delP,var Pamb,var FAR, var fuel_type){

  var gamma1;
  var NPR;
  var CPR;
  var P_exit;
  var P8s;
  var T8s;
  var Tcrit;
  var gamma2;
  var rho;
  var Ao;
  var Ve;

  // choked nozzle
  P_exit=P_entry*(1-delP);
  NPR=P_exit/Pamb;

  gamma1=cp(T_entry,FAR,fuel_type)[2];

  T8s=(2/(gamma1+1))*T_entry;
  gamma2=cp(T8s,FAR,fuel_type)[2];

  CPR=pow(((gamma2+1)/2),(gamma2/(gamma2-1)));

  if (NPR>CPR){
    print('fully choked');
  }

  Tcrit=(2/(gamma2+1))*T_entry;
  P8s=P_exit/CPR;

  rho=(P8s *1000)/(cp(T8s,FAR,fuel_type)[1]*Tcrit);
  Ve=sqrt(gamma2*cp(T8s,FAR,fuel_type)[1]*Tcrit);

  Ao=mdot/(rho*Ve);

  return[P8s,Ve,Ao,mdot,NPR];

}

//nozzle-bypass
nozFan(var mdot,var P_entry,var T_entry, var Mach){
  var gamma;
  var P18s;
  var T18s;
  var rho;
  var Ae;
  var Ve;

  gamma=cp(T_entry,0,0)[2];

  T18s=T_entry/(1+(((gamma-1)/2)*pow(Mach,2)));

  P18s=P_entry/pow((1+(((gamma-1)/2)*pow(Mach,2))),(gamma/(gamma-1)));

  rho=(P18s *1000)/(cp(T_entry,0,0)[1]*T18s);

  Ve=sqrt(gamma*cp(T_entry,0,0)[1]*T18s);

  Ae=mdot/(rho*Ve);

  return[P18s,Ve,Ae,mdot];

}


nozFan_OD(var mdot,var P_entry,var T_entry, var Mach, var Area_BP_nozzle){
  var gamma;
  var P18s;
  var T18s;
  var rho;
  var Ae;
  var Ve;

  gamma=cp(T_entry,0,0)[2];

  T18s=T_entry/(1+(((gamma-1)/2)*pow(Mach,2)));

  P18s=P_entry/pow((1+(((gamma-1)/2)*pow(Mach,2))),(gamma/(gamma-1)));

  rho=(P18s *1000)/(cp(T_entry,0,0)[1]*T18s);
  Ve=mdot/(rho * Area_BP_nozzle);


  return[P18s,Ve,mdot];

}



nozCore_OD(var mdot,var P_entry, var T_entry, var delP,var Pamb,var FAR, var fuel_type, var Area_nozzle){

  var gamma1;
  var NPR;
  var CPR;
  var P_exit;
  var P8s;
  var T8s;
  var Tcrit;
  var gamma2;
  var rho;
  var Ao;
  var Ve;

  // choked nozzle
  P_exit=P_entry*(1-delP);
  NPR=P_exit/Pamb;

  gamma1=cp(T_entry,FAR,fuel_type)[2];

  T8s=(2/(gamma1+1))*T_entry;
  gamma2=cp(T8s,FAR,fuel_type)[2];

  CPR=pow(((gamma2+1)/2),(gamma2/(gamma2-1)));

  Tcrit=(2/(gamma2+1))*T_entry;
  P8s=P_exit/CPR;

  rho=(P8s * 1000)/(cp(T8s,FAR,fuel_type)[1]*Tcrit);
  Ve=mdot/(rho * Area_nozzle);


  return[P8s,Ve,mdot,NPR];

}