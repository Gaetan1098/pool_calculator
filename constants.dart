import 'package:flutter/material.dart';
import '../models/pool_dart.dart';

/// Recommended salt levels (ppm) by system type
class SaltLevels {
  static const Map<SaltSystem, IdealRange> ranges = {
    SaltSystem.low: IdealRange(1200, 1800),
    SaltSystem.standard: IdealRange(2700, 3400),
    SaltSystem.high: IdealRange(3500, 4200),
  };
}

class CalciumLevels {
  /// Ideal calcium hardness range in ppm
  static const Map<SurfaceType, IdealRange> idealRange = {
    SurfaceType.concrete: IdealRange(200, 400),
    SurfaceType.vinyl: IdealRange(150, 275),
  };
}

/// Ideal ranges for pool parameters (weekly maintenance targets)
class IdealRange {
  final double min;
  final double max;
  const IdealRange(this.min, this.max);
}

/// Dose factors (in g/L/ppm or L/L/ppm) for each chemical action
class DoseFactors {
  // pH
  static const double phRaise = 0.00004;        // kg per L per ΔpH (BP200)
  static const double phLower = 0.0000145;   // L per L per ΔpH (Muriatic Acid)

  // Chlorine
  static const double chlorineShock = 0.015;  // g per L (300g per 10kL)
  static const double chlorineReduce = 0.00145; // g per L per ppm
  static const double chlorineBagSize = 400;  // g per bag

  // Total Alkalinity
  static const double taRaise = 0.0000018;      // kg per L per ppm (BP100)
  static const double taLower = 0.00000160;     // L per L per ppm (Muriatic Acid)

  // Calcium Hardness
  static const double calciumRaise = 0.0000015; // kg per L per ppm (BP300)

  // Cyanuric Acid
  static const double cyaRaise = 0.000001;      // kg per L per ppm (Stabilizer)

  // Salt Bag sizes
  static const double saltBagKg = 20.0; // 20 kg per bag
   static const double saltRaise = 0.000001; // kg per L per ppm (pure NaCl)
}

/// Centralized constants and ranges
class PoolConstants {
  /// Ordered list of parameter keys for UI and logic
  static const List<String> parameterKeys = [
    'volume', 'ph', 'chlorine', 'alkalinity', 'calcium', 'cya'
  ];

  /// Map of ideal ranges for each parameter
  static const Map<String, IdealRange> idealRanges = {
    'ph': IdealRange(7.2, 7.6),
    'chlorine': IdealRange(3.0, 15.0),
    'alkalinity': IdealRange(80, 120),
    'cya': IdealRange(30, 50),
  };
}

class FieldColors{
  static const volume     = Color(0xFF1565C0); // Indigo Blue
  static const ph         = Color(0xFF2E7D32); // Dark Green
  static const chlorine   = Color(0xFFC62828); // Dark Red
  static const alkalinity = Color(0xFFE65100); // Deep Orange
  static const calcium    = Color(0xFF6A1B9A); // Deep Purple
  static const cya        = Color(0xFF00838F); // Teal
  static const salt       =  Color(0xFF6E6654); // Walnut Brown
}

class CardColors{
  static const ph        = Color(0xFFE4F6EB); // Light Green
  static const chlorine  = Color(0xFFFFE5E5); // Light Red
  static const alkalinity = Color(0xFFFFF2D9); // Light Orange
  static const calcium   = Color(0xFFF1EBFF); // Light Purple
  static const cya       = Color(0xFFE0F7F6); // Light Teal
  static const salt       =  Color(0xFFF0ECE4); // Alabaster
}

class AppColors{
  static const backgroundColor   = Color.fromARGB(255, 255, 255, 255);
  static const textColor         = Color(0xFF212121);
  static const primary           = Color(0xFF84A59D); // Cambridge Blue
  static const secondary         = Color(0xFF3C7A89); // Cerulean
  
}

class PillColors{
  static const saltFilled         = Color.fromARGB(255, 136, 128, 113); // Darker Sand
  static const saltFilledPressed  = Color(0xFFCABFA9); // Sand-400 (press/hover)
  static const saltBorder         = FieldColors.salt;  // 0xFF6E6654
}

class DropTest{
   static const Map<int, double> acidMlPer10k = {
    1: 8.60 * 29.5735,
    2: 1.10 * 473.176,
    3: 1.60 * 473.176,
    4: 1.10 * 946.353,
    5: 1.25 * 946.353,
    6: 1.60 * 946.353,
    7: 1.90 * 946.353,
    8: 2.20 * 946.353,
    9: 2.40 * 946.353,
    10: 2.50 * 946.353,
  };

  static const Map<int, double> baseKgPer10k = {
    1: (5.00 * 28.3495) / 1000.0,
    2: (10.00 * 28.3495) / 1000.0,
    3: (15.00 * 28.3495) / 1000.0,
    4: (20.00 * 28.3495) / 1000.0,
    5: 1.57 * 0.453592,
    6: 1.88 * 0.453592,
    7: 2.19 * 0.453592,
    8: 2.50 * 0.453592,
    9: 2.82 * 0.453592,
    10: 3.13 * 0.453592,
  };
}


