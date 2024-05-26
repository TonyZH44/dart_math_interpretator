enum Token {
  add,
  sub,
  mul,
  div,
  lpar,
  rpar,
  value;

  @override
  String toString() {
    switch (index) {
      case 0:
        return "+";
      case 1:
        return "-";
      case 2:
        return "*";
      case 3:
        return "/";
      case 4:
        return "^";
      case 5:
        return "(";
      case 6:
        return ")";
      case 7:
        return name;
      default:
        return "null";
    }
  }

  static Token fromString(String s) {
    switch (s) {
      case "+":
        return Token.add;
      case "-":
        return Token.sub;
      case "*":
        return Token.mul;
      case "/":
        return Token.div;
      case "(":
        return Token.lpar;
      case ")":
        return Token.rpar;
      default:
        return Token.value;
    }
  }
}
