import 'package:flutter/material.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;
  String _resultMessage = '';

  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0 && weight > 0) {
      setState(() {
        // Height in cm to meters
        double heightInMeters = height / 100;
        _bmi = weight / (heightInMeters * heightInMeters);

        if (_bmi! < 18.5) {
          _resultMessage = "Underweight";
        } else if (_bmi! < 24.9) {
          _resultMessage = "Normal";
        } else if (_bmi! < 29.9) {
          _resultMessage = "Overweight";
        } else {
          _resultMessage = "Obese";
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid height and weight")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Calculate BMI'),
            ),
            const SizedBox(height: 32),
            if (_bmi != null) ...[
              Text(
                'Your BMI: ${_bmi!.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _resultMessage,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: _getResultColor(),
                ),
              ),
              const SizedBox(height: 20),
              _buildBmiGauge(),
            ],
          ],
        ),
      ),
    );
  }

  Color _getResultColor() {
    if (_bmi! < 18.5) return Colors.blue;
    if (_bmi! < 24.9) return Colors.green;
    if (_bmi! < 29.9) return Colors.orange;
    return Colors.red;
  }

  Widget _buildBmiGauge() {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.green, Colors.orange, Colors.red],
          stops: [0.185, 0.25, 0.30, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: (_bmi! / 40 * MediaQuery.of(context).size.width).clamp(
              0,
              MediaQuery.of(context).size.width - 40,
            ),
            child: const Icon(
              Icons.arrow_drop_down,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
