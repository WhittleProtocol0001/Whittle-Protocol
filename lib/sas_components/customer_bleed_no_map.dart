
//customer bleed
customer_bleed(var mdot,var T_entry,var P_entry,var percentbleed){

  var mdot_exit;
  var m_customer_bleed;

  m_customer_bleed=percentbleed*mdot;
  mdot_exit=mdot-m_customer_bleed;

  return[mdot_exit,m_customer_bleed,T_entry,P_entry];

}