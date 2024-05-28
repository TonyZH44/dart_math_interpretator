import './interpreter/scanner.dart';
import './interpreter/parser.dart';
import './interpreter/scanned_token.dart';

class MathInterpreter {
  final String expression;
  final Map<String, String>? variables;

  const MathInterpreter(this.expression, this.variables);

  double solve() {
    Scanner sc = Scanner(expression, variables);
    List<ScannedToken> scanExp = sc.scan();
    Parser parser = Parser(scanExp);
    List<ScannedToken> parsed = parser.parse();
    return sc.evaluate(parsed);
  }
}
