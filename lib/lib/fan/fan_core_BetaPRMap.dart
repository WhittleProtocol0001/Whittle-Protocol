import 'package:engine_id/fan/fan_bypass_BetaPRMap.dart';
import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';
import 'package:engine_id/atmosphere_and _fuels/atmosphere.dart';
import 'package:engine_id/algorithims/off_design_scaling.dart';

FanCoreBetaPR(var Tentry_comp,var P_entry,var pressureratio,
    var isen_e,var mdot,
    var beta_selected, var nc_des_selected, var compressormap){


  return FanBPBetaPR(Tentry_comp, P_entry, pressureratio, isen_e, mdot,
      beta_selected, nc_des_selected, compressormap);
}

FanCoreBetaPR_OD(var Tentry_comp,var P_entry, var mdot, var scaled_corrected_mass_flow_map, var eff_map, var PR_map, var map_values){

  var cpo_i;
  var cpo_m;
  var cpo_m1;
  var T2i;
  var Tmean;
  var residual;
  var cp_guess;
  var cp_guess1;
  var T2;
  var Tmean1;
  var residual1;
  var CW;
  var P2;
  var LHS;

  var wc1 = CorrectedMassFlow(Tentry_comp, P_entry, mdot);

  var beta_and_ncdes = find_beta_and_ncdes_values(wc1, scaled_corrected_mass_flow_map, map_values[0], map_values[1]);

  var isen_eff_od = get_eff_pr_dhqt_from_beta_ncdes(beta_and_ncdes[0], map_values[0],
      beta_and_ncdes[1], map_values[1], eff_map);



  var PR_od = get_eff_pr_dhqt_from_beta_ncdes(beta_and_ncdes[0], map_values[0],
      beta_and_ncdes[1], map_values[1], PR_map);


  cpo_i=cp(Tentry_comp,0,0);
  cp_guess=cpo_i[0];

  T2i=Tentry_comp*pow(PR_od,(cpo_i[1]/cp_guess));
  Tmean=(T2i+Tentry_comp)/2;

  cpo_m=cp(Tmean,0,0);


  residual=((cpo_m[0]-cp_guess)/cpo_m[0]).abs();

  while(residual>=0.0005){
    cp_guess++;
    T2i=Tentry_comp*pow(PR_od,(cpo_i[1]/cp_guess));
    Tmean=(T2i+Tentry_comp)/2;
    cpo_m=cp(Tmean,0,0);

    residual=((cpo_m[0]-cp_guess)/cpo_m[0]).abs();

  }

  cp_guess1=cpo_i[0];

  LHS = ((cp_guess*T2i)-(cp_guess1*Tentry_comp))/isen_eff_od;
  var total_enthalpy = LHS + (cp_guess1*Tentry_comp);
  var T2guess = total_enthalpy/cp_guess1;
  var cpT2 = cp(T2guess,0,0);

  var residual2=(((cpT2[0]*T2guess)-total_enthalpy)/total_enthalpy).abs();

  while(residual2>=0.01){
    T2guess--;
    cpT2 = cp(T2guess,0,0);
    var new_total_enthalpy = cpT2[0]*T2guess;
    residual2=((new_total_enthalpy-total_enthalpy)/total_enthalpy).abs();

  }

  T2 = T2guess;


  CW=mdot*((cpT2[0]*T2)-(cpo_i[0]*Tentry_comp));
  P2=PR_od*P_entry;


  return [cp_guess,cp_guess1,T2,T2i,CW,P2,mdot,Tentry_comp, PR_od, isen_eff_od];

}