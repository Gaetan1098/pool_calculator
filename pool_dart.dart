import 'package:flutter/material.dart';

enum Sanitizer { chlorine, bromine, salt }
enum SurfaceType { concrete, vinyl}
enum SaltSystem {
  low,        // ~1,500–2,000 ppm
  standard,   // ~3,000–3,500 ppm
  high,       // ~4,000–6,000 ppm
}
enum SunExposure { low, medium, high }
enum ChlorineProduct { liquid10, calHypo65 }

/// Holds user input values from the InputScreen.
class PoolInput {
  final double volumeLiters;
  final double chlorine;
  final double ph;
  final double alkalinity;
  final double calcium;
  final double cya;
  final double? salt;
  final int? acidDemandDrops;
  final int? baseDemandDrops;
  final Sanitizer sanitizer;
  final SurfaceType surfaceType;
  final SaltSystem? saltSystem;

  const PoolInput({
    required this.volumeLiters,
    required this.chlorine,
    required this.ph,
    required this.alkalinity,
    required this.calcium,
    required this.cya,
    this.salt,
    this.acidDemandDrops,
    this.baseDemandDrops,
    required this.sanitizer,
    required this.surfaceType,
    this.saltSystem,
  });

  PoolInput copyWith({
    double? volumeLiters,
    double? chlorine,
    double? ph,
    double? alkalinity,
    double? calcium,
    double? cya,
    double? salt,
    int? acidDemandDrops,
    int? baseDemandDrops,
    Sanitizer? sanitizer,
    SurfaceType? surfaceType,
    SaltSystem? saltSystem,
  }) {
    return PoolInput(
      volumeLiters: volumeLiters ?? this.volumeLiters,
      chlorine: chlorine ?? this.chlorine,
      ph: ph ?? this.ph,
      alkalinity: alkalinity ?? this.alkalinity,
      calcium: calcium ?? this.calcium,
      cya: cya ?? this.cya,
      salt: salt ?? this.salt,
      acidDemandDrops: acidDemandDrops ?? this.acidDemandDrops,
      baseDemandDrops: baseDemandDrops ?? this.baseDemandDrops,
      sanitizer: sanitizer ?? this.sanitizer,
      surfaceType: surfaceType ?? this.surfaceType,
      saltSystem: saltSystem ?? this.saltSystem,
    );
  }
}

/// Stores the result for one chemical adjustment (used on ResultScreen).
class AdjustmentResult {
  final String label;
  final String value;         // e.g., "pH", "Alkalinity"
  final Icon status;        // Icon.upwardarrow
  final String recommendation; // e.g., "Add 200g BP200"
  final Color color;          // Color for card background and trailing text

  AdjustmentResult({
    required this.label,
    required this.value,
    required this.status,
    required this.recommendation,
    required this.color,
  });
}

class SaltAdjustmentResult {
  final String value;
  final double targetPpm;
  final double deltaPpm;
  final double kgSaltToAdd;
  final int bagsToAdd;
  final Icon status;        // "Low" | "Ideal" | "High" | "N/A"
  final String recommendation;

  const SaltAdjustmentResult({
    required this.value,
    required this.targetPpm,
    required this.deltaPpm,
    required this.kgSaltToAdd,
    required this.bagsToAdd,
    required this.status,
    required this.recommendation,
  });
}
