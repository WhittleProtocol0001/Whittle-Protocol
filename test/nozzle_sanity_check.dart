import 'package:engine_id/atmosphere_and%20_fuels/atmosphere.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/nozzle/nozzle_no_map.dart';

void main() {

  test('Nozzle_sanity_check', () {
    var height = 0;
    var nozzles = nozArb(133.11815, 180.18181350333768, 328, 0.0, atmosphere(height)[1], 0.02, 1);

    print(nozzles);

  });
}