import 'package:flutter/material.dart';
import 'package:pool_calculator/widgets/toggle_pills.dart';
import 'result_screen.dart';
//import '../core/calculator.dart';
import '../models/pool_dart.dart';
import '../core/constants.dart';
import 'package:keyboard_actions/keyboard_actions.dart';


Sanitizer _sanitizer = Sanitizer.chlorine;
SurfaceType _surface = SurfaceType.concrete;


//Stateful widget because input values change as users type
class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  // Controllers for input fields to store, read and dispose inputs
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _chlorineController = TextEditingController();
  final TextEditingController _alkalinityController = TextEditingController();
  final TextEditingController _calciumController = TextEditingController();
  final TextEditingController _cyaController = TextEditingController();
  final TextEditingController _saltController = TextEditingController();
  
  //FocusNode for input fields
  final FocusNode _volumeFocus = FocusNode();
  final FocusNode _phFocus = FocusNode();
  final FocusNode _chlorineFocus = FocusNode();
  final FocusNode _alkalinityFocus = FocusNode();
  final FocusNode _calciumFocus = FocusNode();
  final FocusNode _cyaFocus = FocusNode();
  final FocusNode _saltFocus = FocusNode();

  void _safeFocus(FocusNode? next) {
  if (next == null) {
    FocusScope.of(context).unfocus();
    return;
  }
  // avoid focusing a widget that isn't mounted/visible
  if (next.context == null) return;
  FocusScope.of(context).requestFocus(next);
}

  @override
  // prevents memory leaks
  void dispose() {
    _volumeController.dispose();
    _phController.dispose();
    _chlorineController.dispose();
    _alkalinityController.dispose();
    _calciumController.dispose();
    _cyaController.dispose();
    _saltController.dispose();

    _volumeFocus.dispose();
    _phFocus.dispose();
    _chlorineFocus.dispose();
    _alkalinityFocus.dispose();
    _calciumFocus.dispose();
    _cyaFocus.dispose();
    _saltFocus.dispose();

    super.dispose();
  }

 void _submitInputs() {
  //parse & validate
  final volume = double.tryParse(_volumeController.text);
  final chl    = double.tryParse(_chlorineController.text);
  final ph     = double.tryParse(_phController.text);
  final alk    = double.tryParse(_alkalinityController.text);
  final ca     = double.tryParse(_calciumController.text);
  final cya    = double.tryParse(_cyaController.text);
  final salt   = double.tryParse(_saltController.text);

  if (volume == null || ph == null || chl == null || alk == null || ca == null || cya == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill in all fields with valid numbers.'))
    );
    return;
  }
  double? saltppm;
  SaltSystem? saltSystem;

  if (_sanitizer == Sanitizer.salt) {
    saltppm = double.tryParse(_saltController.text);
    if (saltppm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter Salt (ppm) for SWG pools.')),
      );
      return;
    }
    // until UI toggle for low/standard/high, default to standard
    saltSystem = SaltSystem.standard;
  }

  //build input object
  final input = PoolInput(
    volumeLiters: volume,
    chlorine:     chl,
    ph:           ph,
    alkalinity:   alk,
    calcium:      ca,
    cya:          cya,
    salt: salt,
    surfaceType: _surface,
    sanitizer: _sanitizer,
  );

  // navigate, passing the results
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResultScreen(pool: input),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    // Scaffold builds basic page structure (app bar, body etc)
    return Scaffold(
      //AppBar shows title at the top
      appBar: AppBar(
        title: const Text('Pool Chemistry Calculator'),
        centerTitle: true,
        elevation: 0,),
      //Padding adds spacing around the UI
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //ListView adds scrollable list of fields and button
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // 1) Volume
            _buildTextField(
              label: 'Pool Volume (L)',
              controller: _volumeController,
              focusNode: _volumeFocus,
              nextFocusNode: _phFocus,
              min: 1,
              isDouble: false,
              borderColor: FieldColors.volume,
            ),

            // 2) pH
            _buildTextField(
              label: 'pH Level',
              controller: _phController,
              focusNode: _phFocus,
              nextFocusNode: _chlorineFocus,
              min: 0.0,
              isDouble: true,
              borderColor: FieldColors.ph,
            ),

            // 3) Chlorine/Bromine (dynamic label)
            _buildTextField(
              label: _sanitizer == Sanitizer.bromine
                  ? 'Total Bromine (ppm)'
                  : 'Total Chlorine (ppm)',
              controller: _chlorineController,
              focusNode: _chlorineFocus,
              nextFocusNode: _alkalinityFocus,
              min: 0,
              isDouble: true,
              borderColor: FieldColors.chlorine,
            ),

            // 4) TA
            _buildTextField(
              label: 'Total Alkalinity (ppm)',
              controller: _alkalinityController,
              focusNode: _alkalinityFocus,
              nextFocusNode: _calciumFocus,
              min: 0,
              isDouble: false,
              borderColor: FieldColors.alkalinity,
            ),

            // 5) CH
            _buildTextField(
              label: 'Calcium Hardness (ppm)',
              controller: _calciumController,
              focusNode: _calciumFocus,
              nextFocusNode: _cyaFocus,
              min: 0,
              isDouble: false,
              borderColor: FieldColors.calcium,
            ),

            // 6) CYA
            _buildTextField(
              label: 'CYA (ppm)',
              controller: _cyaController,
              focusNode: _cyaFocus,
              nextFocusNode: _saltFocus,
              min: 0,
              isDouble: false,
              borderColor: FieldColors.cya,
            ),

            if (_sanitizer == Sanitizer.salt) ...[
              _buildTextField(
                label: 'Salt (ppm)',
                controller: _saltController,
                focusNode: _saltFocus,
                min: 0,
                isDouble: false,
                borderColor: FieldColors.salt, // pick a tint you like; teal looks "salty"
              ),
            ],
            const SizedBox(height: 12),

            // --- Sanitizer chips ---
            const SizedBox(height: 12),
            Text('Sanitizer', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TogglePills<Sanitizer>(
              values: const [Sanitizer.chlorine, Sanitizer.salt, Sanitizer.bromine],
              selected: _sanitizer,
              onChanged: (v) => setState(() => _sanitizer = v),
              labelOf: (v) {
                switch (v) {
                  case Sanitizer.chlorine: return 'Chlorine';
                  case Sanitizer.salt:     return 'Salt (SWG)';
                  case Sanitizer.bromine:  return 'Bromine';
                }
              },
            ),
            const SizedBox(height: 12),

            // --- Surface chips ---
            const SizedBox(height: 12),
            Text('Pool Surface', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TogglePills<SurfaceType>(
              values: const [SurfaceType.concrete, SurfaceType.vinyl],
              selected: _surface,
              onChanged: (v) => setState(() => _surface = v),
              labelOf: (v) => v == SurfaceType.concrete ? 'Concrete' : 'Vinyl',
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitInputs,
              child: const Text('Calculate'),
            ),
          ],

        ),
      ),
    );
  }
//Help builds nicer text field
  Widget _buildTextField({
    required String label, 
    required TextEditingController controller, 
    FocusNode? focusNode, 
    FocusNode? nextFocusNode,
    required double min,
    required bool isDouble,
    required Color borderColor,
    }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        //Numeric Keyboard
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done, // checks if there is a next focus node
        style: TextStyle(color: borderColor),
        onSubmitted: (_) {
          if (nextFocusNode != null){
            FocusScope.of(context).requestFocus(nextFocusNode); // goes to the next node

          } else {
            FocusScope.of(context).unfocus(); // dismisses keyboard
          }
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textColor),
          //Outlined Boarder
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}



