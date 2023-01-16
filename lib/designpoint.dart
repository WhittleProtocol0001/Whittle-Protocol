import 'dart:math';

void main() {
  //print(atmosphere(0));
  //print(turbojet_1spl(0,150,20,1800, 0, 0.03, 0.05,0.05,43124000,0.02, 0.99, 0.87, 0.995, 0.88,1));

  //print(turbojet_2spl(0,150,3,10,1800,0,0.02,0.05,0.05,0.025,0.025,43124000,0.02,0.99,0.99,0.87,0.85,0.995,0.89,0.92,0.02,1));
  //print(turbofan_2spl(10500,150,1.3,1.3,1.4,13,1800,5,0.78,0.02,0.05,0.02,0.01,0.8,0.02,0.02,43124000,0.02,0.99,0.99,0.87,0.85,0.87, 0.88,0.995,0.9,0.92,0.02,1,0.02));
  //print(PWT(1013000,1100, 50, 0.02, 0.2, 0.92, 1, 0));
}

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

//Specific heat capacity as a function of temperature, FAR and fuel type
cp(var T,var FAR,var fueltype){

  if (T>0 && FAR<=0){
    var tz;
    var cpo;
    var R;
    var gamma;


    tz=T/1000;
    var a0=0.992313;
    var a1=0.236688;
    var a2=-1.852148;
    var a3=6.083152;
    var a4=-8.893933;
    var a5=7.097112;
    var a6=-3.234725;
    var a7=0.794571;
    var a8=-0.081873;
    var a9=0.422178;
    var a10=0.001053;

    cpo=a0+(a1*tz)+(a2*pow(tz,2))+    (a3*pow(tz,3))+(a4*pow(tz,4))+(a5*pow(tz,5))+(a6*pow(tz,6))+(a7*pow(tz,7))+(a8*pow(tz,8));

    R=287.05;
    gamma=cpo/(cpo-(R/1000));
    return [cpo*1000,R,gamma];
  }
  else if (T>0 && FAR>0){
    var tz;
    var cpo;
    var R;
    var gamma;

    tz=T/1000;
    var a0=0.992313;
    var a1=0.236688;
    var a2=-1.852148;
    var a3=6.083152;
    var a4=-8.893933;
    var a5=7.097112;
    var a6=-3.234725;
    var a7=0.794571;
    var a8=-0.081873;
    var a9=0.422178;
    var a10=0.001053;

    var b0=-0.718874;
    var b1=8.747481;
    var b2=-15.863157;
    var b3=17.254096;
    var b4=-10.233795;
    var b5=3.081778;
    var b6=-0.361112;
    var b7=-0.003919;
    var b8=0.0555930;
    var b9=-0.0016079;

    cpo=a0+(a1*tz)+(a2*pow(tz,2))+    (a3*pow(tz,3))+(a4*pow(tz,4))+(a5*pow(tz,5))+(a6*pow(tz,6))+(a7*pow(tz,7))+(a8*pow(tz,8))+((FAR/(1+FAR))*(b0+(b1*tz)+(b2*pow(tz,2))+    (b3*pow(tz,3))+(b4*pow(tz,4))+(b5*pow(tz,5))+(b6*pow(tz,6))+(b7*pow(tz,7))));

    if (fueltype==1){
      //kerosene
      R=287.05-(0.0090*FAR)+((1/10000000)*pow(FAR,2));
    }

    else if (fueltype==2){
      //diesel
      R=287.05-(8.0262*FAR)+((1/30000000)*pow(FAR,2));
    }

    else if (fueltype==3){
      //natural gas
      R=287.05+(212.85*FAR)-(197.89*pow(FAR,2));
    }

    else{
      R=287.05;
    }

    gamma=cpo/(cpo-(R/1000));

    return [cpo*1000,R,gamma];

  }

  else{
    return [1036,287.05,1.4];

  }


}

//compressor calculations
cmP(var Tentry_comp,var P_entry,var pressureratio,var isen_e,var mdot){

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

  cpo_i=cp(Tentry_comp,0,0);
  cp_guess=cpo_i[0];

  T2i=Tentry_comp*pow(pressureratio,(cpo_i[1]/cp_guess));
  Tmean=(T2i+Tentry_comp)/2;

  cpo_m=cp(Tmean,0,0);


  residual=((cpo_m[0]-cp_guess)/cpo_m[0]).abs();

  while(residual>=0.0005){
    cp_guess++;
    T2i=Tentry_comp*pow(pressureratio,(cpo_i[1]/cp_guess));
    Tmean=(T2i+Tentry_comp)/2;
    cpo_m=cp(Tmean,0,0);

    residual=((cpo_m[0]-cp_guess)/cpo_m[0]).abs();

  }

  cp_guess1=cpo_i[0];

  LHS = isen_e*((cp_guess*T2i)-(cp_guess1*Tentry_comp));
  var total_enthalpy = LHS + (cp_guess1*Tentry_comp);
  var T2guess = total_enthalpy/cp_guess1;
  var cpT2 = cp(T2guess,0,0);

  var residual2=(((cpT2[0]*T2guess)-total_enthalpy)/total_enthalpy).abs();

  while(residual2>=0.01){
    T2guess--;
    cpT2 = cp(T2guess,0,0);
    var new_total_enthalpy = cpT2[0]*T2guess;
    residual2=((new_total_enthalpy-total_enthalpy)/total_enthalpy).abs();
    print(residual2);

  }

  T2 = T2guess;


  CW=mdot*((cpT2[0]*T2)-(cpo_i[0]*Tentry_comp));
  P2=pressureratio*P_entry;

  return [cpT2[0],cp_guess1,T2,T2i,CW,P2,mdot,Tentry_comp];

}

//cooling bleed module
coolingbleed(var mdot,var T_entry,var P_entry,var percentbleed){

  var mdot_exit;
  var m_cool;

  m_cool=percentbleed*mdot;
  mdot_exit=mdot-m_cool;

  return[mdot_exit,m_cool,T_entry,P_entry];

}

//combustor calculations

comB(var T3,var P3, var delP,var FAR_guess,var T4,var LHV,var eta_34,var mdot,var fuel_type){
  //remember the LHV value should be in J/kg.C


  var cp_T4;
  var cp_T3;
  var FAR;
  var residual;
  var mdot_f;
  var m_exit;
  var P4;

  cp_T3=cp(T3,0,0);
  cp_T4=cp(T4,FAR_guess,1);

  FAR=((cp_T4[0]*T4)-(cp_T3[0]*T3))/(LHV*eta_34);

  residual=(FAR-FAR_guess)/FAR;

  while(residual.abs()>=0.005){
    if (FAR<FAR_guess){
      FAR_guess=FAR_guess-0.0001;
      cp_T4=cp(T4,FAR_guess,fuel_type);
      FAR=((cp_T4[0]*T4)-(cp_T3[0]*T3))/(LHV*eta_34);
      residual=(FAR-FAR_guess)/FAR;
    }
    else if(FAR>FAR_guess){
      FAR_guess=FAR_guess+0.0001;
      cp_T4=cp(T4,FAR_guess,fuel_type);
      FAR=((cp_T4[0]*T4)-(cp_T3[0]*T3))/(LHV*eta_34);
      residual=(FAR-FAR_guess)/FAR;
    }


  }
  mdot_f=FAR*mdot;
  m_exit=mdot+mdot_f;
  P4=P3*(1-delP);


  return [residual,FAR,cp_T4[0],cp_T3[0],T4,mdot_f,m_exit,P4];

}

//FAR calcs as per W+F

FAR_WF(var T3,var T4, var eta_34){
  var FAR1;
  var FAR2;
  var FAR3;
  var FAR;

  FAR1=0.10118+(0.00000200376*(700-T3));
  FAR2=0.0037078-(0.0000052368*(700-T3))-(0.0000052368*T4);
  FAR3=0.00000008889*(T4-950).abs();
  FAR=(FAR1-pow((pow(FAR1,2)+FAR2),0.5)-FAR3)/eta_34;

  return FAR;

}

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

//turbine calculations

TurB(var P4,var T4, var mdot, var FAR, var CW, var eta_t, var eta_mech,int fuel_type){

  var TW;
  var LHS;
  var cp4_guess;
  var T5_guess;
  var T_mean;
  var cp45;
  var RHS;
  var residual;
  var gamma;
  var P5;



  TW=(CW)/(eta_mech);
  LHS=TW/mdot;
  var cp4_prelim = cp(T4,FAR,fuel_type)[0];
  cp4_guess=cp(T4,FAR,fuel_type)[0];

  T5_guess=T4-((TW)/(mdot*cp4_guess));

  T_mean=0.5*(T5_guess+T4);

  cp45=cp(T_mean,FAR,fuel_type)[0];

  residual=((cp4_guess-cp45)/cp4_guess).abs();

  while (residual>0.0005){
    cp4_guess--;
    T5_guess=T4-((TW)/(mdot*cp4_guess));
    T_mean=0.5*(T5_guess+T4);
    cp45=cp(T_mean,FAR,fuel_type)[0];
    residual=((cp4_guess-cp45)/cp4_guess).abs();

  }

  var cp5_ideal_guess = cp(T5_guess,FAR,fuel_type)[0];

  var T5_ideal = ((cp4_prelim*T4)- (((cp4_prelim*T4)-(cp(T5_guess,FAR,fuel_type)[0]*T5_guess))/eta_t))/cp5_ideal_guess;
  var cp5ideal=cp(T5_ideal,FAR,fuel_type)[0];
  var residual_cp5 = ((cp5_ideal_guess-cp5ideal)/cp5_ideal_guess).abs();

  while (residual_cp5>0.0005){
    cp5_ideal_guess--;
    T5_ideal = ((cp4_prelim*T4)- (((cp4_prelim*T4)-(cp(T5_guess,FAR,fuel_type)[0]*T5_guess))/eta_t))/cp5_ideal_guess;
    T_mean=0.5*(T5_guess+T4);
    cp5ideal=cp(T5_ideal,FAR,fuel_type)[0];
    residual_cp5 = ((cp5_ideal_guess-cp5ideal)/cp5_ideal_guess).abs();

  }

  gamma=cp(T5_ideal,FAR,fuel_type)[2];
  P5=P4*pow((T5_ideal/T4),(gamma/(gamma-1)));


  return[T5_guess,cp4_guess,cp45,P5,mdot];

}

// Power Turbine

PWT(var P4,var T4, var mdot, var FAR, var Mach_exit, var eta_t, int fuel_type, var height){

  var TW;
  var gamma_guess;
  var T5_guess;
  var gamma45;
  var cp45;
  var P5;
  var residual;


  gamma_guess=cp(T4,FAR,fuel_type)[2];

  P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);

  T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/eta_t);

  gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];

  residual=((gamma45-gamma_guess)/gamma45).abs();

  while (residual>0.0005){
    gamma_guess--;
    P5=atmosphere(height)[1]*pow((1+(0.5*Mach_exit*Mach_exit*(gamma_guess-1))),(gamma_guess-1)/gamma_guess);
    T5_guess=(T4*pow(P5/P4,(gamma_guess-1)/gamma_guess))*(1/eta_t);
    gamma45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[2];
    residual=((gamma45-gamma_guess)/gamma45).abs();
  }

  cp45=cp(0.5*(T5_guess+T4),FAR,fuel_type)[0];

  TW=mdot*cp45(T4-T5_guess);

  return[mdot,P5,T5_guess,TW];
}

//inter-stage ducts

Duct(var P_entry,var T_entry, var mdot, var delP){
  var P_exit;
  var T_exit;

  P_exit=P_entry*(1-delP);
  T_exit=T_entry;

  return[P_exit,T_exit,mdot];

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

  Tcrit=(2/(gamma2+1))*T_entry;
  P8s=P_exit/CPR;

  rho=P8s/(cp(T8s,FAR,fuel_type)[1]*Tcrit);
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

  rho=P18s/(cp(T_entry,0,0)[1]*T18s);

  Ve=sqrt(gamma*cp(T_entry,0,0)[1]*T18s);

  Ae=mdot/(rho*Ve);

  return[P18s,Ve,Ae,mdot];

}
//inlet

subInlet(var height,var delP,var Mach,var mdot,var BPR,var turbo){

  var T0;
  var P0;
  var gamma;
  var Ts;
  var Ps;
  var rho;
  var Vi;
  var mdot_core;
  var mdot_fan;
  var Ao;

  if (turbo==1){
    T0=atmosphere(height)[0]+273;
    P0=1000*atmosphere(height)[1]*(1-delP);

    gamma=cp(T0,0,0)[2];
    Ts=T0/(1+((gamma-1)/2)*pow(Mach,2));
    Ps=P0/pow((1+((gamma-1)/2)*pow(Mach,2)),(gamma/(gamma-1)));

    rho=Ps/(Ts*cp(T0,0,0)[1]);
    Vi=Mach*sqrt(gamma*cp(T0,0,0)[1]*Ts);
    Ao=mdot/(rho*Vi);

    mdot_core=mdot/(BPR+1);
    mdot_fan=mdot_core*BPR;

    return[mdot_core,mdot_fan,Vi,Ao,P0,T0];

  }

  else if (turbo==2){

    T0=atmosphere(height)[0]+273;
    P0=atmosphere(height)[1]*(1-delP);

    gamma=cp(T0,0,0)[2];
    Ts=T0/(1+((gamma-1)/2)*pow(Mach,2));
    Ps=P0/pow((1+((gamma-1)/2)*pow(Mach,2)),(gamma/(gamma-1)));

    rho=Ps/(Ts*cp(T0,0,0)[1]);
    Vi=Mach*sqrt(gamma*cp(T0,0,0)[1]*Ts);
    Ao=mdot/(rho*Vi);

    return[mdot,Vi,Ao,P0,T0];

  }


}

//turbojet calculation

turbojet_1spl(var height,var mdot,var cmPr,var TET, var Mach, var delP_i, var delP_cmb,var delP_nzl,var LHV,var FAR_guess, var eta_mech, var eta_23, var eta_34, var eta_45, var fuel_type){

  var Inlet;
  var Compressor;
  var Combustor;
  var Turbine;
  var Nozzle;
  var Fn;
  var SFC;

  //atmosphere

  //inlet--> return[mdot,Vi,Ao,P0,T0];

  Inlet=subInlet(height,delP_i,Mach,mdot,0,2);

  //compressor-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];

  Compressor=cmP(Inlet[4],Inlet[3],cmPr,eta_23,Inlet[0]);

  //combustor-->[residual,FAR,cp_T4[0],cp_T3[0],T4,mdot_f,m_exit,P4]

  Combustor=comB(Compressor[2],Compressor[5],delP_cmb,FAR_guess,TET,LHV,eta_34,Compressor[6],fuel_type);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot]

  Turbine=TurB(Combustor[7],Combustor[4],Combustor[6],Combustor[1],Compressor[4],eta_45,eta_mech,fuel_type);

  //nozzle-->[P18s,Ve,Ae,mdot]

  Nozzle=nozCore(Turbine[4],Turbine[3],Turbine[0],delP_nzl,atmosphere(height)[1],Combustor[1],fuel_type);

  // Fn & SFC calculation

  Fn=(mdot*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(height)[1]));
  SFC=Combustor[5]/Fn;

  return[Fn,SFC*1000000,Turbine[0]];

  //turbojet_1spl(10500,30,6,1400, 0.92, 0.02, 0.05,0.05,43124000,0.02, 0.99, 0.87, 0.995, 0.88,1)

}


turbojet_2spl(var height,var mdot,var cmPr1,var cmPr2,var TET, var Mach, var delP_i, var delP_cmb,var delP_nzl,var delP_D1, var delP_D2, var LHV,var FAR_guess, var eta_mech,var eta_mech1, var eta_2_25, var eta_25_3,var eta_34, var eta_4_45, var eta_45_5, var coolflow, var fuel_type){

  var Inlet;
  var LPC;
  var D1;
  var HPC;
  var CB_CDP;
  var Combustor;
  var CB_rmod;
  var HPT;
  var D2;
  var LPT;
  var Nozzle;
  var Fn;
  var SFC;

  //atmosphere

  //inlet--> return[mdot,Vi,Ao,P0,T0];

  Inlet=subInlet(height,delP_i,Mach,mdot,0,2);

  //compressor-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];

  LPC=cmP(Inlet[4],Inlet[3],cmPr1,eta_2_25,Inlet[0]);
  print(LPC);

  // inter-connecting duct cold-->return[P_exit,T_exit,mdot]

  D1=Duct(LPC[5],LPC[2], LPC[6],delP_D1);

  //compressor-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];

  HPC=cmP(D1[1],D1[0],cmPr2,eta_25_3,D1[2]);
  print(HPC);

  //cooling bleed-->[mdot_exit,m_cool,T_entry,P_entry];

  CB_CDP=coolingbleed(HPC[6],HPC[2],HPC[5],coolflow);

  //combustor-->[residual,FAR,cp_T4[0],cp_T3[0],T4,mdot_f,m_exit,P4]

  Combustor=comB(CB_CDP[2],CB_CDP[3],delP_cmb,FAR_guess,TET,LHV,eta_34,CB_CDP[0],fuel_type);

  //cooling mix module-->[m_exit,T_exit,P_exit,FAR]

  CB_rmod=cooling_mixing(Combustor[6],CB_CDP[1], Combustor[1],Combustor[7],CB_CDP[3],Combustor[4],CB_CDP[2]);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot]

  HPT=TurB(CB_rmod[2],CB_rmod[1],CB_rmod[0],CB_rmod[3],HPC[4],eta_4_45,eta_mech1,fuel_type);

  //inter-connecting duct hot-->return[P_exit,T_exit,mdot]

  D2=Duct(HPT[3],HPT[0],HPT[4],delP_D2);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot]

  LPT=TurB(D2[0],D2[1],D2[2],CB_rmod[3],LPC[4],eta_45_5,eta_mech,fuel_type);

  //nozzle-->[P18s,Ve,Ae,mdot]
  //nozCore(var mdot,var P_entry, var T_entry, var delP,var Pamb,var FAR, var fuel_type)

  Nozzle=nozCore(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(height)[1],CB_rmod[3],fuel_type);

  // Fn & SFC calculation

  Fn=(mdot*(Nozzle[1]-Inlet[1]))+(Nozzle[2]*(Nozzle[0]-atmosphere(height)[1]));
  SFC=Combustor[5]/Fn;

  return[Fn,SFC*1000000,Combustor[5]];

  //turbojet_2spl(10000,100,3,4,1400,0.88,0.02,0.05,0.05,0.025,0.025,43124000,0.02,0.99,0.99,0.87,0.85,0.995,0.89,0.92,0.02,1)

}

//turbofan 2-spool

turbofan_2spl(var height,var mdot,var cmPr_fan_hub,var cmPr_fan_bp,var cmPr1,var cmPr2,var TET, var BPR, var Mach, var delP_i, var delP_cmb,var delP_nzl,var delP_nzlBP, var Mach_BP, var delP_D1, var delP_D2, var LHV,var FAR_guess, var eta_mech,var eta_mech1, var eta_18,var eta_18_hub,var eta_2_25, var eta_25_3,var eta_34, var eta_4_45, var eta_45_5, var coolflow, var fuel_type, var delP_D3){

  var Inlet;
  var fan_hub;
  var fan_bypass;
  var LPC;
  var D1;
  var HPC;
  var CB_CDP;
  var Combustor;
  var CB_rmod;
  var HPT;
  var D2;
  var D_BP;
  var LPT;
  var Nozzle;
  var Nozzle_bypass;
  var Fn_core;
  var Fn_bypass;
  var Fn;
  var SFC;
  //var CW; // Low spool compressor work


  //inlet--> [mdot_core,mdot_fan,Vi,Ao,P0,T0];

  Inlet=subInlet(height,delP_i,Mach,mdot,BPR,1);

  //Bypass flow Section
  //fan-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];
  //cmP(var Tentry_comp,var P_entry,var pressureratio,var isen_e,var mdot)

  fan_bypass=cmP(Inlet[5],Inlet[4],cmPr_fan_bp,eta_18,Inlet[1]);

  //bypass duct-->[P_exit,T_exit,mdot]
  //Duct(var P_entry,var T_entry, var mdot, var delP)

  D_BP=Duct(fan_bypass[5],fan_bypass[2],fan_bypass[6],delP_D3);

  //bypass nozzle-->[P18s,Ve,Ae,mdot]

  Nozzle_bypass=nozFan(D_BP[2],D_BP[0],D_BP[1],Mach_BP);

  //-----------------------------------------------------------//

  //Core flow

  //fan_hub-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];
  fan_hub=cmP(Inlet[5],Inlet[4],cmPr_fan_hub,eta_18_hub,Inlet[0]);

  //LPC-->[cp_guess,cp_guess1,T2,T2i,CW,P2,mdot];

  LPC=cmP(fan_hub[2],fan_hub[5],cmPr1,eta_2_25,fan_hub[6]);

  //inter-connecting duct

  D1=Duct(LPC[5],LPC[2],LPC[6],delP_D1);

  //HPC

  HPC=cmP(D1[1],D1[0],cmPr2,eta_25_3,D1[2]);

  //cooling bleed

  CB_CDP=coolingbleed(HPC[6],HPC[2],HPC[5],coolflow);

  //combustor

  Combustor=comB(CB_CDP[2],CB_CDP[3],delP_cmb,FAR_guess,TET,LHV,eta_34,CB_CDP[0],fuel_type);

  //cooling mix module-->[m_exit,T_exit,P_exit,FAR]

  CB_rmod=cooling_mixing(Combustor[6],CB_CDP[1], Combustor[1],Combustor[7],CB_CDP[3],Combustor[4],CB_CDP[2]);

  //Turbine

  HPT=TurB(CB_rmod[2],CB_rmod[1],CB_rmod[0],CB_rmod[3],HPC[4],eta_4_45,eta_mech1,fuel_type);

  //inter-connecting duct hot-->return[P_exit,T_exit,mdot]

  D2=Duct(HPT[3],HPT[0],HPT[4],delP_D2);

  //turbine-->[T5_guess,cp4_guess,cp45,P5,mdot]

  LPT=TurB(D2[0],D2[1],D2[2],CB_rmod[3],LPC[4]+fan_bypass[4]+fan_hub[4],eta_45_5,eta_mech,fuel_type);

  //nozzle-->[P18s,Ve,Ae,mdot]
  //nozCore(var mdot,var P_entry, var T_entry, var delP,var Pamb,var FAR, var fuel_type)

  Nozzle=nozCore(LPT[4],LPT[3],LPT[0],delP_nzl,atmosphere(height)[1],CB_rmod[3],fuel_type);

  // Fn & SFC calculation-->

  Fn_core=(Nozzle[3]*(Nozzle[1]-Inlet[2]))+(Nozzle[2]*(Nozzle[0]-atmosphere(height)[1]));
  Fn_bypass=(Inlet[1]*(Nozzle_bypass[1]-Inlet[2]))+(Nozzle_bypass[2]*(Nozzle_bypass[0]-atmosphere(height)[1]));
  Fn=Fn_core+Fn_bypass;

  SFC=Combustor[5]/Fn;

  return[Fn,SFC*1000000,Combustor[5]];

  //turbofan_2spl(10500,150,1.3,1.7,3,10,1500,1500,0.78,0.02,0.05,0.02,0.01,0.8,0.02,0.02,43124000,0.02,0.99,0.99,0.87,0.85,0.87, 0.88,0.995,0.9,0.92,0.02,1,0.02)

}


//turbofan 3-spool
