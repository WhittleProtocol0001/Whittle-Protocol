import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/inlet/inlet_no_map.dart';

void main() {

  test('Inlet_sanity_check', () {
    var inlet = subInlet(0.15, 0.15, 0.015, 0.15, 440, 5.3, 1);

    print(inlet);

  });
}