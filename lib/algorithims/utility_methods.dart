import 'dart:math';
import 'package:engine_id/atmosphere_and _fuels/specific_heat_capacity.dart';


rmse(var value, var obs) {

  var abs_val;
  var rsme_val;

  abs_val = (pow((value - obs), 2)).abs();
  rsme_val = pow(abs_val, 0.5);

  return rsme_val;
}


linear_interpolate(var x1, var x2, var x3, var y1, var y3) {

  var y2;

  if (x2 > x3 && x2 > x1) {
    var message = 'Linear interpolation not possible';

    return message;

  } else {
    y2 = (((x2 - x1) * (y3 - y1)) / (x3 - x1)) + y1;

    return y2;
  }
}


find_x1_and_x3_in_list(var n, List numbers) {

  var x1;
  var x3 = numbers.where((e) => e >= n).toList()
    ..sort(); //List of the greater values

  var x1_index = numbers.indexOf(x3.first) - 1;

  if (x1_index < 0) {
    x1 = numbers[0];
  } else {
    x1 = numbers[x1_index];
  }

  return [x1, x3.first, x1_index, x1_index + 1];
}


_assert_not_accepted_zeta_values(n, List x3) {

  if (n <0 ){
    throw('Please choose a zeta value that is greater than 0');
  }
  if (x3.isEmpty){
    throw('Please choose a zeta value that is not greater than 1');
  }
}


find_x1_and_x3_and_x4_in_list_special_case(var n, List numbers) {

  var x_values;
  var x_indices;

  var x3 = numbers.where((e) => e >= n).toList()
    ..sort(); //List of the greater values

  _assert_not_accepted_zeta_values(n, x3);
  var x1_index = numbers.indexOf(x3.first) + 1;

  //case1: zeta is at zero
  if (x1_index + 1 > numbers.length) {
    x_values = [numbers[numbers.length-1], n, numbers[x1_index-2], numbers[x1_index-3]];
    x_indices = [numbers.length-1, x1_index-2, x1_index-3];
  }
  //case2: zeta is between the last two indices
  if (n >= numbers[numbers.length-1] && n <= numbers[numbers.length-2]){
    x_values = [numbers[numbers.length-1], n, numbers[x1_index-2], numbers[x1_index-3]];
    x_indices = [numbers.length-1, x1_index-2, x1_index-3];
  }
  //case3: zeta value is between 1 and 0
  else {
    x_values = [
      numbers[x1_index - 1],
      n,
      numbers[x1_index],
      numbers[x1_index + 1]
    ];
    x_indices = [x1_index - 1, x1_index, x1_index + 1];
  }

  return [x_values, x_indices];
}


linear_interpolate_list(var x1, var x2, var x3, var y1, var y3) {

  var y2 = [];
  var y2_calc;

  for (var i = 0; i < y1.length; i++) {
    y2_calc = linear_interpolate(x1, x2, x3, y1[i], y3[i]);
    y2.add(y2_calc);
  }

  return y2;
}

find_minimum_value_and_index(var chosen_list) {

  var smallestGeekValue = chosen_list[0];
  var index_of_min;
  var c = 0;

  if (chosen_list.length < 1) {
    return [chosen_list[0], c];
  } else {
    for (var i = 0; i < chosen_list.length; i++) {
      if (chosen_list[i] < smallestGeekValue) {
        smallestGeekValue = chosen_list[i];
      }
    }
    index_of_min = chosen_list.indexOf(smallestGeekValue);

    return [smallestGeekValue, index_of_min];
  }
}


find_second_min_value_and_index(var index_of_rsme_lowest, var chosen_list) {

  var list_of_possibilities = [];
  var check;
  var second_lowest_val;

  if (index_of_rsme_lowest == 0) {
    return [chosen_list[1], index_of_rsme_lowest + 1];
  } else if (index_of_rsme_lowest == (chosen_list.length - 1)) {
    return [chosen_list[index_of_rsme_lowest - 1], index_of_rsme_lowest - 1];
  } else {
    list_of_possibilities.add(chosen_list[index_of_rsme_lowest - 1]);
    list_of_possibilities.add(chosen_list[index_of_rsme_lowest + 1]);
    check = find_minimum_value_and_index(list_of_possibilities);
    second_lowest_val = chosen_list.indexOf(check[0]);

    return [check[0], second_lowest_val];
  }
}


rsme_scaled_map(var chosen_value, var map_scale) {

  var rsme_map = [];
  var rsme_lowest = [];
  var calc_layer_j;
  var calc_layer_i;


  for (var i = 0; i < map_scale.length; i++) {
    var rsme_map_sub_layer = [];
    calc_layer_i = map_scale[i];
    for (var j = 0; j < calc_layer_i.length; j++) {
      calc_layer_j = rmse(chosen_value, map_scale[i][j]);
      rsme_map_sub_layer.add(calc_layer_j);
    }
    rsme_map.add(rsme_map_sub_layer);
    rsme_map_sub_layer.sort();
    rsme_lowest.add(rsme_map_sub_layer.first);

  }

  return [rsme_map, rsme_lowest];
}


rsme_scaled_map_without_sorting(var chosen_value, var map_scale) {

  var rsme_map = [];
  var calc_layer_j;
  var calc_layer_i;


  for (var i = 0; i < map_scale.length; i++) {
    var rsme_map_sub_layer = [];
    calc_layer_i = map_scale[i];
    for (var j = 0; j < calc_layer_i.length; j++) {
      calc_layer_j = rmse(chosen_value, map_scale[i][j]);
      rsme_map_sub_layer.add(calc_layer_j);
    }
    rsme_map.add(rsme_map_sub_layer);
  }

  return rsme_map;
}


find_max_index_from_parabolic_array(value, value_array){

  for (var i = 0; i < value_array.length; i++) {

    if(value != value_array[i]){
      return i-1;
    }
  }
}


quadratic_interpolation(x, x_0, x_1, x_2, y_0, y_1, y_2){
  //http://mathonline.wikidot.com/deleted:quadratic-polynomial-interpolation

  var y = (y_0*(((x-x_1)*(x-x_2))/((x_0-x_1)*(x_0-x_2)))) + (y_1*(((x-x_0)*(x-x_2))/((x_1-x_0)*(x_1-x_2)))) + (y_2*(((x-x_0)*(x-x_1))/((x_2-x_0)*(x_2-x_1))));

  return y;
}


get_true_min_and_index(delta2, delta1, actual_second_min_val, second_min_val_rsme_index, actualmin_val, min_val_rsme_index, lets, second) {

  if (delta2 < delta1){

    var true_min = actual_second_min_val;
    var true_min_index = second_min_val_rsme_index;

    return [true_min, true_min_index, second];
  }
  else if (delta1 < delta2){
    var true_min = actualmin_val;
    var true_min_index = min_val_rsme_index;

    return [true_min, true_min_index, lets];
  }
}


iterate_cp_and_T2_compressor(var Tentry_comp, var pressureratio, var isen_e){

  var cpo_i=cp(Tentry_comp,0,0);
  var cp_guess=cpo_i[0];

  var T2i=Tentry_comp*pow(pressureratio,(cpo_i[1]/cp_guess));
  var Tmean=(T2i+Tentry_comp)/2;

  var cpo_m=cp(Tmean,0,0);

  var residual=((cpo_m[0]-cp_guess)/cpo_m[0]).abs();

  while(residual>=0.0005){
    cp_guess++;
    T2i=Tentry_comp*pow(pressureratio,(cpo_i[1]/cp_guess));
    Tmean=(T2i+Tentry_comp)/2;
    cpo_m=cp(Tmean,0,0);

    residual=((cpo_m[0]-cp_guess)/cpo_m[0]).abs();

  }

  var cp_guess1=cpo_i[0];

  var LHS = ((cp_guess*T2i)-(cp_guess1*Tentry_comp))/isen_e;
  var total_enthalpy = LHS + (cp_guess1*Tentry_comp);
  var T2guess = total_enthalpy/cp_guess1;
  var cpT2 = cp(T2guess,0,0);

  var residual2=(((cpT2[0]*T2guess)-total_enthalpy)/total_enthalpy).abs();

  while(residual2>=0.01){
    T2guess--;
    cpT2 = cp(T2guess,0,0);
    var new_total_enthalpy = cpT2[0]*T2guess;
    residual2=((new_total_enthalpy-total_enthalpy)/total_enthalpy).abs();

  }

  var T2 = T2guess;

  return [T2, T2i, cp_guess, cp_guess1, cpT2, cpo_i[0]];

}

iterate_cp_and_T5_turbine(var T4, var FAR, var fuel_type, var mdot, var eta_t, var TW){

  var cp4_guess=cp(T4,FAR,fuel_type)[0];
  var T5_guess=T4-((TW*eta_t)/(mdot*cp4_guess));
  var T_mean=0.5*(T5_guess+T4);
  var cp45=cp(T_mean,FAR,fuel_type)[0];
  var residual=((cp4_guess-cp45)/cp4_guess).abs();

  while (residual>0.0005){
    cp4_guess--;
    T5_guess=T4-((TW*eta_t)/(mdot*cp4_guess));
    T_mean=0.5*(T5_guess+T4);
    cp45=cp(T_mean,FAR,fuel_type)[0];
    residual=((cp4_guess-cp45)/cp4_guess).abs();
  }

  var cp4_prelim = cp(T4,FAR,fuel_type)[0];
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

  return [T5_guess, T5_ideal, cp4_guess, cp45];

}


iterate_cp_T5_zeta_map(var T4, var FAR, var fuel_type, var mdot, var TW, var eta_t){

  var cp4_prelim = cp(T4,FAR,fuel_type)[0];
  var cp4_guess=cp(T4,FAR,fuel_type)[0];

  var T5_guess=T4-((TW)/(mdot*cp4_guess));

  var T_mean=0.5*(T5_guess+T4);

  var cp45=cp(T_mean,FAR,fuel_type)[0];

  var residual=((cp4_guess-cp45)/cp4_guess).abs();

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

  return [T5_guess, T5_ideal, cp4_guess, cp45];
}
