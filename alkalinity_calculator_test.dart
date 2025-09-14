import 'package:flutter_test/flutter_test.dart';
import 'package:pool_calculator/core/calculator.dart';
import 'package:pool_calculator/models/pool_dart.dart';


void main() {
  group('Alkalinity adjustment logic', () {
    test('TA too low triggers Balance Pak 100 recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 60,
        calcium: 250,
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateAlkalinityAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Low'));
      expect(result.recommendation, contains('Balance Pak 100'));
      expect(result.recommendation, contains('kg'));
    });

    test('TA in ideal range gives no adjustment', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 250,
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateAlkalinityAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Ideal'));
      expect(result.recommendation, contains('No adjustment'));
    });

    test('TA too high triggers Muriatic Acid recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 140,
        calcium: 250,
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateAlkalinityAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('High'));
      expect(result.recommendation, contains('Muriatic Acid'));
      expect(result.recommendation, contains('L'));
    });
  });
}
