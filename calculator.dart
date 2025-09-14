import 'package:flutter/material.dart';
import 'package:pool_calculator/models/pool_dart.dart';
import 'package:pool_calculator/core/constants.dart';




/// Central engine that computes adjustment results for all pool parameters.
List<AdjustmentResult> calculateAllAdjustments(PoolInput input) {
  return [
    calculateChlorineAdjustment(input),
    calculatePhAdjustment(input),
    calculateAlkalinityAdjustment(input),
    calculateCalciumAdjustment(input),
    calculateCyaAdjustment(input),
  ];
}



/// Chlorine adjustment logic using centralized constants
AdjustmentResult calculateChlorineAdjustment(PoolInput input) {
  double current = input.chlorine;
  if (Sanitizer.bromine == input.sanitizer) {
    current /= 2.0; // Bromine is half the ppm of chlorine
  }
  final double volume = input.volumeLiters;
  final range = PoolConstants.idealRanges['chlorine']!;
  const double target = 5.0;

  if (current > 7.5 && current <= range.max) {
    return AdjustmentResult(
      label: input.sanitizer == Sanitizer.chlorine ? "Chlorine" : "Bromine",
      value: input.sanitizer == Sanitizer.chlorine ? current.toStringAsFixed(1) : (current * 2.0).toStringAsFixed(1),
      status: Icon(Icons.check_circle),
      recommendation: "No Adjustment needed",
      color: CardColors.chlorine,
    );
  }
  // Maintain Chlorination
  if (current >= 3 && current <= 7.5) {
    final double grams = volume * DoseFactors.chlorineShock;
    final int bags = (grams / DoseFactors.chlorineBagSize).ceil();
    final int maintenance = (bags / 2).ceil();

    return AdjustmentResult(
      label: input.sanitizer == Sanitizer.chlorine ? "Chlorine" : "Bromine",
      value: input.sanitizer == Sanitizer.chlorine ? current.toStringAsFixed(1) : (current * 2.0).toStringAsFixed(1),
      status: Icon(Icons.check_circle),
      recommendation: "Add $maintenance bag${maintenance > 1 ? 's' : ''} of SUPER SHOCK for maintenance chlorination.",
      color: CardColors.chlorine
    );
  }

  // Shock
  if (current < range.min) {
    final double grams = volume * DoseFactors.chlorineShock;
    final double kg = grams / 1000;
    final int bags = (grams / DoseFactors.chlorineBagSize).ceil();

    return AdjustmentResult(
      label: input.sanitizer == Sanitizer.chlorine ? "Chlorine" : "Bromine",
      value: input.sanitizer == Sanitizer.chlorine ? current.toStringAsFixed(1) : (current * 2.0).toStringAsFixed(1),
      status: Icon(Icons.arrow_upward),
      recommendation: "Add $bags bag${bags > 1 ? 's' : ''} of SUPER SHOCK (${kg.toStringAsFixed(1)} kg) for superchlorination.",
      color: CardColors.chlorine,
    );
  }

  // Reduce
  final double delta = current - target;
  final double grams = volume * DoseFactors.chlorineReduce * delta;
  final double kg = grams / 1000;

  return AdjustmentResult(
    label: input.sanitizer == Sanitizer.chlorine ? "Chlorine" : "Bromine",
    value: input.sanitizer == Sanitizer.chlorine ? current.toStringAsFixed(1) : (current * 2.0).toStringAsFixed(1),
    status: Icon(Icons.arrow_downward),
    recommendation: "Add ${kg.toStringAsFixed(1)} kg of Chlor-Out to reduce chlorine to ${target.toStringAsFixed(0)} ppm.",
    color: CardColors.chlorine,
  );
}

/// pH adjustment logic using centralized constants
AdjustmentResult calculatePhAdjustment(PoolInput input) {
  final double current = input.ph;
  final double volume = input.volumeLiters;
  final range = PoolConstants.idealRanges['ph']!;
  final double target = current > range.max
      ? range.min // aim for 7.2 for low
      : current < range.min
          ? range.max // aim for 7.6 for raising
          : (range.min + range.max) / 2; // Ideal

  const double L_PER_10K_GAL = 37854.0;
  final double scale = volume / L_PER_10K_GAL;

  // Ideal
  if (current >= range.min && current <= range.max) {
    return AdjustmentResult(
      label: "pH",
      value: current.toStringAsFixed(1),
      status: Icon(Icons.check_circle),
      recommendation: "No adjustment needed.",
      color: CardColors.ph,
    );
  }

  // Raise pH
  if (current < range.min) {
    final int drops = (input.baseDemandDrops ?? 2).clamp(1, 10);
    final double kgAt10k = DropTest.baseKgPer10k[drops]!;
    final double dosageKg = kgAt10k * scale; // RAW (no rounding)

    return AdjustmentResult(
      label: "pH",
      value: current.toStringAsFixed(1),
      status: Icon(Icons.arrow_upward),
      recommendation: "Add ${dosageKg.toStringAsFixed(1)} kg of BP200 to raise pH to ${target.toStringAsFixed(1)}.",
      color: CardColors.ph,
    );
  }

  // Lower pH
  final int drops = (input.acidDemandDrops ?? 2).clamp(1, 10);
  final double mlAt10k = DropTest.acidMlPer10k[drops]!;
  final double dosageL = (mlAt10k * scale / 1000.0); // RAW (no rounding)

  return AdjustmentResult(
    label: "pH",
    value: current.toString(),
    status: const Icon(Icons.arrow_downward),
    recommendation:
        "Add ${dosageL.toStringAsFixed(1)} L of 31.45% muriatic acid to lower pH toward ${target.toString()}.",
    color: CardColors.ph,
  );
  
}

/// TA adjustment (TFP-style corrected TA) but KEEP the acid-dose method for high TA.
/// - Adjusted TA = measured TA − (CYA / 3)  (TFP convention)
/// - Targets: 60–80 (SWG / high aeration), else 70–90
/// - Low TA: raise with BP100 using DoseFactors.taRaise (kg/L/ppm)
/// - High TA: LOWER VIA ACID using your factor (31.45% MA), not the aeration loop.
///
/// If you already have this in constants, replace the local const with DoseFactors.taLowerMa31.

AdjustmentResult calculateAlkalinityAdjustment(
  PoolInput input, {
  bool isSwg = false,
}) {
  final double volumeL    = input.volumeLiters;
  final double taMeasured = input.alkalinity; // ppm
  final double cya        = input.cya;        // ppm

  // 1) Corrected (carbonate) TA per TFP: TA_adj = TA_measured - (CYA/3)
  const double cyaFactor = 1.0 / 3.0;
  final double cyaAlk    = cya * cyaFactor;
  final double taAdj     = (taMeasured - cyaAlk).clamp(0.0, double.infinity);

  // 2) Choose targets (lower if SWG/high aeration)
  final bool lowerBand   = isSwg;
  final double minAdj    = lowerBand ? 60 : 70;
  final double maxAdj    = lowerBand ? 80 : 90;
  final double tgtAdj    = (minAdj + maxAdj) / 2;

  // 3) In range → do nothing
  if (taAdj >= minAdj && taAdj <= maxAdj) {
    return AdjustmentResult(
      label: "Total Alkalinity",
      value: taMeasured.toStringAsFixed(0),
      status: const Icon(Icons.check_circle),
      recommendation:
          "No TA change. Corrected TA ≈ ${taAdj.toStringAsFixed(0)} ppm ",
      color: CardColors.alkalinity,
    );
  }

  // 4) Too low → raise with sodium bicarbonate (BP100)
  if (taAdj < minAdj) {
    final double deltaPpm = (tgtAdj - taAdj); // raise corrected TA to target
    final double kg = volumeL * deltaPpm * DoseFactors.taRaise; // kg of BP100

    return AdjustmentResult(
      label: "Total Alkalinity",
      value: taMeasured.toStringAsFixed(0),
      status: const Icon(Icons.arrow_upward),
      recommendation:
          "Add ${kg.toStringAsFixed(1)} kg of BP100 (sodium bicarbonate) to reach corrected TA ≈ "
          "${tgtAdj.toStringAsFixed(0)} ppm ",
      color: CardColors.alkalinity,
    );
  }

  // 5) Too high → LOWER VIA ACID (your method), but base it on corrected TA.
  final double deltaAdj = (taAdj - tgtAdj); // ppm to remove from corrected TA
  final double litersAcid = volumeL * deltaAdj * DoseFactors.taLower; // L of 31.45% MA

  // Safety note: acid will drop pH—have the tech recheck pH after addition.
  return AdjustmentResult(
    label: "Total Alkalinity",
    value: taMeasured.toStringAsFixed(0),
    status: const Icon(Icons.arrow_downward),
    recommendation:
        "Add ${litersAcid.toStringAsFixed(1)} L of 31.45% muriatic acid to lower corrected TA toward "
        "${tgtAdj.toStringAsFixed(0)} ppm",
    color: CardColors.alkalinity,
  );
}


/// Calcium Hardness adjustment logic using centralized constants
AdjustmentResult calculateCalciumAdjustment(PoolInput input) {
  final double current = input.calcium;
  final double volume = input.volumeLiters;
  final range = CalciumLevels.idealRange[input.surfaceType]
      ?? CalciumLevels.idealRange[SurfaceType.concrete]!; // fallback
  final double targetMin = range.min;

  // Too high
  if (current > range.max) {
    return AdjustmentResult(
      label: "Calcium Hardness",
      value: current.toStringAsFixed(0),
      status: Icon(Icons.arrow_downward),
      recommendation: "Calcium hardness is above ${range.max.toInt()} ppm. Add scale inhibitor and drain water to refill.",
      color: CardColors.calcium
    );
  }

  // Too low
  if (current < targetMin) {
    final double grams = volume * (targetMin - current) * DoseFactors.calciumRaise;
    final double kg = grams;

    return AdjustmentResult(
      label: "Calcium Hardness",
      value: current.toStringAsFixed(0),
      status: Icon(Icons.arrow_upward),
      recommendation: "Add ${kg.toStringAsFixed(1)} kg of Balance Pak 300 to raise CH to ${targetMin.toStringAsFixed(0)} ppm.",
      color: CardColors.calcium,
    );
  }

  // Ideal
  return AdjustmentResult(
    label: "Calcium Hardness",
    value: current.toStringAsFixed(0),
    status: Icon(Icons.check_circle),
    recommendation: "No adjustment needed.",
    color: CardColors.calcium,
  );
}

/// Cyanuric Acid adjustment logic using centralized constants
AdjustmentResult calculateCyaAdjustment(PoolInput input) {
  final double current = input.cya;
  final double volume = input.volumeLiters;
  final range = PoolConstants.idealRanges['cya']!;
  final double targetMax = range.max;

  // Ideal
  if (current >= range.min && current <= targetMax) {
    return AdjustmentResult(
      label: "Cyanuric Acid",
      value: current.toStringAsFixed(0),
      status: Icon(Icons.check_circle),
      recommendation: "No adjustment needed.",
      color: CardColors.cya,
    );
  }

  // Too low
  if (current < range.min) {
    final double grams = volume * (targetMax - current) * DoseFactors.cyaRaise;
    final double kg = grams;

    return AdjustmentResult(
      label: "Cyanuric Acid",
      value: current.toStringAsFixed(0),
      status: Icon(Icons.arrow_upward),
      recommendation: "Add ${kg.toStringAsFixed(1)} kg of STABILIZER to raise CYA to ${targetMax.toStringAsFixed(0)} ppm.",
      color: CardColors.cya,
    );
  }

  // Too high
  return AdjustmentResult(
    label: "Cyanuric Acid",
    value: current.toStringAsFixed(0),
    status: Icon(Icons.arrow_downward),
    recommendation: "Drain and refill to lower CYA to ${targetMax.toStringAsFixed(0)} ppm.",
    color: CardColors.cya,
  );
}

SaltAdjustmentResult calculateSaltAdjustment(
  PoolInput input, {
  double saltPurity = 1.0, // e.g., 0.99 for 99% pure salt
}) {
  // Not an SWG pool? Return a neutral, non-crashing result.
  if (input.sanitizer != Sanitizer.salt) {
    return const SaltAdjustmentResult(
      value: 'N/A',
      targetPpm: 0,
      deltaPpm: 0,
      kgSaltToAdd: 0,
      bagsToAdd: 0,
      status: Icon(Icons.help_outline),
      recommendation: 'Salt card not applicable.',
    );
  }

  // Null-safe reads (don’t use ! on possibly-null fields)
  final double? currentOpt = input.salt;                // ppm, may be null
  final SaltSystem system = input.saltSystem ?? SaltSystem.standard;

  // If salt isn’t entered yet, gently prompt (no math, no crash).
  if (currentOpt == null) {
    final range = SaltLevels.ranges[system]!;
    final target = (range.min + range.max) / 2.0;
    return SaltAdjustmentResult(
      value: '0',
      targetPpm: target,
      deltaPpm: 0,
      kgSaltToAdd: 0,
      bagsToAdd: 0,
      status: Icon(Icons.help_outline),
      recommendation: 'Enter Salt (ppm) to calculate dosing.',
    );
  }

  final double current = currentOpt;
  final range  = SaltLevels.ranges[system]!;
  final target = (range.min + range.max) / 2.0;
  final delta  = target - current;

  // Status vs range
  final Icon status = (current < range.min)
      ? Icon(Icons.arrow_upward)
      : (current > range.max)
          ? Icon(Icons.arrow_downward)
          : Icon(Icons.check_circle);

  // If low, compute kg and bags; if high, warn (no dilution calc in MVP).
  if (current < range.min) {
    // kg = L * Δppm * (kg/L/ppm) / purity
    final double kg = (input.volumeLiters * delta * DoseFactors.saltRaise) / saltPurity;
    final int bags  = (kg / DoseFactors.saltBagKg).ceil();
    return SaltAdjustmentResult(
      value: current.toStringAsFixed(0),
      targetPpm: target,
      deltaPpm: delta,
      kgSaltToAdd: kg,
      bagsToAdd: bags,
      status: status,
      recommendation:
          'Add $bags × ${DoseFactors.saltBagKg.toStringAsFixed(0)}kg bags '
          '(${kg.toStringAsFixed(1)} kg) to reach ~${target.toStringAsFixed(0)} ppm.',
    );
  } else if (current > range.max) {
    return SaltAdjustmentResult(
      value: current.toStringAsFixed(0),
      targetPpm: target,
      deltaPpm: delta,
      kgSaltToAdd: 0,
      bagsToAdd: 0,
      status: status,
      recommendation:
          'Salt is above the recommended range (${range.min.toInt()}–${range.max.toInt()} ppm). '
          'Lower via dilution/backwash.',
    );
  } else {
    return SaltAdjustmentResult(
      value: current.toStringAsFixed(0),
      targetPpm: target,
      deltaPpm: 0,
      kgSaltToAdd: 0,
      bagsToAdd: 0,
      status: status,
      recommendation: 'Salt is on target. No adjustment needed.',
    );
  }
}
