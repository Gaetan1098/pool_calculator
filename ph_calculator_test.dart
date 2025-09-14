import 'package:flutter_test/flutter_test.dart';
import 'package:pool_calculator/core/calculator.dart';
import 'package:pool_calculator/models/pool_dart.dart';

void main() {
  test('pH too low triggers BP200 recommendation', () {
    final input = PoolInput(
      volumeLiters: 50000,
      ph: 6.8,
      chlorine: 3.5,
      alkalinity: 100,
      calcium: 250,
      cya: 40,
      sanitizer: Sanitizer.chlorine,
      surfaceType: SurfaceType.concrete,
      
    );

    final result = calculatePhAdjustment(input);

    // ✅ See the result printed in terminal
    print('Label: ${result.label}');
    print('Status: ${result.status}');
    print('Recommendation: ${result.recommendation}');
    print('Color: ${result.color}');

    expect(result.status, contains('Low'));
    expect(result.recommendation, contains('BP200'));
    expect(result.recommendation, contains('kg'));
  });

  test('pH too high triggers Muriatic Acid recommendation', () {
    final input = PoolInput(
      volumeLiters: 50000,
      ph: 8.2,
      chlorine: 3.5,
      alkalinity: 100,
      calcium: 250,
      cya: 40,
      sanitizer: Sanitizer.chlorine,
      surfaceType: SurfaceType.concrete,
    );

    final result = calculatePhAdjustment(input);

    print('Label: ${result.label}');
    print('Status: ${result.status}');
    print('Recommendation: ${result.recommendation}');

    expect(result.status, contains('High'));
    expect(result.recommendation, contains('muriatic acid'));
    expect(result.recommendation, contains('L'));
  });
  
  test('pH in ideal range does not trigger adjustment', () {
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

    final result = calculatePhAdjustment(input);

    print('Label: ${result.label}');
    print('Status: ${result.status}');
    print('Recommendation: ${result.recommendation}');

    expect(result.status, contains('Ideal'));
    expect(result.recommendation, contains('No adjustment needed'));
  });

}
