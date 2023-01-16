import 'package:engine_id/combustor/combustor_no_map.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  test('Combustor_sanity_check', () {
    var cmb = comb_FR(1000,2000,0.01,0.03,1489,43124,0.999,30,0.3,0.45);
    print(cmb);

    var cmb_2 = comB(1000,2000,0.01,0.03,1489,43124000,0.999,30,1);
    print(cmb_2);

  });
}