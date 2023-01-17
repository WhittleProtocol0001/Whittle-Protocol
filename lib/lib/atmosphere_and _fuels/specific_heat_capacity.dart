import 'dart:math';

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

    cpo=a0+(a1*tz)+(a2*pow(tz,2))+ (a3*pow(tz,3))+(a4*pow(tz,4))+(a5*pow(tz,5))+(a6*pow(tz,6))+(a7*pow(tz,7))+(a8*pow(tz,8));

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

    cpo=a0+(a1*tz)+(a2*pow(tz,2))+(a3*pow(tz,3))+(a4*pow(tz,4))+(a5*pow(tz,5))+(a6*pow(tz,6))+(a7*pow(tz,7))+(a8*pow(tz,8))+((FAR/(1+FAR))*(b0+(b1*tz)+(b2*pow(tz,2))+    (b3*pow(tz,3))+(b4*pow(tz,4))+(b5*pow(tz,5))+(b6*pow(tz,6))+(b7*pow(tz,7))));

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

//FAR calcs as per Walsh and Fletcher

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