import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/turbine/turbine_no_map.dart';

void main() {

  test('turbine_sanity_check', () {
    var turbine = TurB(2000,1500, 25, 0.022, 10000000, 0.89, 0.995,1);

    print(turbine);

  });
}