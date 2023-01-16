import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';

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
  cp_T4=cp(T4,FAR_guess,fuel_type);

  var cp_mean = (cp_T3[0]+cp_T4[0])/2;
  FAR=cp_mean*(T4-T3)/(LHV*eta_34);


  residual=(FAR-FAR_guess)/FAR;

  while(residual.abs()>=0.002){
    if (FAR<FAR_guess){
      FAR_guess=FAR_guess-0.0001;
      cp_T4=cp(T4,FAR_guess,fuel_type);
      cp_mean = (cp_T3[0]+cp_T4[0])/2;
      FAR=cp_mean*(T4-T3)/(LHV*eta_34);
      residual=(FAR-FAR_guess)/FAR;
    }
    else if(FAR>FAR_guess){
      FAR_guess=FAR_guess+0.0001;
      cp_mean = (cp_T3[0]+cp_T4[0])/2;
      FAR=cp_mean*(T4-T3)/(LHV*eta_34);
      residual=(FAR-FAR_guess)/FAR;
    }


  }
  mdot_f=FAR_guess*mdot;
  m_exit=mdot+mdot_f;
  P4=P3*(1-delP);


  return [residual,FAR,cp_T4[0],cp_T3[0],T4,mdot_f,m_exit,P4];

}

comb_FR(var T3,var P3, var delP,var FAR_guess,var T4,var LHV,var eta_34,var mdot, var mach_entry, var mach_exit){

  var gamma3=cp(T3,0,0)[2];
  var T3s=T3/(1+((gamma3-1)/2)*pow(mach_entry,2));

  var gamma4=cp(T4,FAR_guess,1)[2];
  var T4s=T4/(1+((gamma4-1)/2)*pow(mach_exit,2));

  var tz1=T3s/1000;
  var tz2=T4s/1000;
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


  var h1 = (a0*tz1) + ((a1/2)*pow(tz1,2)) + ((a2/3)*pow(tz1,3)) + ((a3/4)*pow(tz1,4))
  + ((a4/5)*pow(tz1,5)) + ((a5/6)*pow(tz1,6)) + ((a6/7)*pow(tz1,7)) + ((a7/8)*pow(tz1,8)) + ((a8/9)*pow(tz1,9)) + a9;

  var h2 = (a0*tz2) + ((a1/2)*pow(tz2,2)) + ((a2/3)*pow(tz2,3)) + ((a3/4)*pow(tz2,4))
      + ((a4/5)*pow(tz2,5)) + ((a5/6)*pow(tz2,6)) + ((a6/7)*pow(tz2,7)) + ((a7/8)*pow(tz2,8)) + ((a8/9)*pow(tz1,9)) +a9
      + (FAR_guess/(1+FAR_guess)) *((b0*tz2) + ((b1/2)*pow(tz2,2)) + ((b2/3)*pow(tz2,3)) + ((b3/4)*pow(tz2,4)) +
          ((b4/5)*pow(tz2,5)) + ((b5/6)*pow(tz2,6)) + ((b6/7)*pow(tz2,7)) + b8);

  var delh = h2-h1;

  var FAR = (delh *1000) / (LHV*eta_34);

  var residual=(FAR-FAR_guess)/FAR;

  while(residual.abs()>=0.002){
    if (FAR<FAR_guess){
      FAR_guess=FAR_guess-0.0001;
      gamma4=cp(T4,FAR_guess,1)[2];
      T4s=T4/(1+((gamma4-1)/2)*pow(mach_exit,2));
      tz1=T3s/1000;
      tz2=T4s/1000;
      h1 = (a0*tz1) + ((a1/2)*pow(tz1,2)) + ((a2/3)*pow(tz1,3)) + ((a3/4)*pow(tz1,4))
          + ((a4/5)*pow(tz1,5)) + ((a5/6)*pow(tz1,6)) + ((a6/7)*pow(tz1,7)) + ((a7/8)*pow(tz1,8)) + ((a8/9)*pow(tz1,9)) + a9;
      h2 = (a0*tz2) + ((a1/2)*pow(tz2,2)) + ((a2/3)*pow(tz2,3)) + ((a3/4)*pow(tz2,4))
          + ((a4/5)*pow(tz2,5)) + ((a5/6)*pow(tz2,6)) + ((a6/7)*pow(tz2,7)) + ((a7/8)*pow(tz2,8)) + ((a8/9)*pow(tz1,9)) +a9
          + (FAR_guess/(1+FAR_guess)) *((b0*tz2) + ((b1/2)*pow(tz2,2)) + ((b2/3)*pow(tz2,3)) + ((b3/4)*pow(tz2,4)) +
              ((b4/5)*pow(tz2,5)) + ((b5/6)*pow(tz2,6)) + ((b6/7)*pow(tz2,7)) + b8);
      delh = h2-h1;
      FAR = (delh *1000) / (LHV*eta_34);
      residual=(FAR-FAR_guess)/FAR;
    }
    else if(FAR>FAR_guess){
      FAR_guess=FAR_guess+0.0001;
      gamma4=cp(T4,FAR_guess,1)[2];
      T4s=T4/(1+((gamma4-1)/2)*pow(mach_exit,2));
      tz1=T3s/1000;
      tz2=T4s/1000;
      h1 = (a0*tz1) + ((a1/2)*pow(tz1,2)) + ((a2/3)*pow(tz1,3)) + ((a3/4)*pow(tz1,4))
          + ((a4/5)*pow(tz1,5)) + ((a5/6)*pow(tz1,6)) + ((a6/7)*pow(tz1,7)) + ((a7/8)*pow(tz1,8)) + ((a8/9)*pow(tz1,9)) + a9;
      h2 = (a0*tz2) + ((a1/2)*pow(tz2,2)) + ((a2/3)*pow(tz2,3)) + ((a3/4)*pow(tz2,4))
          + ((a4/5)*pow(tz2,5)) + ((a5/6)*pow(tz2,6)) + ((a6/7)*pow(tz2,7)) + ((a7/8)*pow(tz2,8)) + ((a8/9)*pow(tz1,9)) +a9
          + (FAR_guess/(1+FAR_guess)) *((b0*tz2) + ((b1/2)*pow(tz2,2)) + ((b2/3)*pow(tz2,3)) + ((b3/4)*pow(tz2,4)) +
              ((b4/5)*pow(tz2,5)) + ((b5/6)*pow(tz2,6)) + ((b6/7)*pow(tz2,7)) + b8);
      delh = h2-h1;
      FAR = (delh *1000) / (LHV*eta_34);
      residual=(FAR-FAR_guess)/FAR;
    }


  }
  var mdot_f=FAR_guess*mdot;
  var m_exit=mdot+mdot_f;
  var P4=P3*(1-delP);
  var cp_T3 = cp(T3,0,0);
  var cp_T4 = cp(T4,FAR_guess,1);

  return [residual,FAR,cp_T4[0],cp_T3[0],T4,mdot_f,m_exit,P4];

}