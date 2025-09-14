import 'package:flutter_test/flutter_test.dart';
import 'package:pool_calculator/core/calculator.dart';
import 'package:pool_calculator/models/pool_dart.dart';


void main() {
  group('Chlorine adjustment logic', () {
    test('Chlorine too low triggers Super Shock recommendation', () {
      final input = PoolInput(
        volumeLiters: 90000,
        ph: 7.4,
        chlorine: 0,
        alkalinity: 100,
        calcium: 250,
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateChlorineAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Low'));
      expect(result.recommendation, contains('SUPER SHOCK'));
      expect(result.recommendation, contains('kg'));
    });

    test('Chlorine in ideal range does not trigger adjustment', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 4.0,
        alkalinity: 100,
        calcium: 250,
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateChlorineAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('Ideal'));
      expect(result.recommendation, contains('No adjustment'));
    });

    test('Chlorine too high triggers Chlor-Out recommendation', () {
      final input = PoolInput(
        volumeLiters: 50000,
        ph: 7.4,
        chlorine: 10.0,
        alkalinity: 100,
        calcium: 250,
        cya: 40,
        sanitizer: Sanitizer.chlorine,
        surfaceType: SurfaceType.concrete,
      );

      final result = calculateChlorineAdjustment(input);

      print(result.recommendation);
      expect(result.status, contains('High'));
      expect(result.recommendation, contains('Chlor-Out'));
      expect(result.recommendation, contains('kg'));
    });
  });
}
