import 'package:flutter_test/flutter_test.dart';
import 'package:pool_calculator/core/calculator.dart';
import 'package:pool_calculator/models/pool_dart.dart';


void main() {
  group('CYA adjustment logic', () {
    test('CYA too low triggers stabilizer recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 250,
        cya: 20,  // below 30
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateCyaAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Low'));
      expect(result.recommendation, contains('STABILIZER'));
      expect(result.recommendation, contains('kg'));
    });

    test('CYA in ideal range gives no adjustment', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 250,
        cya: 35,  // between 30 and 50
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateCyaAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Ideal'));
      expect(result.recommendation, contains('No adjustment needed'));
    });

    test('CYA too high triggers backwash recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 3.0,
        alkalinity: 100,
        calcium: 250,
        cya: 60,  // above 50
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateCyaAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('High'));
      expect(result.recommendation.toLowerCase(), contains('backwash'));
    });
  });
}
