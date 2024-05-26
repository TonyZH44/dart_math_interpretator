import 'tokens.dart';

class ScannedToken {
  final Token type;
  final String expressionPiece;

  const ScannedToken(this.expressionPiece, this.type);

  @override
  String toString() {
    return "(Expr: $expressionPiece , Token: $type)";
  }
}
