import 'scanned_token.dart';
import 'tokens.dart';

class Parser {
  final List<ScannedToken> expression;

  const Parser(this.expression);

  /*
    We need a triple in a sliding window fashion where middle is current token so we can contextualize what
    needs to be parsed into correct tokens
     */
  List<ScannedToken> parse() {
    Token? prev;
    Token? curr;
    Token? next;

    List<ScannedToken> properlyParsedExpression = [];

    List<Token> types = expression.map((e) => e.type).toList();

    List<int> indexes = [];
    List<ScannedToken> negativevalues = [];

    for (int i = 0; i < types.length - 1; i++) {
      prev = i == 0 ? null : types[i - 1];
      curr = types[i];
      next = types[i + 1];
      if (prev == null && curr == Token.sub && next == Token.value) {
        ScannedToken negativevalue = ScannedToken(
            '${(-1 * double.parse(expression[i + 1].expressionPiece))}',
            Token.value);

        indexes.add(i);
        negativevalues.add(negativevalue);
      } else if (prev == Token.lpar &&
          curr == Token.sub &&
          next == Token.value) {
        ScannedToken negativevalue = ScannedToken(
            '${(-1 * double.parse(expression[i + 1].expressionPiece))}',
            Token.value);

        indexes.add(i);
        negativevalues.add(negativevalue);
      }
    }

    int maxIterations = expression.length;
    int i = 0;
    int j = 0;
    while (i < maxIterations) {
      if (indexes.contains(i) && j < negativevalues.length) {
        properlyParsedExpression.add(negativevalues[j]);
        j++;
        i++;
      } else {
        properlyParsedExpression.add(expression[i]);
      }
      i++;
    }

    return properlyParsedExpression;
  }
}
