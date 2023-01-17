FanCoreBetaPrMap(){

  var beta = [
    0.000000000,
    0.052630000,
    0.105260000,
    0.157890000,
    0.210530000,
    0.263160000,
    0.315790000,
    0.368420000,
    0.421050000,
    0.473680000,
    0.526320000,
    0.578950000,
    0.631580000,
    0.684210000,
    0.736840000,
    0.789470000,
    0.842110000,
    0.894740000,
    0.947370000,
    1.000000000
  ];

  var ncdes = [0.36, 0.53, 0.66, 0.79, 0.88, 0.95, 1.00, 1.03, 1.14];

  var corrected_mass_flow = [
    [
      124.657800000,
      121.755800000,
      118.853800000,
      115.951900000,
      113.049900000,
      110.069800000,
      106.942400000,
      103.600200000,
      100.039900000,
      96.237950000,
      92.228820000,
      88.130620000,
      84.056320000,
      80.006940000,
      76.041590000,
      72.143400000,
      68.280650000,
      64.417900000,
      60.555150000,
      56.692400000
    ], [
      159.946700000,
      158.077700000,
      156.139600000,
      153.983500000,
      151.633700000,
      149.146500000,
      146.274000000,
      143.165300000,
      139.789100000,
      136.096400000,
      132.292400000,
      128.411400000,
      124.454000000,
      120.427400000,
      116.374700000,
      112.293000000,
      108.211400000,
      104.129700000,
      100.048000000,
      95.966350000
    ],
    [
      191.179300000,
      190.106400000,
      189.025400000,
      187.585600000,
      186.123900000,
      184.236700000,
      182.226000000,
      179.768400000,
      177.021900000,
      174.040700000,
      170.751400000,
      167.352200000,
      163.754000000,
      159.983200000,
      156.119000000,
      152.056500000,
      147.975200000,
      143.894000000,
      139.812700000,
      135.731500000
    ],
    [
      223.801900000,
      223.781400000,
      223.557100000,
      223.332800000,
      222.918300000,
      222.269600000,
      221.563200000,
      220.313600000,
      219.012900000,
      217.075800000,
      215.009700000,
      212.499700000,
      209.785800000,
      206.707000000,
      203.373300000,
      199.745700000,
      195.844400000,
      191.703800000,
      187.563200000,
      183.422600000
    ],
    [
      251.990000000,
      251.990000000,
      251.990000000,
      251.951300000,
      251.890400000,
      251.809600000,
      251.394900000,
      250.980200000,
      250.164300000,
      249.218900000,
      247.784500000,
      246.210700000,
      244.097200000,
      241.878400000,
      239.187900000,
      236.311100000,
      233.061100000,
      229.549200000,
      225.757200000,
      221.965200000
    ],
    [
      274.921000000,
      274.921000000,
      274.921000000,
      274.921000000,
      274.921000000,
      274.921000000,
      274.900100000,
      274.831800000,
      274.674400000,
      274.309100000,
      273.742300000,
      272.966200000,
      271.767600000,
      270.341500000,
      268.674000000,
      266.593000000,
      264.282500000,
      261.742300000,
      258.762400000,
      255.779500000
    ],
    [
      289.956000000,
      289.956000000,
      289.956000000,
      289.956000000,
      289.956000000,
      289.956000000,
      289.956000000,
      289.956000000,
      289.956000000,
      289.902400000,
      289.791100000,
      289.434500000,
      288.876600000,
      288.062500000,
      286.964200000,
      285.600900000,
      283.960100000,
      281.995900000,
      279.748600000,
      277.450100000
    ],
    [
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.367000000,
      295.327100000,
      295.158200000,
      294.822600000,
      294.270300000,
      293.457300000,
      292.383200000,
      291.056600000,
      289.471600000,
      287.626500000,
      285.727800000
    ],
    [
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.929500000,
      313.885000000,
      313.795900000,
      313.662400000,
      313.386200000,
      312.885600000,
      312.294600000,
      311.552600000,
      310.802900000
    ]
  ];

  var eff = [
    [
      -2.201560000,
      -1.224590000,
      -0.572690000,
      -0.142980000,
      0.157380000,
      0.374110000,
      0.534220000,
      0.650500000,
      0.725690000,
      0.767540000,
      0.789040000,
      0.795950000,
      0.796170000,
      0.790780000,
      0.781850000,
      0.769680000,
      0.753490000,
      0.732360000,
      0.706910000,
      0.677620000
    ],
    [
      0.141710000,
      0.312510000,
      0.451570000,
      0.561550000,
      0.647850000,
      0.715620000,
      0.764910000,
      0.797370000,
      0.813280000,
      0.820810000,
      0.823360000,
      0.821900000,
      0.817070000,
      0.809780000,
      0.800340000,
      0.789180000,
      0.775990000,
      0.755890000,
      0.735840000,
      0.710780000
    ],
    [
      0.454290000,
      0.545880000,
      0.624780000,
      0.687080000,
      0.740150000,
      0.780350000,
      0.810180000,
      0.828070000,
      0.837890000,
      0.840700000,
      0.840480000,
      0.837760000,
      0.832410000,
      0.824950000,
      0.815930000,
      0.805170000,
      0.792980000,
      0.777190000,
      0.760530000,
      0.740350000
    ],
    [
      0.551330000,
      0.615020000,
      0.668610000,
      0.716480000,
      0.756470000,
      0.788610000,
      0.816080000,
      0.833680000,
      0.845040000,
      0.849620000,
      0.850530000,
      0.848420000,
      0.844810000,
      0.837890000,
      0.828870000,
      0.817580000,
      0.805660000,
      0.793860000,
      0.780700000,
      0.767540000
    ],
    [
      0.587420000,
      0.634190000,
      0.677000000,
      0.714770000,
      0.748400000,
      0.778790000,
      0.803910000,
      0.824360000,
      0.838800000,
      0.848420000,
      0.852630000,
      0.854150000,
      0.852850000,
      0.850420000,
      0.845660000,
      0.839650000,
      0.831880000,
      0.822860000,
      0.812080000,
      0.800270000
    ],
    [
      0.591610000,
      0.628250000,
      0.663400000,
      0.695010000,
      0.723980000,
      0.750700000,
      0.774860000,
      0.795830000,
      0.814110000,
      0.828560000,
      0.839480000,
      0.847010000,
      0.850210000,
      0.851560000,
      0.851320000,
      0.848870000,
      0.845180000,
      0.840330000,
      0.833700000,
      0.826890000
    ],
    [
      0.593110000,
      0.625690000,
      0.655760000,
      0.683400000,
      0.708220000,
      0.731460000,
      0.753420000,
      0.773920000,
      0.792330000,
      0.808570000,
      0.822690000,
      0.833190000,
      0.840710000,
      0.845260000,
      0.847410000,
      0.847990000,
      0.847010000,
      0.844600000,
      0.840920000,
      0.836830000
    ],
    [
      0.591320000,
      0.621530000,
      0.649560000,
      0.675610000,
      0.698410000,
      0.720920000,
      0.740440000,
      0.759230000,
      0.777120000,
      0.793790000,
      0.808080000,
      0.820100000,
      0.829660000,
      0.836360000,
      0.840200000,
      0.842160000,
      0.842850000,
      0.842160000,
      0.840270000,
      0.837940000
    ],
    [
      0.559930000,
      0.587940000,
      0.614110000,
      0.638630000,
      0.661790000,
      0.682410000,
      0.702270000,
      0.719600000,
      0.735870000,
      0.749940000,
      0.763160000,
      0.775000000,
      0.785310000,
      0.794840000,
      0.803610000,
      0.810880000,
      0.817030000,
      0.820760000,
      0.822650000,
      0.823410000
    ],
  ];

  var PR = [
    [0.924090000,0.947340000,0.969630000,0.990960000,1.011340000,1.030530000,1.048290000,1.064350000,1.078620000,1.090930000,1.101340000,1.110180000,1.117840000,1.124320000,1.129850000,1.134380000,1.137810000,1.139980000,1.140890000,1.140530000],
    [1.022080000,1.053090000,1.083210000,1.111850000,1.139010000,1.164850000,1.188270000,1.209770000,1.229130000,1.246020000,1.261290000,1.275040000,1.287250000,1.297920000,1.307250000,1.315190000,1.321880000,1.327320000,1.331490000,1.334400000],
    [1.137840000,1.176780000,1.215310000,1.251780000,1.287640000,1.320890000,1.352880000,1.381870000,1.408520000,1.433020000,1.454870000,1.475090000,1.493130000,1.509070000,1.523330000,1.535230000,1.545830000,1.555210000,1.563380000,1.570320000],
    [1.287870000,1.337600000,1.386220000,1.434750000,1.482100000,1.527890000,1.573100000,1.614640000,1.655410000,1.691540000,1.726170000,1.757080000,1.785780000,1.811050000,1.833550000,1.852920000,1.869220000,1.882600000,1.894820000,1.905860000],
    [1.441460000,1.496580000,1.551710000,1.606580000,1.661300000,1.715850000,1.768060000,1.820120000,1.869110000,1.916850000,1.960550000,2.002690000,2.040060000,2.075930000,2.107260000,2.136240000,2.161250000,2.183100000,2.201550000,2.218940000],
    [1.582790000,1.642130000,1.701470000,1.760800000,1.820140000,1.879470000,1.938650000,1.997450000,2.055530000,2.111850000,2.166380000,2.218950000,2.267620000,2.313900000,2.357570000,2.396980000,2.433650000,2.467470000,2.496410000,2.524450000],
    [1.683440000,1.745490000,1.807550000,1.869610000,1.931670000,1.993730000,2.055790000,2.117840000,2.179900000,2.241500000,2.302580000,2.361450000,2.418370000,2.472740000,2.524170000,2.572730000,2.618170000,2.659930000,2.698270000,2.735410000],
    [1.721200000,1.784230000,1.847260000,1.910290000,1.973320000,2.036350000,2.099380000,2.162410000,2.225440000,2.288470000,2.351150000,2.412650000,2.472550000,2.530320000,2.585410000,2.637700000,2.687150000,2.733600000,2.776920000,2.819120000],
    [1.856980000,1.923310000,1.989640000,2.055980000,2.122310000,2.188640000,2.254970000,2.321300000,2.387630000,2.453960000,2.520290000,2.586630000,2.652530000,2.717970000,2.782940000,2.846400000,2.907440000,2.967360000,3.025460000,3.083230000]
  ];


  return[beta, ncdes, corrected_mass_flow, eff, PR];

}