import 'package:dart_math_interpretator/interpretator/scanner.dart';
import 'package:dart_math_interpretator/interpretator/parser.dart';
import 'package:dart_math_interpretator/interpretator/scanned_token.dart';
import 'package:dart_math_interpretator/interpretator/tokens.dart';

void main(List<String> arguments) {
  Scanner sc = Scanner('3*10+15/(3+2)', null);
  List<ScannedToken> scanExp = sc.scan();
  Parser parser = Parser(scanExp);
  List<ScannedToken> parsed = parser.parse();
  //scanExp.forEach(e->System.out.println(e));
  print(sc.evaluate(parsed));
}
