
//cooling bleed module
coolingbleed(var mdot,var T_entry,var P_entry,var percentbleed){

  var mdot_exit;
  var m_cool;

  m_cool=percentbleed*mdot;
  mdot_exit=mdot-m_cool;

  return[mdot_exit,m_cool,T_entry,P_entry];

}