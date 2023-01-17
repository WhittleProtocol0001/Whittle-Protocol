import 'package:engine_id/fan/fan_bypass_BetaPRMap.dart';
import 'package:engine_id/fan/fan_core_BetaPRMap.dart';

IPCBetaPR(var Tentry_comp,var P_entry,var pressureratio,
    var isen_e,var mdot,
    var beta_selected, var nc_des_selected, var compressormap){


  return FanBPBetaPR(Tentry_comp, P_entry, pressureratio, isen_e, mdot,
      beta_selected, nc_des_selected, compressormap);
}

IPCBetaPR_OD(var Tentry_comp,var P_entry, var mdot, var scaled_corrected_mass_flow_map, var eff_map, var PR_map, var map_values){

  return FanCoreBetaPR_OD(Tentry_comp, P_entry, mdot, scaled_corrected_mass_flow_map, eff_map, PR_map, map_values);
}