import 'package:flutter/material.dart';
import 'package:pool_calculator/core/constants.dart';
import 'package:pool_calculator/models/pool_dart.dart';
import 'package:pool_calculator/core/calculator.dart';
import 'package:pool_calculator/widgets/drop_stepper.dart';
import 'package:pool_calculator/widgets/toggle_pills.dart';

class TAResultCard extends StatelessWidget {
  final Icon status;
  final String label;
  final String value;
  final String recommendation;
  final Color color;

  const TAResultCard({
    Key? key,
    required this.status,
    required this.label,
    required this.value,
    required this.recommendation,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          status,
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textColor),
          ),
          Text(
            recommendation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textColor),
          )
        ],
      ),
    );
  }
}

class CHResultCard extends StatelessWidget {
  final Icon status;
  final String label;
  final String value;
  final String recommendation;
  final Color color;

  const CHResultCard({
    Key? key,
    required this.status,
    required this.label,
    required this.value,
    required this.recommendation,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          status,
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textColor),
          ),
          Text(
            recommendation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textColor),
          )
        ],
      ),
    );
  }
}

class CYAResultCard extends StatelessWidget {
  final Icon status;
  final String label;
  final String value;
  final String recommendation;
  final Color color;

  const CYAResultCard({
    Key? key,
    required this.status,
    required this.label,
    required this.value,
    required this.recommendation,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          status,
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textColor),
          ),
          Text(
            recommendation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textColor),
          )
        ],
      ),
    );
  }
}

class ChlorineResultCard extends StatelessWidget {
  final Icon status;
  final String label;
  final String value;
  final String recommendation;
  final Color color;

  const ChlorineResultCard({
    Key? key,
    required this.status,
    required this.label,
    required this.value,
    required this.recommendation,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          status,
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textColor),
          ),
          Text(
            recommendation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textColor),
          )
        ],
      ),
    );
  }
}

class PhResultCard extends StatefulWidget {
  final PoolInput input;

  const PhResultCard({Key? key, required this.input}) : super(key: key);

  @override
  State<PhResultCard> createState() => _PhResultCardState();
}

class _PhResultCardState extends State<PhResultCard> {
  late int _drops;

  @override
  void initState() {
    super.initState();
    final r = PoolConstants.idealRanges['ph']!;
    if (widget.input.ph > r.max) {
      _drops = (widget.input.acidDemandDrops ?? 2).clamp(1, 10);
    } else if (widget.input.ph < r.min) {
      _drops = (widget.input.baseDemandDrops ?? 2).clamp(1, 10);
    } else {
      _drops = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final range = PoolConstants.idealRanges['ph']!;
    final isHigh = widget.input.ph > range.max;
    final isLow  = widget.input.ph < range.min;
    final inRange = !isHigh && !isLow;

    final adjusted = isHigh
        ? widget.input.copyWith(acidDemandDrops: _drops)
        : isLow
            ? widget.input.copyWith(baseDemandDrops: _drops)
            : widget.input;

    final phResult = calculatePhAdjustment(adjusted);

    return Container(
      decoration: BoxDecoration(
        color: CardColors.ph,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT: icon + title + value + recommendation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isHigh ? Icons.arrow_downward
                           : isLow ? Icons.arrow_upward
                                   : Icons.check_circle,
                    size: 18,
                  ),
                  const SizedBox(height: 4),
                  Text('pH', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor)),
                  Text(
                    phResult.value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    phResult.recommendation,             // no rounding in the math
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textColor),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),

            // RIGHT: stepper (only when out of range)
            if (!inRange) ...[
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 110, maxWidth: 155),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                      Row(
                        children: [
                          Icon(Icons.water_drop, size: 18,),
                          Text(isHigh ? 'Acid Demand Drops' : 'Base Demand Drops',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textColor)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          DropStepperCompact(
                        value: _drops,
                        onChanged: (v) => setState(() => _drops = v.clamp(1, 10)),
                      ),
                ],
              ),
            ),
          ],
          ],
        ),
      ),
    );
  }
}

class SaltResultCard extends StatefulWidget {
  final PoolInput input;
  const SaltResultCard({super.key, required this.input});

  @override
  State<SaltResultCard> createState() => _SaltResultCardState();
}

class _SaltResultCardState extends State<SaltResultCard> {
  late SaltSystem _saltSystem;

  @override
  void initState() {
    super.initState();
    _saltSystem = widget.input.saltSystem ?? SaltSystem.standard;
  }

  @override
  Widget build(BuildContext context) {
    // Only render for SWG pools
    if (widget.input.sanitizer != Sanitizer.salt) {
      return const SizedBox.shrink();
    }

    // ⬅️ Use the currently selected pill in the calculation
    final adjusted = widget.input.copyWith(saltSystem: _saltSystem);
    final res = calculateSaltAdjustment(adjusted);

    return Container(
      decoration: BoxDecoration(
        color: CardColors.salt,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: PillColors.saltFilled,
              foregroundColor: AppColors.textColor,
              shape: const StadiumBorder(),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                PillColors.saltFilledPressed.withOpacity(0.18),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textColor,
              side: const BorderSide(color: PillColors.saltBorder),
              shape: const StadiumBorder(),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // icon → title → pills → value → recommendation (matches pH layout)
              res.status,
              const SizedBox(height: 4),
              Text(
                'Salt',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.textColor),
              ),
              const SizedBox(height: 4),

              TogglePills<SaltSystem>(
                values: const [
                  SaltSystem.low,
                  SaltSystem.standard,
                  SaltSystem.high
                ],
                selected: _saltSystem,
                onChanged: (v) => setState(() => _saltSystem = v), // live recompute
                labelOf: (v) {
                  switch (v) {
                    case SaltSystem.low:
                      return 'Low';
                    case SaltSystem.standard:
                      return 'Std';
                    case SaltSystem.high:
                      return 'High';
                  }
                },
              ),

              const SizedBox(height: 8),
              Text(
                '${res.value}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.textColor),
              ),
              const SizedBox(height: 8),
              Text(
                res.recommendation,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

