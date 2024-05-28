import 'dart:io';

import 'package:dart_math_interpretator/interpreter/scanner.dart';
import 'package:dart_math_interpretator/interpreter/parser.dart';
import 'package:dart_math_interpretator/interpreter/scanned_token.dart';
import 'package:dart_math_interpretator/interpreter/tokens.dart';

import 'package:dart_math_interpretator/interpreter.dart';

void main(List<String> arguments) {
  String mathExpression = '-x*y+15/(3+2)';

  Map<String, String> variables = {'x': '3', 'y': '10'};

  print(MathInterpreter(mathExpression, variables).solve());
}
