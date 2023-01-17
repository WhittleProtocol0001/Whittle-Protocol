
//cooling flow mixing
cooling_mixing(var mdot,var mdot_cool, var FAR,var P4_hot,var P4_cool,var T4_hot,var T4_cool){

  var m_exit;
  var T_exit;
  var P_exit;
  var mdot_fuel;
  var FAR_n;

  if (P4_hot>P4_cool){
    m_exit=mdot;
    mdot_fuel=mdot*FAR;
    FAR_n=FAR;
    T_exit=T4_hot;
    P_exit=P4_hot;

    return [m_exit,T_exit,P_exit,FAR];

  }

  else{
    m_exit=mdot+mdot_cool;
    mdot_fuel=mdot*FAR;
    FAR_n=mdot_fuel/m_exit;
    T_exit=((mdot/m_exit)*T4_hot)+((mdot_cool/m_exit)*T4_cool);
    P_exit=((mdot/m_exit)*P4_hot)+((mdot_cool/m_exit)*P4_cool);

    return [m_exit,T_exit,P_exit,FAR_n];

  }

}
