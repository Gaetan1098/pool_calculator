import 'package:flutter_test/flutter_test.dart';
import 'package:pool_calculator/core/calculator.dart';
import 'package:pool_calculator/models/pool_dart.dart';


void main() {
  group('Calcium Hardness adjustment logic', () {
    test('Calcium too low triggers Balance Pak 300 recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 150,  // below 200
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateCalciumAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Low'));
      expect(result.recommendation, contains('Balance Pak 300'));
      expect(result.recommendation, contains('kg'));
    });

    test('Calcium in ideal range gives no adjustment', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 250,  // between 200 and 400
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateCalciumAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Ideal'));
      expect(result.recommendation, contains('No adjustment needed'));
    });

    test('Calcium too high triggers drain recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 450,  // above 400
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateCalciumAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('High'));
      expect(result.recommendation, contains('drain water'));
    });
  });
}
