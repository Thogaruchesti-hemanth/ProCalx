import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class CalculatorEngine {
  String? evaluateExpression(String expression) {
    try {
      expression = _handleCustomFunctions(expression);
      final Parser parser = Parser();
      final Expression exp = parser.parse(expression);
      final ContextModel cm = ContextModel();
      final double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toStringAsFixed(6);
    } catch (_) {
      return null;
    }
  }

  String _handleCustomFunctions(String expression) {
    expression = expression.replaceAllMapped(RegExp(r'sin\(([^()]*)\)'), (m) {
      final val = double.tryParse(m[1]!) ?? double.nan;
      return math.sin(_degToRad(val)).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'cos\(([^()]*)\)'), (m) {
      final val = double.tryParse(m[1]!) ?? double.nan;
      return math.cos(_degToRad(val)).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'tan\(([^()]*)\)'), (m) {
      final val = double.tryParse(m[1]!) ?? double.nan;
      return math.tan(_degToRad(val)).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'(\d+)!'), (m) {
      final val = int.tryParse(m[1]!) ?? 0;
      return _factorial(val).toString();
    });

    expression = expression.replaceAllMapped(RegExp(r'√(\d+(\.\d+)?)'), (m) {
      return 'sqrt(${m[1]})';
    });

    return expression;
  }

  int _factorial(int n) => (n <= 1) ? 1 : n * _factorial(n - 1);
  double _degToRad(double deg) => deg * math.pi / 180;
}
