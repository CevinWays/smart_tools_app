import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _birthDate;
  int? _years;
  int? _months;
  int? _days;
  int? _totalDays;
  int? _daysToNextBirthday;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (_birthDate == null) return;

    final now = DateTime.now();
    int years = now.year - _birthDate!.year;
    int months = now.month - _birthDate!.month;
    int days = now.day - _birthDate!.day;

    if (days < 0) {
      months--;
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    _years = years;
    _months = months;
    _days = days;
    _totalDays = now.difference(_birthDate!).inDays;

    // Calculate next birthday
    DateTime nextBirthday = DateTime(
      now.year,
      _birthDate!.month,
      _birthDate!.day,
    );
    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, _birthDate!.month, _birthDate!.day);
    }
    _daysToNextBirthday = nextBirthday.difference(now).inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.cake),
                title: const Text('Select Birth Date'),
                subtitle: Text(
                  _birthDate == null
                      ? 'Tap to select'
                      : DateFormat('MMMM dd, yyyy').format(_birthDate!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 24),
            if (_years != null) ...[
              _buildResultCard(
                'Your Age',
                '$_years years, $_months months, $_days days',
                Icons.person,
                Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildResultCard(
                'Total Days Lived',
                '$_totalDays days',
                Icons.event,
                Colors.green,
              ),
              const SizedBox(height: 12),
              _buildResultCard(
                'Next Birthday',
                'In $_daysToNextBirthday days',
                Icons.celebration,
                Colors.orange,
              ),
              const SizedBox(height: 24),
              _buildDetailGrid(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    final months = (_years! * 12) + _months!;
    final weeks = (_totalDays! / 7).floor();
    final hours = _totalDays! * 24;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Months', '$months', Colors.purple),
        _buildStatCard('Weeks', '$weeks', Colors.teal),
        _buildStatCard('Hours', '$hours', Colors.indigo),
        _buildStatCard('Minutes', '${hours * 60}', Colors.pink),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
