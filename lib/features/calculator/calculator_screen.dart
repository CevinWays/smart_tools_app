import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String equation = "0";
  String result = "0";
  String expression = "";

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation.isEmpty) equation = "0";
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          ShuntingYardParser p = ShuntingYardParser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          // ignore: deprecated_member_use
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
          if (result.endsWith(".0")) {
            result = result.substring(0, result.length - 2);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight, Color color) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final numColor = isDark ? Colors.grey[800]! : Colors.white;
    final numTextColor = isDark ? Colors.white : Colors.black;
    final opColor = Colors.blue;
    final actionColor = Colors.orange;

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              equation,
              style: TextStyle(fontSize: 32, color: Colors.grey[600]),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              result,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(child: Divider()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("C", 1, actionColor),
                        buildButton("⌫", 1, actionColor),
                        buildButton("÷", 1, opColor),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildNumButton("7", numColor, numTextColor),
                        _buildNumButton("8", numColor, numTextColor),
                        _buildNumButton("9", numColor, numTextColor),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildNumButton("4", numColor, numTextColor),
                        _buildNumButton("5", numColor, numTextColor),
                        _buildNumButton("6", numColor, numTextColor),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildNumButton("1", numColor, numTextColor),
                        _buildNumButton("2", numColor, numTextColor),
                        _buildNumButton("3", numColor, numTextColor),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildNumButton(".", numColor, numTextColor),
                        _buildNumButton("0", numColor, numTextColor),
                        _buildNumButton("00", numColor, numTextColor),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(children: [buildButton("×", 1, opColor)]),
                    TableRow(children: [buildButton("-", 1, opColor)]),
                    TableRow(children: [buildButton("+", 1, opColor)]),
                    TableRow(children: [buildButton("=", 2, actionColor)]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumButton(String text, Color bgColor, Color textColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () => buttonPressed(text),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
