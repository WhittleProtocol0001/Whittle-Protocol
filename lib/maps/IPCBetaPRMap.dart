

IPCBetaPrMap(){
  var beta = [0.00000,0.05263,0.10526,0.15789,0.21053,0.26316,0.31579,0.36842,0.42105,0.47368,0.52632,0.57895,0.63158,0.68421,0.73684,0.78947,0.84211,0.89474,0.94737,1.00000];

  var ncdes = [0.36,0.53,0.66,0.79,0.88,0.95,1.00,1.03,1.14];

  var corrected_mass_flow = [
    [124.65780,121.75580,118.85380,115.95190,113.04990,110.06980,106.94240,103.60020,100.03990,96.23795,92.22882,88.13062,84.05632,80.00694,76.04159,72.14340,68.28065,64.41790,60.55515,56.69240],
    [159.94670,158.07770,156.13960,153.98350,151.63370,149.14650,146.27400,143.16530,139.78910,136.09640,132.29240,128.41140,124.45400,120.42740,116.37470,112.29300,108.21140,104.12970,100.04800,95.96635],
    [191.17930,190.10640,189.02540,187.58560,186.12390,184.23670,182.22600,179.76840,177.02190,174.04070,170.75140,167.35220,163.75400,159.98320,156.11900,152.05650,147.97520,143.89400,139.81270,135.73150],
    [223.80190,223.78140,223.55710,223.33280,222.91830,222.26960,221.56320,220.31360,219.01290,217.07580,215.00970,212.49970,209.78580,206.70700,203.37330,199.74570,195.84440,191.70380,187.56320,183.42260],
    [251.99000,251.99000,251.99000,251.95130,251.89040,251.80960,251.39490,250.98020,250.16430,249.21890,247.78450,246.21070,244.09720,241.87840,239.18790,236.31110,233.06110,229.54920,225.75720,221.96520],
    [274.92100,274.92100,274.92100,274.92100,274.92100,274.92100,274.90010,274.83180,274.67440,274.30910,273.74230,272.96620,271.76760,270.34150,268.67400,266.59300,264.28250,261.74230,258.76240,255.77950],
    [289.95600,289.95600,289.95600,289.95600,289.95600,289.95600,289.95600,289.95600,289.95600,289.90240,289.79110,289.43450,288.87660,288.06250,286.96420,285.60090,283.96010,281.99590,279.74860,277.45010],
    [295.36700,295.36700,295.36700,295.36700,295.36700,295.36700,295.36700,295.36700,295.36700,295.36700,295.32710,295.15820,294.82260,294.27030,293.45730,292.38320,291.05660,289.47160,287.62650,285.72780],
    [313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.92950,313.88500,313.79590,313.66240,313.38620,312.88560,312.29460,311.55260,310.80290]
  ];

  var eff = [
    [-2.20156,-1.22459,-0.57269,-0.14298,0.15738,0.37411,0.53422,0.65050,0.72569,0.76754,0.78904,0.79595,0.79617,0.79078,0.78185,0.76968,0.75349,0.73236,0.70691,0.67762],
    [0.14171,0.31251,0.45157,0.56155,0.64785,0.71562,0.76491,0.79737,0.81328,0.82081,0.82336,0.82190,0.81707,0.80978,0.80034,0.78918,0.77599,0.75589,0.73584,0.71078],
    [0.45429,0.54588,0.62478,0.68708,0.74015,0.78035,0.81018,0.82807,0.83789,0.84070,0.84048,0.83776,0.83241,0.82495,0.81593,0.80517,0.79298,0.77719,0.76053,0.74035],
    [0.55133,0.61502,0.66861,0.71648,0.75647,0.78861,0.81608,0.83368,0.84504,0.84962,0.85053,0.84842,0.84481,0.83789,0.82887,0.81758,0.80566,0.79386,0.78070,0.76754],
    [0.58742,0.63419,0.67700,0.71477,0.74840,0.77879,0.80391,0.82436,0.83880,0.84842,0.85263,0.85415,0.85285,0.85042,0.84566,0.83965,0.83188,0.82286,0.81208,0.80027],
    [0.59161,0.62825,0.66340,0.69501,0.72398,0.75070,0.77486,0.79583,0.81411,0.82856,0.83948,0.84701,0.85021,0.85156,0.85132,0.84887,0.84518,0.84033,0.83370,0.82689],
    [0.59311,0.62569,0.65576,0.68340,0.70822,0.73146,0.75342,0.77392,0.79233,0.80857,0.82269,0.83319,0.84071,0.84526,0.84741,0.84799,0.84701,0.84460,0.84092,0.83683],
    [0.59132,0.62153,0.64956,0.67561,0.69841,0.72092,0.74044,0.75923,0.77712,0.79379,0.80808,0.82010,0.82966,0.83636,0.84020,0.84216,0.84285,0.84216,0.84027,0.83794],
    [0.55993,0.58794,0.61411,0.63863,0.66179,0.68241,0.70227,0.71960,0.73587,0.74994,0.76316,0.77500,0.78531,0.79484,0.80361,0.81088,0.81703,0.82076,0.82265,0.82341]
  ];

  var PR = [
    [0.92409,0.94734,0.96963,0.99096,1.01134,1.03053,1.04829,1.06435,1.07862,1.09093,1.10134,1.11018,1.11784,1.12432,1.12985,1.13438,1.13781,1.13998,1.14089,1.14053],
    [1.02208,1.05309,1.08321,1.11185,1.13901,1.16485,1.18827,1.20977,1.22913,1.24602,1.26129,1.27504,1.28725,1.29792,1.30725,1.31519,1.32188,1.32732,1.33149,1.33440],
    [1.13784,1.17678,1.21531,1.25178,1.28764,1.32089,1.35288,1.38187,1.40852,1.43302,1.45487,1.47509,1.49313,1.50907,1.52333,1.53523,1.54583,1.55521,1.56338,1.57032],
    [1.28787,1.33760,1.38622,1.43475,1.48210,1.52789,1.57310,1.61464,1.65541,1.69154,1.72617,1.75708,1.78578,1.81105,1.83355,1.85292,1.86922,1.88260,1.89482,1.90586],
    [1.44146,1.49658,1.55171,1.60658,1.66130,1.71585,1.76806,1.82012,1.86911,1.91685,1.96055,2.00269,2.04006,2.07593,2.10726,2.13624,2.16125,2.18310,2.20155,2.21894],
    [1.58279,1.64213,1.70147,1.76080,1.82014,1.87947,1.93865,1.99745,2.05553,2.11185,2.16638,2.21895,2.26762,2.31390,2.35757,2.39698,2.43365,2.46747,2.49641,2.52445],
    [1.68344,1.74549,1.80755,1.86961,1.93167,1.99373,2.05579,2.11784,2.17990,2.24150,2.30258,2.36145,2.41837,2.47274,2.52417,2.57273,2.61817,2.65993,2.69827,2.73541],
    [1.72120,1.78423,1.84726,1.91029,1.97332,2.03635,2.09938,2.16241,2.22544,2.28847,2.35115,2.41265,2.47255,2.53032,2.58541,2.63770,2.68715,2.73360,2.77692,2.81912],
    [1.85698,1.92331,1.98964,2.05598,2.12231,2.18864,2.25497,2.32130,2.38763,2.45396,2.52029,2.58663,2.65253,2.71797,2.78294,2.84640,2.90744,2.96736,3.02546,3.08323]
  ];

  return[beta, ncdes, corrected_mass_flow, eff, PR];
}