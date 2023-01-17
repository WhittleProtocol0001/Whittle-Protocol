
HPTZetaPRMap(){

  var zeta = [1,	0.947368443,	0.894736826,	0.842105269,	0.789473712,	0.736842096,	0.684210539,	0.631578922,	0.578947365,	0.526315808,	0.473684222,	0.421052635,	0.368421048,	0.315789461,	0.263157904,	0.210526317,	0.157894731,	0.105263159,	0.052631579,	0];

  var ncdes = [0.8000,0.9000,1.0000,1.0500,1.1000];

  var corrected_mass_flow =[
    [3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.141626835,	3.140909195,	3.138038158,	3.132091045,	3.12009573,	  3.100717783,	3.066267967,	3.014593363,	2.94712925,	2.865310907],
    [3.13373208,	3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.13373208,	  3.133014441,	3.130861282,	3.12437582,	  3.111483335,	3.091745615,	3.059090853,	3.007350445,	2.940669775,	2.863688231],
    [3.12081337,	3.12081337,	  3.12081337,	  3.12081337,	  3.12081337,	  3.12081337,	  3.12081337,	  3.12081337,	  3.12081337,	  3.12081337,	  3.12009573,	  3.117537975,	3.110765457,	3.099282265,	3.07775116,	  3.0483253,	  3.004784584,	2.942792654,	2.868181705, 2.865181705],
    [3.114712954,	3.114712954,	3.114712954,	3.114712954,	3.114712954,	3.114712954,	3.114712954,	3.114682198,	3.114534378,	3.114522934,	3.114356756,	3.113353729,	3.110687494,	3.104187012,	3.093222618,	3.073644638,	3.045695305,	3.005323648,	2.948118925,	2.878920078],
    [3.108612537,	3.108612537,	3.108612537,	3.108612537,	3.108612537,	3.108612537,	3.108612537,	3.108612537,	3.108254194,	3.108259916,	3.108085394,	3.106858015,	3.104306221,	3.097926617,	3.087799072,	3.069856405,	3.043700218,	3.006698608,	2.953747988,	2.889118433],
  ];

  var eff =[
    [0.74197191,	0.756914675,	0.772518158,	0.787495852,	0.801824212,	0.813764513,	0.823582113,	0.832835793,	0.840298533,	0.846666694,	0.851741314,	0.856484234,	0.860199034,	0.862686574,	0.864789903,	0.865771115,	0.86614871,	0.866418302,	0.864444435,	0.862686574],
    [0.778720021,	0.794162512,	0.809166431,	0.824192345,	0.837114453,	0.848955214,	0.859203994,	0.867661715,	0.875059068,	0.880066335,	0.883723259,	0.886397421,	0.887562215,	0.887562215,	0.887064695,	0.885406315,	0.883084595,	0.880596995,	0.877280295,	0.874129355],
    [0.809701502,	0.825183511,	0.841044784,	0.85550493,	0.869288862,	0.880596995,	0.89067167,	0.898139536,	0.903980076,	0.908106327,	0.910447776,	0.911096334,	0.910897017,	0.909302354,	0.906343281,	0.902126253,	0.896616936,	0.890298486,	0.883388698,	0.875415266],
    [0.824776113,	0.839104474,	0.853432834,	0.866268635,	0.877313435,	0.887761176,	0.896417916,	0.903283596,	0.908656716,	0.911949337,	0.914079785,	0.914833784,	0.914506793,	0.912785828,	0.91008234,	0.906177402,	0.900887907,	0.89460516,	0.887722194,	0.880042434],
    [0.829994678,	0.844435215,	0.858076274,	0.869353235,	0.880630195,	0.89049834,	0.898043096,	0.904842436,	0.909435213,	0.912757456,	0.914418578,	0.915124357,	0.914750814,	0.912757456,	0.910315096,	0.906832516,	0.901857376,	0.895721376,	0.889169455,	0.880863786],

  ];

  return[zeta, ncdes, corrected_mass_flow, eff];

}