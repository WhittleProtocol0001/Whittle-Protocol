import 'dart:math';
import 'package:engine_id/algorithims/utility_methods.dart';
import 'package:engine_id/atmosphere_and%20_fuels/atmosphere.dart';
import 'off_design_scaling.dart';

find_eff_turb_simplified(var wc_i, var elements, var zeta_des, var nc_turb_selected,
    var zeta_array, var ncdes_array, var zeta_threshold, var eff_map){

  //find the ncrdes rsme min value matrix - step 1
  var rsme_test = rsme_scaled_map(wc_i, elements); //find the ncrdes rsme min value matrix
  var first = find_minimum_value_and_index(rsme_test[1]); //find min value and index of lowset rsme value
  var second = find_second_min_value_and_index(first[1], rsme_test[1]);
  var rsme_matrix_unsorted = rsme_scaled_map_without_sorting(wc_i, elements);

  //localize zeta indices
  var zeta_indices =  _get_local_indices_of_zeta(zeta_des, zeta_array);
  var index_of_zeta_value_greater_than = zeta_indices[0];
  var index_of_zeta_value_lesser_than = zeta_indices[1];

  //localize ncdes indices
  var ncdes_indices =  _get_local_indices_of_ncdes(nc_turb_selected, ncdes_array);
  var index_of_nc_value_greater_than = ncdes_indices[0];
  var index_of_nc_value_lower_than = ncdes_indices[1];


  if (index_of_nc_value_greater_than < 0 || index_of_nc_value_lower_than<0){
    index_of_nc_value_greater_than = 1;
    index_of_nc_value_lower_than = 0;
  }

  //create rsme lists for zeta indices higher and zeta indices lower, throughout the span of the ncdes array
  List rsme_values_greater_than_zeta_prev_index_= [];
  List rsme_values_lower_than_zeta_prev_index_= [];
  for (var i=0; i<ncdes_array.length; i++){
    rsme_values_greater_than_zeta_prev_index_.add(rsme_matrix_unsorted[i][index_of_zeta_value_greater_than]);
    rsme_values_lower_than_zeta_prev_index_.add(rsme_matrix_unsorted[i][index_of_zeta_value_lesser_than]);
  }

  //find indices of the min value of the preceding lists
  var min_value_and_index_of_rsme_values_greater_than_zeta_prev_index = find_minimum_value_and_index(rsme_values_greater_than_zeta_prev_index_);
  var min_value_and_index_of_rsme_values_lower_than_zeta_prev_index = find_minimum_value_and_index(rsme_values_lower_than_zeta_prev_index_);

  //find indices of the second min value of the preceding lists
  var second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index =
  find_second_min_value_and_index(min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1], rsme_values_greater_than_zeta_prev_index_);
  var second_min_value_and_index_of_rsme_values_lower_than_zeta_prev_index =
  find_second_min_value_and_index(min_value_and_index_of_rsme_values_lower_than_zeta_prev_index[1], rsme_values_lower_than_zeta_prev_index_);


  var wc_nc_des_lower_value_and_zeta_des_upper_value = elements[min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_greater_than];
  var wc_nc_des_lower_value_and_zeta_des_lower_value = elements[min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_lesser_than];
  var eff_nc_des_lower_value_and_zeta_des_upper_value = eff_map[min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_greater_than];
  var eff_nc_des_lower_value_and_zeta_des_lower_value = eff_map[min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_lesser_than];
  var ncdes_index_lower =  min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1];

  var wc_nc_des_upper_value_and_zeta_des_upper_value = elements[second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_greater_than];
  var wc_nc_des_upper_value_and_zeta_des_lower_value = elements[second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_lesser_than];
  var eff_nc_des_upper_value_and_zeta_des_upper_value = eff_map[second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_greater_than];
  var eff_nc_des_upper_value_and_zeta_des_lower_value = eff_map[second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1]][index_of_zeta_value_lesser_than];
  var ncdes_index_upper = second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1];


  //check if rsme approach fails therefore, re-localize based on provided inputs
  if((wc_i < wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i < wc_nc_des_lower_value_and_zeta_des_lower_value &&
      wc_i < wc_nc_des_upper_value_and_zeta_des_upper_value && wc_i < wc_nc_des_upper_value_and_zeta_des_lower_value) ||
      (wc_i > wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i > wc_nc_des_lower_value_and_zeta_des_lower_value &&
          wc_i > wc_nc_des_upper_value_and_zeta_des_upper_value && wc_i > wc_nc_des_upper_value_and_zeta_des_lower_value) ||
      ((second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1] != second_min_value_and_index_of_rsme_values_lower_than_zeta_prev_index[1])) ||
      (min_value_and_index_of_rsme_values_greater_than_zeta_prev_index[1] != min_value_and_index_of_rsme_values_lower_than_zeta_prev_index[1])
  ){

    wc_nc_des_lower_value_and_zeta_des_upper_value = elements[index_of_nc_value_lower_than][index_of_zeta_value_greater_than];
    wc_nc_des_lower_value_and_zeta_des_lower_value = elements[index_of_nc_value_lower_than][index_of_zeta_value_lesser_than];
    eff_nc_des_lower_value_and_zeta_des_upper_value = eff_map[index_of_nc_value_lower_than][index_of_zeta_value_greater_than];
    eff_nc_des_lower_value_and_zeta_des_lower_value = eff_map[index_of_nc_value_lower_than][index_of_zeta_value_lesser_than];
    ncdes_index_lower = index_of_nc_value_lower_than;

    wc_nc_des_upper_value_and_zeta_des_upper_value = elements[index_of_nc_value_greater_than][index_of_zeta_value_greater_than];
    wc_nc_des_upper_value_and_zeta_des_lower_value = elements[index_of_nc_value_greater_than][index_of_zeta_value_lesser_than];
    eff_nc_des_upper_value_and_zeta_des_upper_value = eff_map[index_of_nc_value_greater_than][index_of_zeta_value_greater_than];
    eff_nc_des_upper_value_and_zeta_des_lower_value = eff_map[index_of_nc_value_greater_than][index_of_zeta_value_lesser_than];
    ncdes_index_upper = index_of_nc_value_greater_than;
  }

  //alternate condition 1: corrected mass flow is lower than the left two value and greater than the right two , zeta=0.24
  var condition_one = (wc_i < wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i < wc_nc_des_upper_value_and_zeta_des_upper_value) &&
      (wc_i > wc_nc_des_lower_value_and_zeta_des_lower_value && wc_i > wc_nc_des_upper_value_and_zeta_des_lower_value);
  if (condition_one){

    return _get_eff_condition_one(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
        wc_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
        eff_nc_des_lower_value_and_zeta_des_lower_value, wc_nc_des_upper_value_and_zeta_des_upper_value,
        wc_nc_des_upper_value_and_zeta_des_lower_value,
        eff_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_lower_value,
        zeta_array,index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
        , ncdes_array, ncdes_index_lower, ncdes_index_upper);

  }
  //alternate condition 2: corrected mass flow is between than the left two value and greater than the right two , zeta=0.19, ncdes =0.905
  var condition_two = (wc_i < wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i > wc_nc_des_upper_value_and_zeta_des_upper_value) &&
      (wc_i > wc_nc_des_lower_value_and_zeta_des_lower_value && wc_i > wc_nc_des_upper_value_and_zeta_des_lower_value);
  if (condition_two){

    return _get_eff_condition_two(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
        wc_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
        eff_nc_des_lower_value_and_zeta_des_lower_value, wc_nc_des_upper_value_and_zeta_des_upper_value,
        eff_nc_des_upper_value_and_zeta_des_upper_value, zeta_array,index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
        , ncdes_array, ncdes_index_lower, ncdes_index_upper);

  }

  //alternate condition 3: corrected mass flow is lower than the left two value and between the right two , zeta=0.19, ncdes =0.97
  var condition_three = (wc_i < wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i < wc_nc_des_upper_value_and_zeta_des_upper_value) &&
      (wc_i < wc_nc_des_lower_value_and_zeta_des_lower_value && wc_i > wc_nc_des_upper_value_and_zeta_des_lower_value);
  if (condition_three){

    return _get_eff_condition_three(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i,
        wc_nc_des_upper_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_lower_value,
        eff_nc_des_upper_value_and_zeta_des_lower_value, wc_nc_des_upper_value_and_zeta_des_upper_value,
        eff_nc_des_upper_value_and_zeta_des_upper_value, zeta_array, index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
        , ncdes_array, ncdes_index_lower, ncdes_index_upper);
  }

  //alternate condition 4: corrected mass flow is between the left two value and greater than the right two , zeta=0.19, ncdes =1.03
  var condition_four = (wc_i > wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i < wc_nc_des_upper_value_and_zeta_des_upper_value) &&
      (wc_i > wc_nc_des_lower_value_and_zeta_des_lower_value && wc_i > wc_nc_des_upper_value_and_zeta_des_lower_value);
  if (condition_four){

    return _get_eff_condition_four(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
        wc_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
        eff_nc_des_upper_value_and_zeta_des_upper_value, wc_nc_des_upper_value_and_zeta_des_lower_value,
        eff_nc_des_upper_value_and_zeta_des_lower_value, zeta_array, index_of_zeta_value_greater_than,
        index_of_zeta_value_lesser_than, ncdes_array, ncdes_index_lower, ncdes_index_upper);
  }

  //alternate condition 5: corrected mass flow is between the left two value and between the right two , zeta=0.3, ncdes =0.97
  if ((wc_i < wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i > wc_nc_des_upper_value_and_zeta_des_upper_value) &&
      (wc_i < wc_nc_des_lower_value_and_zeta_des_lower_value && wc_i > wc_nc_des_upper_value_and_zeta_des_lower_value)){

    return _get_eff_condition_five(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i, wc_nc_des_upper_value_and_zeta_des_upper_value,
        eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value,
        wc_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_lower_value,
        zeta_array, index_of_zeta_value_greater_than,
        index_of_zeta_value_lesser_than, ncdes_array, ncdes_index_lower, ncdes_index_upper);
  }

  //alternate condition 6: corrected mass flow is lower than the left two value and between the right two , zeta=0.32, ncdes =0.895
  var condition_six = (wc_i < wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i < wc_nc_des_upper_value_and_zeta_des_upper_value) &&
      (wc_i > wc_nc_des_lower_value_and_zeta_des_lower_value && wc_i < wc_nc_des_upper_value_and_zeta_des_lower_value);
  if (condition_six){

    return _get_eff_condition_six(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i,
        wc_nc_des_upper_value_and_zeta_des_lower_value, ncdes_array, ncdes_index_upper, ncdes_index_lower,
        zeta_array, index_of_zeta_value_greater_than, zeta_des, index_of_zeta_value_lesser_than, wc_nc_des_lower_value_and_zeta_des_upper_value,
        wc_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_lower_value,
        eff_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_lower_value);

  }


  //alternate condition 7: choked conditions , zeta=0.72, ncdes =0.895
  var condition_seven = (wc_nc_des_lower_value_and_zeta_des_upper_value == wc_nc_des_lower_value_and_zeta_des_lower_value) &&
      (wc_nc_des_upper_value_and_zeta_des_upper_value == wc_nc_des_upper_value_and_zeta_des_lower_value) &&
      (wc_i > wc_nc_des_lower_value_and_zeta_des_upper_value && wc_i < wc_nc_des_upper_value_and_zeta_des_upper_value);
  if (condition_seven){
    return get_eff_for_condition_seven(wc_nc_des_lower_value_and_zeta_des_upper_value,
        wc_i, wc_nc_des_upper_value_and_zeta_des_upper_value,
        ncdes_array, min_value_and_index_of_rsme_values_greater_than_zeta_prev_index,
        second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index, ncdes_index_lower, ncdes_index_upper,
        eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value,
        eff_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_lower_value, zeta_array,
        index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than);

  }

  var condition_eight = (wc_i == wc_nc_des_lower_value_and_zeta_des_upper_value || wc_i == wc_nc_des_lower_value_and_zeta_des_lower_value
      || wc_i == wc_nc_des_upper_value_and_zeta_des_upper_value || wc_i == wc_nc_des_upper_value_and_zeta_des_lower_value);
  if (condition_eight) {

    if (wc_i == wc_nc_des_lower_value_and_zeta_des_upper_value) {
      return [zeta_des, nc_turb_selected, eff_nc_des_lower_value_and_zeta_des_upper_value];
    }

    if (wc_i == wc_nc_des_lower_value_and_zeta_des_lower_value){
      return [zeta_des, nc_turb_selected, eff_nc_des_lower_value_and_zeta_des_lower_value];
    }

    if (wc_i == wc_nc_des_upper_value_and_zeta_des_upper_value) {
      return [zeta_des, nc_turb_selected, eff_nc_des_upper_value_and_zeta_des_upper_value];
    }

    if (wc_i == wc_nc_des_upper_value_and_zeta_des_lower_value) {
      return [zeta_des, nc_turb_selected, eff_nc_des_upper_value_and_zeta_des_lower_value];
    }

  }

  var condition_nine = (wc_i>wc_nc_des_lower_value_and_zeta_des_upper_value && wc_nc_des_upper_value_and_zeta_des_upper_value>wc_i)
  && (wc_i>wc_nc_des_lower_value_and_zeta_des_lower_value && wc_nc_des_upper_value_and_zeta_des_lower_value>wc_i);
  if (condition_nine){
    var zeta_avg = (zeta_array[index_of_zeta_value_greater_than]+zeta_array[index_of_zeta_value_lesser_than])/2;
    var nc_des_left = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i, wc_nc_des_upper_value_and_zeta_des_upper_value,
        ncdes_array[index_of_nc_value_lower_than], ncdes_array[index_of_nc_value_greater_than]);
    var nc_des_right = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i, wc_nc_des_upper_value_and_zeta_des_lower_value,
        ncdes_array[index_of_nc_value_lower_than], ncdes_array[index_of_nc_value_greater_than]);
    var nc_des_avg = (nc_des_left+nc_des_right)/2;

    var eff_left = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i, wc_nc_des_upper_value_and_zeta_des_upper_value,
        eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value);
    var eff_right = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i, wc_nc_des_upper_value_and_zeta_des_lower_value,
        eff_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_lower_value);
    var eff_avg = (eff_left+eff_right)/2;

    return [zeta_avg, nc_des_avg, eff_avg];
  }

  var condition_ten = (wc_i<wc_nc_des_lower_value_and_zeta_des_upper_value && wc_nc_des_upper_value_and_zeta_des_upper_value > wc_i) &&
      (wc_i<wc_nc_des_lower_value_and_zeta_des_lower_value && wc_nc_des_upper_value_and_zeta_des_lower_value>wc_i);
  if (condition_ten){
    var zeta_avg = (zeta_array[index_of_zeta_value_greater_than]+zeta_array[index_of_zeta_value_lesser_than])/2;
    var nc_des_avg = ncdes_array[index_of_nc_value_lower_than];
    var eff_left = linear_interpolate( wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,wc_nc_des_upper_value_and_zeta_des_upper_value,
        eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value);
    var eff_right = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i, wc_nc_des_upper_value_and_zeta_des_lower_value,
        eff_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_lower_value);
    var eff_avg = (eff_left+eff_right)/2;

    return [zeta_avg, nc_des_avg, eff_avg];
  }

  var condition_eleven = (wc_i>wc_nc_des_lower_value_and_zeta_des_upper_value && wc_nc_des_upper_value_and_zeta_des_upper_value < wc_i) &&
      (wc_i>wc_nc_des_lower_value_and_zeta_des_lower_value && wc_nc_des_upper_value_and_zeta_des_lower_value<wc_i);
  if (condition_eleven){
    var zeta_avg = (zeta_array[index_of_zeta_value_greater_than]+zeta_array[index_of_zeta_value_lesser_than])/2;
    var nc_des_avg = (ncdes_array[index_of_nc_value_lower_than] + ncdes_array[index_of_nc_value_lower_than])/2;
    var eff_values = [eff_nc_des_lower_value_and_zeta_des_upper_value,eff_nc_des_upper_value_and_zeta_des_upper_value
      ,eff_nc_des_lower_value_and_zeta_des_lower_value,eff_nc_des_upper_value_and_zeta_des_lower_value];

    return [zeta_avg, nc_des_avg, eff_values[3]];
  }

  throw('Zeta, Ncdes and eff appears to be outside the specified map');
}

//Conditions to traverse the map
_get_eff_condition_five(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i, wc_nc_des_upper_value_and_zeta_des_upper_value,
    eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value,
    wc_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_lower_value,
    zeta_array, index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than, ncdes_array, ncdes_index_lower, ncdes_index_upper){


  var eff_nc_des = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
      wc_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_upper_value);

  var eff_ref = eff_nc_des;

  var ncdes_average = linear_interpolate(eff_nc_des_lower_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_upper_value_and_zeta_des_upper_value, ncdes_array[ncdes_index_upper], ncdes_array[ncdes_index_lower]);

  var zeta_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_lower_value_and_zeta_des_lower_value, zeta_array[index_of_zeta_value_greater_than], zeta_array[index_of_zeta_value_lesser_than]);

  return [zeta_average, ncdes_average, eff_ref];
}

_get_eff_condition_four(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
    wc_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
    eff_nc_des_upper_value_and_zeta_des_upper_value, wc_nc_des_upper_value_and_zeta_des_lower_value,
    eff_nc_des_upper_value_and_zeta_des_lower_value, zeta_array, index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
    , ncdes_array, ncdes_index_lower, ncdes_index_upper) {

  var eff_nc_des = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
      wc_nc_des_upper_value_and_zeta_des_upper_value,
      eff_nc_des_lower_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_upper_value);

  var eff_zeta = linear_interpolate(wc_nc_des_upper_value_and_zeta_des_upper_value, wc_i,
      wc_nc_des_upper_value_and_zeta_des_lower_value,
      eff_nc_des_upper_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_lower_value);

  var eff_ref = (eff_nc_des + eff_zeta)/2;

  var ncdes_average = linear_interpolate(eff_nc_des_lower_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_upper_value_and_zeta_des_upper_value, ncdes_array[ncdes_index_upper], ncdes_array[ncdes_index_lower]);

  var zeta_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_upper_value_and_zeta_des_lower_value, zeta_array[index_of_zeta_value_greater_than], zeta_array[index_of_zeta_value_lesser_than]);

  return [zeta_average, ncdes_average, eff_ref];
}

_get_eff_condition_three(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i, wc_nc_des_upper_value_and_zeta_des_lower_value,
    eff_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_lower_value, wc_nc_des_upper_value_and_zeta_des_upper_value,
    eff_nc_des_upper_value_and_zeta_des_upper_value, zeta_array, index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
    , ncdes_array, ncdes_index_lower, ncdes_index_upper) {

  var eff_nc_des = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i,
      wc_nc_des_upper_value_and_zeta_des_lower_value,
      eff_nc_des_lower_value_and_zeta_des_lower_value,
      eff_nc_des_upper_value_and_zeta_des_lower_value);

  var eff_zeta = linear_interpolate(wc_nc_des_upper_value_and_zeta_des_upper_value, wc_i,
      wc_nc_des_upper_value_and_zeta_des_lower_value,
      eff_nc_des_upper_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_lower_value);

  var eff_ref = (eff_nc_des + eff_zeta)/2;

  var ncdes_average = linear_interpolate(eff_nc_des_lower_value_and_zeta_des_lower_value, eff_ref,
      eff_nc_des_upper_value_and_zeta_des_lower_value, ncdes_array[ncdes_index_upper], ncdes_array[ncdes_index_lower]);

  var zeta_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_lower_value_and_zeta_des_lower_value, zeta_array[index_of_zeta_value_greater_than], zeta_array[index_of_zeta_value_lesser_than]);

  return [zeta_average, ncdes_average, eff_ref];
}

_get_eff_condition_two(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i, wc_nc_des_lower_value_and_zeta_des_lower_value,
    eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_lower_value,
    wc_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value,
    zeta_array, index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
    , ncdes_array, ncdes_index_lower, ncdes_index_upper) {

  var eff_zeta = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
      wc_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
      eff_nc_des_lower_value_and_zeta_des_lower_value);

  var eff_nc_des = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
      wc_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_upper_value);

  var eff_ref = (eff_zeta + eff_nc_des)/2;

  var ncdes_average = linear_interpolate(eff_nc_des_lower_value_and_zeta_des_upper_value, eff_ref, eff_nc_des_upper_value_and_zeta_des_upper_value,
      ncdes_array[ncdes_index_lower], ncdes_array[ncdes_index_upper]);

  var zeta_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_lower_value_and_zeta_des_lower_value, zeta_array[index_of_zeta_value_lesser_than], zeta_array[index_of_zeta_value_greater_than]);

  return [zeta_average, ncdes_average, eff_ref];
}

_get_eff_condition_one(wc_nc_des_lower_value_and_zeta_des_upper_value, wc_i,
    wc_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_lower_value_and_zeta_des_upper_value,
    eff_nc_des_lower_value_and_zeta_des_lower_value, wc_nc_des_upper_value_and_zeta_des_upper_value,
    wc_nc_des_upper_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_upper_value,
    eff_nc_des_upper_value_and_zeta_des_lower_value, zeta_array,index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than
    , ncdes_array, ncdes_index_lower, ncdes_index_upper) {

  var eff_zeta_lower = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value,
      wc_i, wc_nc_des_lower_value_and_zeta_des_lower_value,
      eff_nc_des_lower_value_and_zeta_des_upper_value,
      eff_nc_des_lower_value_and_zeta_des_lower_value);

  var eff_zeta_upper = linear_interpolate(wc_nc_des_upper_value_and_zeta_des_upper_value,
      wc_i, wc_nc_des_upper_value_and_zeta_des_lower_value,
      eff_nc_des_upper_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_lower_value);

  var eff_ref = (eff_zeta_lower + eff_zeta_upper)/2;

  var zeta_average = linear_interpolate(eff_nc_des_lower_value_and_zeta_des_upper_value, eff_ref, eff_nc_des_lower_value_and_zeta_des_lower_value,
      zeta_array[index_of_zeta_value_greater_than], zeta_array[index_of_zeta_value_lesser_than]);

  var nc_des_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref,
      eff_nc_des_lower_value_and_zeta_des_lower_value, ncdes_array[ncdes_index_lower], ncdes_array[ncdes_index_upper]);

  return [zeta_average, nc_des_average, eff_ref];
}

_get_eff_condition_six(wc_nc_des_lower_value_and_zeta_des_lower_value, wc_i, wc_nc_des_upper_value_and_zeta_des_lower_value,
    ncdes_array, ncdes_index_upper, ncdes_index_lower, zeta_array, index_of_zeta_value_greater_than, zeta_des,
    index_of_zeta_value_lesser_than, wc_nc_des_lower_value_and_zeta_des_upper_value, wc_nc_des_upper_value_and_zeta_des_upper_value,
    eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_upper_value,
    eff_nc_des_upper_value_and_zeta_des_lower_value) {

  var ncdes_right_intp = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_lower_value,
      wc_i,wc_nc_des_upper_value_and_zeta_des_lower_value,
      ncdes_array[ncdes_index_upper],
      ncdes_array[ncdes_index_lower]);

  var wc_left_intp = linear_interpolate(zeta_array[index_of_zeta_value_greater_than],
      zeta_des,zeta_array[index_of_zeta_value_lesser_than],
      wc_nc_des_lower_value_and_zeta_des_upper_value,
      wc_nc_des_lower_value_and_zeta_des_lower_value);

  var wc_right_intp = linear_interpolate(zeta_array[index_of_zeta_value_greater_than],
      zeta_des,zeta_array[index_of_zeta_value_lesser_than],
      wc_nc_des_upper_value_and_zeta_des_upper_value,
      wc_nc_des_upper_value_and_zeta_des_lower_value);

  var ncdes_left_intp = linear_interpolate(wc_left_intp,
      wc_i,wc_right_intp,
      ncdes_array[ncdes_index_upper],
      ncdes_array[ncdes_index_lower]);

  var ncdes_average = (ncdes_right_intp + ncdes_left_intp)/2;

  var eff_upper_intp = linear_interpolate(zeta_array[index_of_zeta_value_greater_than],
      zeta_des,zeta_array[index_of_zeta_value_lesser_than],
      eff_nc_des_lower_value_and_zeta_des_upper_value,
      eff_nc_des_lower_value_and_zeta_des_lower_value);

  var eff_lower_intp = linear_interpolate(zeta_array[index_of_zeta_value_greater_than],
      zeta_des,zeta_array[index_of_zeta_value_lesser_than],
      eff_nc_des_upper_value_and_zeta_des_upper_value,
      eff_nc_des_upper_value_and_zeta_des_lower_value);

  var eff_ref = linear_interpolate(ncdes_array[ncdes_index_upper], ncdes_average,
      ncdes_array[ncdes_index_lower]
      , eff_upper_intp, eff_lower_intp);

  var nc_des_avg = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_lower_value, eff_ref,
      eff_nc_des_lower_value_and_zeta_des_lower_value, ncdes_array[ncdes_index_upper], ncdes_array[ncdes_index_lower]);

  var zeta_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_lower_value, eff_ref,
      eff_nc_des_lower_value_and_zeta_des_lower_value,
      zeta_array[index_of_zeta_value_greater_than], zeta_array[index_of_zeta_value_lesser_than]);

  return [zeta_average, nc_des_avg, eff_ref];
}

get_eff_for_condition_seven(wc_nc_des_lower_value_and_zeta_des_upper_value,
    wc_i, wc_nc_des_upper_value_and_zeta_des_upper_value, ncdes_array,
    min_value_and_index_of_rsme_values_greater_than_zeta_prev_index,
    second_min_value_and_index_of_rsme_values_greater_than_zeta_prev_index, ncdes_index_lower, ncdes_index_upper,
    eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value, eff_nc_des_lower_value_and_zeta_des_lower_value,
    eff_nc_des_upper_value_and_zeta_des_lower_value, zeta_array, index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than) {

  var ncdes_average = linear_interpolate(wc_nc_des_lower_value_and_zeta_des_upper_value,
      wc_i,wc_nc_des_upper_value_and_zeta_des_upper_value,
      ncdes_array[ncdes_index_upper],
      ncdes_array[ncdes_index_lower]);

  var eff_mid_value_lower = linear_interpolate(ncdes_array[ncdes_index_lower],
      ncdes_average,ncdes_array[ncdes_index_upper],
      eff_nc_des_lower_value_and_zeta_des_upper_value, eff_nc_des_upper_value_and_zeta_des_upper_value);
  var eff_mid_value_upper = linear_interpolate(ncdes_array[ncdes_index_lower],
      ncdes_average,ncdes_array[ncdes_index_upper],
      eff_nc_des_lower_value_and_zeta_des_lower_value, eff_nc_des_upper_value_and_zeta_des_lower_value);
  var eff_ref = (eff_mid_value_lower + eff_mid_value_upper)/2;

  var zeta_average = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref, eff_nc_des_lower_value_and_zeta_des_lower_value,
      zeta_array[index_of_zeta_value_lesser_than], zeta_array[index_of_zeta_value_greater_than]);

  var ncdes_avg = linear_interpolate(eff_nc_des_upper_value_and_zeta_des_upper_value, eff_ref, eff_nc_des_lower_value_and_zeta_des_lower_value,
      ncdes_array[ncdes_index_lower],
      ncdes_array[ncdes_index_upper]);

  return [zeta_average, ncdes_avg, eff_ref];
}

_get_local_indices_of_zeta(var zeta_des, var zeta_array){

  var reversed_lists_zeta = new List.from(zeta_array.reversed);
  var dp_zeta_value_close = reversed_lists_zeta.where((e) => e >= zeta_des).toList()..sort();
  var index_of_zeta_value_greater_than = zeta_array.indexOf(dp_zeta_value_close.first);
  var index_of_zeta_value_lesser_than = index_of_zeta_value_greater_than + 1;

  return [index_of_zeta_value_greater_than, index_of_zeta_value_lesser_than];
}

_get_local_indices_of_ncdes(var nc_turb_selected, var ncdes_array){

  var reversed_lists_nc_des = new List.from(ncdes_array.reversed);
  var dp_nc_des_value_close = reversed_lists_nc_des.where((e) => e >= nc_turb_selected).toList()..sort();
  var index_of_nc_value_greater_than = ncdes_array.indexOf(dp_nc_des_value_close.first);
  var index_of_nc_value_lower_than = index_of_nc_value_greater_than - 1;

  return [index_of_nc_value_greater_than, index_of_nc_value_lower_than];
}

get_derived_scaled_maps_turbine(T4, P4, mdot, zeta_selected, nc_des_selected, hpt_map_values, eta_t) {
  var wc1 = CorrectedMassFlow(T4, P4, mdot);


  // derive scale factors for the corresponding maps
  var SF_Wc = derive_scale_factor_beta_ncdes_special_case(wc1, zeta_selected,
      nc_des_selected, hpt_map_values[0], hpt_map_values[1], hpt_map_values[2]);

  var SF_Eff = derive_scale_factor_beta_ncdes_special_case(eta_t, zeta_selected,
      nc_des_selected, hpt_map_values[0], hpt_map_values[1], hpt_map_values[3]);

  // derive scaled maps
  var scaled_map_Wc = scale_map(SF_Wc, hpt_map_values[2]);
  var scaled_map_Eff = scale_map(SF_Eff, hpt_map_values[3]);

  return [scaled_map_Wc, scaled_map_Eff];
}
