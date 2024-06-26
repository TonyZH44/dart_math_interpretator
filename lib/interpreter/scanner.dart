import 'package:dart_math_interpretator/interpreter/scanned_token.dart';
import 'package:characters/characters.dart';
import 'package:dart_math_interpretator/interpreter/tokens.dart';
import 'dart:math';

class Scanner {
  final String expression;
  final Map<String, String>? parameters;

  const Scanner(this.expression, this.parameters);

  String addVariables() {
    if (parameters == null) return expression;
    if (parameters!.isEmpty) return expression;

    String newExpression = expression;

    for (var variable in parameters!.keys) {
      newExpression =
          newExpression.replaceAll(variable, parameters![variable]!);
    }
    return newExpression;
  }

  List<ScannedToken> scan() {
    List<ScannedToken> scannedExpr = [];
    StringBuffer value = StringBuffer();
    String variableExpression = addVariables();
    for (String char in variableExpression.characters) {
      Token type = Token.fromString(char);
      if (type != Token.value) {
        if (value.length > 0) {
          ScannedToken st = ScannedToken(value.toString(), Token.value);
          scannedExpr.add(st);
        }
        value = StringBuffer()..write(char);
        ScannedToken st = ScannedToken(value.toString(), type);
        scannedExpr.add(st);
        value = StringBuffer();
      } else {
        value..write(char);
      }
    }
    if (value.isNotEmpty) {
      ScannedToken st = ScannedToken(value.toString(), Token.value);
      scannedExpr.add(st);
    }
    return scannedExpr;
  }

  double evaluate(List<ScannedToken> tokenizedExpression) {
    if (tokenizedExpression.length == 1) {
      return double.parse(tokenizedExpression[0].expressionPiece);
    }

    List<ScannedToken> simpleExpr = [];

    int idx = tokenizedExpression
        .lastIndexWhere((element) => element.type == Token.lpar);

    int matchingRPAR = -1;
    if (idx >= 0) {
      for (int i = idx + 1; i < tokenizedExpression.length; i++) {
        ScannedToken curr = tokenizedExpression[i];
        if (curr.type == Token.rpar) {
          matchingRPAR = i;
          break;
        } else {
          simpleExpr.add(tokenizedExpression[i]);
        }
      }
    } else {
      simpleExpr.addAll(tokenizedExpression);
      return evaluateSimpleExpression(tokenizedExpression);
    }

    double value = evaluateSimpleExpression(simpleExpr);

    List<ScannedToken> partiallyEvaluatedExpression = [];
    for (int i = 0; i < idx; i++) {
      partiallyEvaluatedExpression.add(tokenizedExpression[i]);
    }
    partiallyEvaluatedExpression
        .add(ScannedToken(value.toString(), Token.value));
    for (int i = matchingRPAR + 1; i < tokenizedExpression.length; i++) {
      partiallyEvaluatedExpression.add(tokenizedExpression[i]);
    }

    return evaluate(partiallyEvaluatedExpression);
  }

  //A simple expression won't contain parenthesis
  double evaluateSimpleExpression(List<ScannedToken> expression) {
    if (expression.length == 1) {
      return double.parse(expression[0].expressionPiece);
    } else {
      List<ScannedToken> newExpression = [];

      int mulIdx =
          expression.lastIndexWhere((element) => element.type == Token.mul);

      int divIdx =
          expression.lastIndexWhere((element) => element.type == Token.div);

      int computationIdx = (mulIdx >= 0 && divIdx >= 0)
          ? min(mulIdx, divIdx)
          : max(mulIdx, divIdx);
      if (computationIdx != -1) {
        double left =
            double.parse(expression[computationIdx - 1].expressionPiece);
        double right =
            double.parse(expression[computationIdx + 1].expressionPiece);

        double ans =
            computationIdx == mulIdx ? left * right : left / right * 1.0;
        for (int i = 0; i < computationIdx - 1; i++) {
          newExpression.add(expression[i]);
        }
        newExpression.add(ScannedToken(ans.toString(), Token.value));
        for (int i = computationIdx + 2; i < expression.length; i++) {
          newExpression.add(expression[i]);
        }
        return evaluateSimpleExpression(newExpression);
      } else {
        int addIdx =
            expression.lastIndexWhere((element) => element.type == Token.add);

        int subIdx =
            expression.lastIndexWhere((element) => element.type == Token.sub);

        int computationIdx2 = (addIdx >= 0 && subIdx >= 0)
            ? min(addIdx, subIdx)
            : max(addIdx, subIdx);
        if (computationIdx2 != -1) {
          double left =
              double.parse(expression[computationIdx2 - 1].expressionPiece);
          double right =
              double.parse(expression[computationIdx2 + 1].expressionPiece);

          double ans =
              computationIdx2 == addIdx ? left + right : (left - right) * 1.0;
          for (int i = 0; i < computationIdx2 - 1; i++) {
            newExpression.add(expression[i]);
          }
          newExpression.add(ScannedToken(ans.toString(), Token.value));
          for (int i = computationIdx2 + 2; i < expression.length; i++) {
            newExpression.add(expression[i]);
          }
          return evaluateSimpleExpression(newExpression);
        }
      }
    }
    return -1.0;
  }
}
