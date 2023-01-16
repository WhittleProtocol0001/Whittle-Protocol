import 'package:engine_id/algorithims/utility_methods.dart';

cmP(var Tentry_comp, var P_entry, var pressureratio, var isen_e, var mdot){

  var CW;
  var P2;

  var iterate_T2_Cp =  iterate_cp_and_T2_compressor(Tentry_comp, pressureratio, isen_e);
  var cpT2 = iterate_T2_Cp[4];
  var T2 = iterate_T2_Cp[0];
  var cpT1 = iterate_T2_Cp[5];
  var T2i = iterate_T2_Cp[1];

  CW=mdot*((cpT2[0]*T2)-(cpT1*Tentry_comp));
  P2=pressureratio*P_entry;

  return [cpT2[0],iterate_T2_Cp[3],T2,T2i,CW,P2,mdot,Tentry_comp];

}