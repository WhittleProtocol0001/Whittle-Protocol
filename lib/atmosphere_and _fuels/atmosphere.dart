import 'dart:math';

// Atmospheric conditions
atmosphere(var number){

  var T;//temperature
  var P;//Pressure
  var Pi;//Pressure component
  var rho;
  var R=273.1;

  if (number<=11000){
    T=15.04-(0.00649*number);
    Pi=pow(((T+273.1)/288.08),5.256);
    P=101.29*Pi;
    rho=P*1000/(R*(T+273.1));
    return [T,P,rho];
  }
  else if (number>11000 && number<25000){
    T=-56.46;
    P=pow((22.65*2.714),(1.73-(0.000157*number)));
    rho=P*1000/(R*(T+273.1));
    return [T,P,rho];
  }
  else if(number>=25000){
    T=-131.21+(0.000157*number);
    Pi=pow(((T+273.1)/216.6),-11.388);
    P=2.488*Pi;
    rho=P*1000/(R*(T+273.1));
    return [T,P,rho];
  }
  else{
    T=15.1;
    P=101325;
    rho=1.22;
    return [T,P,rho];
  }
}


CorrectedMassFlow(var T, var P, var Wc){

  var corrected_mass_flow = (Wc * pow(T,0.5))/P;

  return corrected_mass_flow;
}
