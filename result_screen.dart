import 'package:flutter/material.dart';
import '../models/pool_dart.dart';
import '../core/calculator.dart';
import '../widgets/result_cards.dart';


class ResultScreen extends StatelessWidget {
  final PoolInput pool;
  const ResultScreen({Key? key, required this.pool}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // for the chlorine card
    final AdjustmentResult chlorineResult = calculateChlorineAdjustment(pool);
    final AdjustmentResult alkalinityResult = calculateAlkalinityAdjustment(pool);
    final AdjustmentResult calciumResult = calculateCalciumAdjustment(pool);
    final AdjustmentResult cyaResult = calculateCyaAdjustment(pool);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Full-width pH card
      SizedBox(width: double.infinity, child: PhResultCard(input: pool)),
      const SizedBox(height: 16),

      // NON-scrollable grid inside the single scroll view
      GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 180,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ChlorineResultCard(
            status: chlorineResult.status,
            label: chlorineResult.label,
            value: chlorineResult.value,
            recommendation: chlorineResult.recommendation,
            color: chlorineResult.color,
          ),
          TAResultCard(
            status: alkalinityResult.status,
            label: alkalinityResult.label,
            value: alkalinityResult.value,
            recommendation: alkalinityResult.recommendation,
            color: alkalinityResult.color,
          ),
          CHResultCard(
            status: calciumResult.status,
            label: calciumResult.label,
            value: calciumResult.value,
            recommendation: calciumResult.recommendation,
            color: calciumResult.color,
          ),
          CYAResultCard(
            status: cyaResult.status,
            label: cyaResult.label,
            value: cyaResult.value,
            recommendation: cyaResult.recommendation,
            color: cyaResult.color,
          ),
        ],
      ),

      // Show salt card only for SWG — also fix the typo: use `...[` not `.[`
      if (pool.sanitizer == Sanitizer.salt) ...[
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: SaltResultCard(input: pool)),
      ],

      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: () {}, child: const Text('Save Report')),
      ),
    ],
  ),
),
    );
  }
}

 