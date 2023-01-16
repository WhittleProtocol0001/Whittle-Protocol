import 'package:flutter_test/flutter_test.dart';
import 'package:engine_id/compressor/compressor_no_map.dart';

void main() {

  test('Compressor_sanity_check', () {
    var compressor = cmP(288,101.325,7,0.87,30);

    print(compressor);

  });
}