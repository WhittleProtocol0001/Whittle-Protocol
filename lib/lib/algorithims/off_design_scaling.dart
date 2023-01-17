import 'dart:math';
import 'package:engine_id/algorithims/utility_methods.dart';


derive_scale_factor_beta_ncdes(var value_for_scaling, var beta_select,
    var ncdes_select, var beta, var ncdes, var map_list) {

  var map_value;
  var interpolated_list;
  var ncdes_vals_and_indices;
  var beta_vals_and_indices;
  var scale_factor;


  ncdes_vals_and_indices = find_x1_and_x3_in_list(ncdes_select, ncdes);
  interpolated_list = linear_interpolate_list(
      ncdes_vals_and_indices[0],
      ncdes_select,
      ncdes_vals_and_indices[1],
      map_list[ncdes_vals_and_indices[2]],
      map_list[ncdes_vals_and_indices[3]]);
  beta_vals_and_indices = find_x1_and_x3_in_list(beta_select, beta);
  map_value = linear_interpolate(
      beta_vals_and_indices[0],
      beta_select,
      beta_vals_and_indices[1],
      interpolated_list[beta_vals_and_indices[2]],
      interpolated_list[beta_vals_and_indices[3]]);

  scale_factor = value_for_scaling / map_value;

  return scale_factor;
}


derive_scale_factor_beta_ncdes_special_case(var value_for_scaling, var beta_select,
    var ncdes_select, var beta, var ncdes, var map_list) {

  var map_value;
  var interpolated_list;
  var ncdes_vals_and_indices;
  var beta_vals_and_indices;
  var scale_factor;


  ncdes_vals_and_indices = find_x1_and_x3_in_list(ncdes_select, ncdes);

  interpolated_list = linear_interpolate_list(
      ncdes_vals_and_indices[0],
      ncdes_select,
      ncdes_vals_and_indices[1],
      map_list[ncdes_vals_and_indices[2]],
      map_list[ncdes_vals_and_indices[3]]);
  //quadratic interpolation and limit the turb zeta values to 0.35 for all maps
  beta_vals_and_indices = find_x1_and_x3_and_x4_in_list_special_case(beta_select, beta);
  map_value = linear_interpolate(
      beta_vals_and_indices[0][2],
      beta_select,
      beta_vals_and_indices[0][0],
      interpolated_list[beta_vals_and_indices[1][1]],
      interpolated_list[beta_vals_and_indices[1][0]]);

  scale_factor = value_for_scaling / map_value;

  return scale_factor;
}


scale_map(var scale_factor, var map_scale) {
  var scaled_map = [];
  var calc_sf_multiply;

  for (var i = 0; i < map_scale.length; i++) {
    calc_sf_multiply = [for (var e in map_scale[i]) e * scale_factor];
    scaled_map.add(calc_sf_multiply);
  }

  return scaled_map;
}


scale_map_skewewd(var scale_factor, var map_scale) {
  var scaled_map = [];
  var calc_sf_multiply;

  for (var i = 0; i < map_scale.length; i++) {
    calc_sf_multiply = [for (var e in map_scale[i]) e * scale_factor[i]];
    scaled_map.add(calc_sf_multiply);
  }

  return scaled_map;
}


sf_array(var ncdes_array, var ncdes_design, var sf_design){
  var sf_arrays = [];
  var calc_skewed_sfs;

  if (sf_design >= 1) {
    for (var i = 0; i < ncdes_array.length; i++) {
      calc_skewed_sfs = (((sf_design - 1) / (ncdes_design - ncdes_array[0])) *
          (ncdes_array[i] - ncdes_array[0])) + 1;
      sf_arrays.add(calc_skewed_sfs);
    }

    return sf_arrays;
  }

  if (sf_design < 1) {
    for (var i = 0; i < ncdes_array.length; i++) {
      var calc_sf = ncdes_array[i]*(sf_design/ncdes_design);
      sf_arrays.add(calc_sf);
    }

    return sf_arrays;
  }
}


find_avg_beta_and_nc_des(
    var min_val_rsme_index,
    var actualmin_val,
    var second_min_val_rsme_index,
    var actual_second_min_val,
    var y1,
    var y3,
    var wc_i,
    var elements,
    var first,
    var second,
    var ncdes1,
    var ncdes2,
    var shiftstate) {

  //scenario 1
  if (shiftstate == "up") {
    //beta averaging
    var beta1 = linear_interpolate(
        actualmin_val, wc_i, elements[first][min_val_rsme_index + 1], y1, y3);
    var beta2 = linear_interpolate(actual_second_min_val, wc_i,
        elements[second][second_min_val_rsme_index + 1], y1, y3);
    var beta_avg = (beta1 + beta2) / 2;

    //derive wc range
    var wc_beta1 = linear_interpolate(y1, beta_avg, y3, actualmin_val,
        elements[first][min_val_rsme_index + 1]);
    var wc_beta2 = linear_interpolate(y1, beta_avg, y3, actual_second_min_val,
        elements[second][second_min_val_rsme_index + 1]);

    //derive nc des, refine with more robust methods
    var nc_des_avg =
    linear_interpolate(wc_beta1, wc_i, wc_beta2, ncdes1, ncdes2);

    return [beta_avg, nc_des_avg];
  }
  // scenario 2
  else if (shiftstate == "down") {
    //beta averaging
    var beta1 = linear_interpolate(
        actualmin_val, wc_i, elements[first][min_val_rsme_index - 1], y1, y3);
    var beta2 = linear_interpolate(actual_second_min_val, wc_i,
        elements[second][second_min_val_rsme_index - 1], y1, y3);
    var beta_avg = (beta1 + beta2) / 2;

    //derive wc range
    var wc_beta1 = linear_interpolate(y1, beta_avg, y3, actualmin_val,
        elements[first][min_val_rsme_index - 1]);
    var wc_beta2 = linear_interpolate(y1, beta_avg, y3, actual_second_min_val,
        elements[second][second_min_val_rsme_index - 1]);

    //derive nc des, refine with more robust methods
    var nc_des_avg =
    linear_interpolate(wc_beta1, wc_i, wc_beta2, ncdes1, ncdes2);

    return [beta_avg, nc_des_avg];
  }
}


find_avg_beta_and_nc_des_special_case(
    var min_val_rsme_index,
    var actualmin_val,
    var second_min_val_rsme_index,
    var actual_second_min_val,
    var y1,
    var y2,
    var y3,
    var wc_i,
    var elements,
    var first,
    var second,
    var ncdes1,
    var ncdes2) {

  //beta averaging
  var beta1 = linear_interpolate(
      actualmin_val, wc_i, elements[first][min_val_rsme_index - 1], y1, y2);
  var beta2 = linear_interpolate(actual_second_min_val, wc_i,
      elements[second][second_min_val_rsme_index + 1], y2, y3);
  var beta_avg = (beta1 + beta2) / 2;

  //derive wc range
  var wc_beta1 = linear_interpolate(
      y1, beta_avg, y3, actualmin_val, elements[first][min_val_rsme_index - 1]);
  var wc_beta2 = linear_interpolate(y1, beta_avg, y3, actual_second_min_val,
      elements[second][second_min_val_rsme_index + 1]);

  //derive nc des, refine with more robust methods
  var nc_des_avg = linear_interpolate(wc_beta1, wc_i, wc_beta2, ncdes1, ncdes2);

  return [beta_avg, nc_des_avg];
}


find_nc_des_first_then_beta_avg_norm(
    var wc_i,
    var elements,
    var y1,
    var y2,
    var y3,
    var min_val_rsme_index,
    var actualmin_val,
    var first,
    var beta1,
    var beta2,
    var shiftstate) {

  if (shiftstate == 'down') {
    //nc_des averaging
    var ncdes1 = linear_interpolate(
        actualmin_val, wc_i, elements[first - 1][min_val_rsme_index], y2, y1);
    var ncdes2 = linear_interpolate(elements[first][min_val_rsme_index + 1],
        wc_i, elements[first + 1][min_val_rsme_index + 1], y2, y3);
    var ncdes_avg = (ncdes1 + ncdes2) / 2;

    if (ncdes_avg > y2) {
      //beta averaging
      var wc_ncdes1 = linear_interpolate(
          y2,
          ncdes_avg,
          y3,
          elements[first][min_val_rsme_index],
          elements[first + 1][min_val_rsme_index]);
      var wc_ncdes2 = linear_interpolate(
          y2,
          ncdes_avg,
          y3,
          elements[first][min_val_rsme_index + 1],
          elements[first + 1][min_val_rsme_index + 1]);

      var beta_avg =
      linear_interpolate(wc_ncdes1, wc_i, wc_ncdes2, beta1, beta2);

      return [beta_avg, ncdes_avg];
    } else if (ncdes_avg <= y2) {
      //beta averaging
      var wc_ncdes1 = linear_interpolate(
          y1,
          ncdes_avg,
          y2,
          elements[first - 1][min_val_rsme_index],
          elements[first][min_val_rsme_index]);
      var wc_ncdes2 = linear_interpolate(
          y1,
          ncdes_avg,
          y2,
          elements[first - 1][min_val_rsme_index + 1],
          elements[first][min_val_rsme_index + 1]);

      var beta_avg =
      linear_interpolate(wc_ncdes1, wc_i, wc_ncdes2, beta1, beta2);

      return [beta_avg, ncdes_avg];
    }
  }

  if (shiftstate == 'up') {
    //nc_des averaging
    var ncdes1 = linear_interpolate(elements[first - 1][min_val_rsme_index - 1],
        wc_i, elements[first][min_val_rsme_index - 1], y1, y2);
    var ncdes2 = linear_interpolate(elements[first][min_val_rsme_index], wc_i,
        elements[first + 1][min_val_rsme_index], y2, y3);
    var ncdes_avg = (ncdes1 + ncdes2) / 2;

    if (ncdes_avg > y2) {
      //beta averaging
      var wc_ncdes1 = linear_interpolate(
          y2,
          ncdes_avg,
          y3,
          elements[first][min_val_rsme_index - 1],
          elements[first + 1][min_val_rsme_index - 1]);
      var wc_ncdes2 = linear_interpolate(
          y2,
          ncdes_avg,
          y3,
          elements[first][min_val_rsme_index],
          elements[first + 1][min_val_rsme_index]);

      var beta_avg =
      linear_interpolate(wc_ncdes1, wc_i, wc_ncdes2, beta1, beta2);

      return [beta_avg, ncdes_avg];
    } else if (ncdes_avg <= y2) {
      //beta averaging
      var wc_ncdes1 = linear_interpolate(
          y1,
          ncdes_avg,
          y2,
          elements[first - 1][min_val_rsme_index - 1],
          elements[first][min_val_rsme_index - 1]);
      var wc_ncdes2 = linear_interpolate(
          y1,
          ncdes_avg,
          y2,
          elements[first - 1][min_val_rsme_index],
          elements[first][min_val_rsme_index]);

      var beta_avg =
      linear_interpolate(wc_ncdes1, wc_i, wc_ncdes2, beta1, beta2);

      return [beta_avg, ncdes_avg];
    }
  }
}


find_beta_and_ncdes_values(
    var wc_i, var elements, var beta_array, var ncdes_array) {

  var beta_and_ncdes;
  var rsme_test =
  rsme_scaled_map(wc_i, elements); //find the ncrdes rsme min value matrix
  var lets = find_minimum_value_and_index(
      rsme_test[1]); //find min value and index of lowset rsme value
  var second = find_second_min_value_and_index(
      lets[1],
      rsme_test[
      1]); //find second min value and index of second lowest rsme value

  var rsme_test_new = rsme_scaled_map_without_sorting(wc_i, elements);
  var min_val_rsme_index = rsme_test_new[lets[1]].indexOf(lets[0]);
  var actualmin_val = elements[lets[1]][min_val_rsme_index];


  var second_min_val_rsme_index = rsme_test_new[second[1]].indexOf(second[0]);
  var actual_second_min_val = elements[second[1]][second_min_val_rsme_index];


  if (min_val_rsme_index == second_min_val_rsme_index) {
    //scenario 1, where wc_i is greater than both min and second min value
    if (wc_i > actualmin_val && wc_i > actual_second_min_val) {

      if (lets[1] == ncdes_array.length - 1 && min_val_rsme_index == 0) {
        var ncdes_avg = ncdes_array[lets[1]];
        var beta_avg = beta_array[min_val_rsme_index];
        return [beta_avg, ncdes_avg];
      } else {
        var y1 = beta_array[min_val_rsme_index];
        var y3 = beta_array[min_val_rsme_index + 1];

        var beta_and_ncdes = find_avg_beta_and_nc_des(
            min_val_rsme_index,
            actualmin_val,
            second_min_val_rsme_index,
            actual_second_min_val,
            y1,
            y3,
            wc_i,
            elements,
            lets[1],
            second[1],
            ncdes_array[lets[1]],
            ncdes_array[second[1]],
            "up");
        return beta_and_ncdes;
      }
    }

    //scenario 2, where wc_i is lower than both min and second min value
    else if (wc_i < actualmin_val && wc_i < actual_second_min_val) {

      if (lets[1] == 0 && min_val_rsme_index == beta_array.length - 1) {
        var ncdes_avg = ncdes_array[lets[1]];
        var beta_avg = beta_array[min_val_rsme_index];
        return [beta_avg, ncdes_avg];
      } else {
        var y1 = beta_array[min_val_rsme_index];
        var y3 = beta_array[min_val_rsme_index - 1];

        var beta_and_ncdes = find_avg_beta_and_nc_des(
            min_val_rsme_index,
            actualmin_val,
            second_min_val_rsme_index,
            actual_second_min_val,
            y1,
            y3,
            wc_i,
            elements,
            lets[1],
            second[1],
            ncdes_array[lets[1]],
            ncdes_array[second[1]],
            "down");
        return beta_and_ncdes;
      }
    }

    //scenario 4, where wc_i is greater than the second min value and lesser than the  min value
    else if (wc_i < actualmin_val && wc_i > actual_second_min_val) {
      var y1 = beta_array[min_val_rsme_index - 1];
      var y2 = beta_array[min_val_rsme_index];
      var y3 = beta_array[min_val_rsme_index + 1];

      var beta_and_ncdes = find_avg_beta_and_nc_des_special_case(
          min_val_rsme_index,
          actualmin_val,
          second_min_val_rsme_index,
          actual_second_min_val,
          y1,
          y2,
          y3,
          wc_i,
          elements,
          lets[1],
          second[1],
          ncdes_array[lets[1]],
          ncdes_array[second[1]]);
      return beta_and_ncdes;
    }
    else if(wc_i > actualmin_val && wc_i < actual_second_min_val){
      var y1 = beta_array[min_val_rsme_index - 1];
      var y2 = beta_array[min_val_rsme_index];
      var y3 = beta_array[min_val_rsme_index + 1];

      var beta_and_ncdes = find_avg_beta_and_nc_des_special_case(
          min_val_rsme_index,
          actualmin_val,
          second_min_val_rsme_index,
          actual_second_min_val,
          y1,
          y2,
          y3,
          wc_i,
          elements,
          lets[1],
          second[1],
          ncdes_array[lets[1]],
          ncdes_array[second[1]]);
      return beta_and_ncdes;
    }
  }
  var index_check = min_val_rsme_index - second_min_val_rsme_index;
  if (index_check.abs() >= 1 && lets[1] == 0) {
    if (wc_i > actualmin_val) {
      var ncdes_avg = ncdes_array[lets[1]];
      var beta_avg = linear_interpolate(
          elements[lets[1]][min_val_rsme_index - 1],
          wc_i,
          elements[lets[1]][min_val_rsme_index],
          beta_array[min_val_rsme_index - 1],
          beta_array[min_val_rsme_index]);
      return [beta_avg, ncdes_avg];
    } else if (wc_i < actualmin_val) {
      var ncdes_avg = ncdes_array[lets[1]];
      var beta_avg = linear_interpolate(
          elements[lets[1]][min_val_rsme_index],
          wc_i,
          elements[lets[1]][min_val_rsme_index + 1],
          beta_array[min_val_rsme_index],
          beta_array[min_val_rsme_index + 1]);
      return [beta_avg, ncdes_avg];
    }
  } else if (index_check.abs() >= 1 && lets[1] == ncdes_array.length - 1) {
    if (wc_i > actualmin_val) {
      var ncdes_avg = ncdes_array[lets[1]];
      var beta_avg = linear_interpolate(
          elements[lets[1]][min_val_rsme_index - 1],
          wc_i,
          elements[lets[1]][min_val_rsme_index],
          beta_array[min_val_rsme_index - 1],
          beta_array[min_val_rsme_index]);
      return [beta_avg, ncdes_avg];
    } else if (wc_i < actualmin_val) {
      var ncdes_avg = ncdes_array[lets[1]];
      var beta_avg = linear_interpolate(
          elements[lets[1]][min_val_rsme_index],
          wc_i,
          elements[lets[1]][min_val_rsme_index + 1],
          beta_array[min_val_rsme_index],
          beta_array[min_val_rsme_index + 1]);
      return [beta_avg, ncdes_avg];
    }
  } else if (index_check.abs() >= 1 && wc_i < actualmin_val) {
    var y1 = ncdes_array[lets[1] - 1];
    var y2 = ncdes_array[lets[1]];
    var y3 = ncdes_array[lets[1] + 1];
    var beta1 = beta_array[min_val_rsme_index];
    var beta2 = beta_array[min_val_rsme_index + 1];

    var beta_and_ncdes = find_nc_des_first_then_beta_avg_norm(
        wc_i,
        elements,
        y1,
        y2,
        y3,
        min_val_rsme_index,
        actualmin_val,
        lets[1],
        beta1,
        beta2,
        'down');
    return beta_and_ncdes;
  } else if (index_check.abs() >= 1 && wc_i > actualmin_val) {
    var y1 = ncdes_array[lets[1] - 1];
    var y2 = ncdes_array[lets[1]];
    var y3 = ncdes_array[lets[1] + 1];
    var beta1 = beta_array[min_val_rsme_index - 1];
    var beta2 = beta_array[min_val_rsme_index];

    var beta_and_ncdes = find_nc_des_first_then_beta_avg_norm(
        wc_i,
        elements,
        y1,
        y2,
        y3,
        min_val_rsme_index,
        actualmin_val,
        lets[1],
        beta1,
        beta2,
        'up');
    return beta_and_ncdes;
  }
}


get_eff_pr_dhqt_from_beta_ncdes(var beta_chosen, var beta_array,
    var ncdes_chosen, var ncdes_array, var scaled_map) {

  if (beta_chosen == 1 && ncdes_chosen == ncdes_array[ncdes_array.length - 1]) {
    var var_of_interest =
    scaled_map[ncdes_array.length - 1][beta_array.length - 1];

    return var_of_interest;
  } else if (beta_chosen == beta_array[0] && ncdes_chosen == ncdes_array[0]) {
    var var_of_interest = scaled_map[0][0];

    return var_of_interest;
  } else if (beta_chosen == 1) {
    var ncdes_bounds_and_indices =
    find_x1_and_x3_in_list(ncdes_chosen, ncdes_array);

    var var_of_interest = linear_interpolate(
        ncdes_bounds_and_indices[0],
        ncdes_chosen,
        ncdes_bounds_and_indices[1],
        scaled_map[ncdes_bounds_and_indices[2]][beta_array.length - 1],
        scaled_map[ncdes_bounds_and_indices[3]][beta_array.length - 1]);
    return var_of_interest;
  } else if (beta_chosen == beta_array[0]) {
    print('edge case 4');
    var ncdes_bounds_and_indices =
    find_x1_and_x3_in_list(ncdes_chosen, ncdes_array);

    var var_of_interest = linear_interpolate(
        ncdes_bounds_and_indices[0],
        ncdes_chosen,
        ncdes_bounds_and_indices[1],
        scaled_map[ncdes_bounds_and_indices[2]][0],
        scaled_map[ncdes_bounds_and_indices[3]][0]);
    return var_of_interest;
  } else if (ncdes_chosen == ncdes_array[ncdes_array.length - 1]) {
    var beta_bounds_and_indices =
    find_x1_and_x3_in_list(beta_chosen, beta_array);

    var var_of_interest = linear_interpolate(
        beta_bounds_and_indices[0],
        beta_chosen,
        beta_bounds_and_indices[1],
        scaled_map[ncdes_array.length - 1][beta_bounds_and_indices[2]],
        scaled_map[ncdes_array.length - 1][beta_bounds_and_indices[3]]);
    return var_of_interest;
  } else if (ncdes_chosen == ncdes_array[0]) {
    var beta_bounds_and_indices =
    find_x1_and_x3_in_list(beta_chosen, beta_array);

    var var_of_interest = linear_interpolate(
        beta_bounds_and_indices[0],
        beta_chosen,
        beta_bounds_and_indices[1],
        scaled_map[0][beta_bounds_and_indices[2]],
        scaled_map[0][beta_bounds_and_indices[3]]);
    return var_of_interest;
  } else {
    var beta_bounds_and_indices =
    find_x1_and_x3_in_list(beta_chosen, beta_array);
    var ncdes_bounds_and_indices =
    find_x1_and_x3_in_list(ncdes_chosen, ncdes_array);

    var var_of_interest_ncdes1 = linear_interpolate(
        ncdes_bounds_and_indices[0],
        ncdes_chosen,
        ncdes_bounds_and_indices[1],
        scaled_map[ncdes_bounds_and_indices[2]][beta_bounds_and_indices[2]],
        scaled_map[ncdes_bounds_and_indices[3]][beta_bounds_and_indices[2]]);
    var var_of_interest_ncdes2 = linear_interpolate(
        ncdes_bounds_and_indices[0],
        ncdes_chosen,
        ncdes_bounds_and_indices[1],
        scaled_map[ncdes_bounds_and_indices[2]][beta_bounds_and_indices[3]],
        scaled_map[ncdes_bounds_and_indices[3]][beta_bounds_and_indices[3]]);

    var var_of_interest = linear_interpolate(
        beta_bounds_and_indices[0],
        beta_chosen,
        beta_bounds_and_indices[1],
        var_of_interest_ncdes1,
        var_of_interest_ncdes2);

    return var_of_interest;
  }
}
