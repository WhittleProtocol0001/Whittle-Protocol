
//inter-stage ducts
Duct(var P_entry,var T_entry, var mdot, var delP){

  var P_exit;
  var T_exit;

  P_exit=P_entry*(1-delP);
  T_exit=T_entry;

  return[P_exit,T_exit,mdot];

}