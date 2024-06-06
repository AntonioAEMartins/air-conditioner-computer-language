enum TokenType {
  integer,
  plus,
  minus,
  multiply,
  divide,
  eof,
  openParen,
  closeParen,
  identifier,
  show,
  equal,
  or,
  and,
  not,
  greater,
  less,
  equalEqual,
  doneToken,
  checkToken,
  elseToken,
  doToken,
  ifToken,
  autoToken,
  set,
  lineBreak,
  comma,
}

final Map<String, TokenType> keywordTokens = {
  'show': TokenType.show,
  'check': TokenType.checkToken,
  'else': TokenType.elseToken,
  'do': TokenType.doToken,
  'if': TokenType.ifToken,
  'auto': TokenType.autoToken,
  'done': TokenType.doneToken,
  'not': TokenType.not,
  'or': TokenType.or,
  'and': TokenType.and,
  'set': TokenType.set,
  'below': TokenType.less,
  'above': TokenType.greater,
  'equal': TokenType.equalEqual,
};

class Token {
  final TokenType type;
  final dynamic value;

  Token(this.type, this.value);
}

class Tokenizer {
  final String source;
  int position = 0;
  late Token next;

  Tokenizer(this.source) {
    selectNext();
  }

  void selectNext() {
    while (position < source.length && " \t".contains(source[position])) {
      position++;
    }

    if (position == source.length) {
      next = Token(TokenType.eof, 0);
      return;
    }

    final char = source[position];
    switch (char) {
      case '\n':
        next = Token(TokenType.lineBreak, 0);
        position++;
        break;
      case '+':
        next = Token(TokenType.plus, 0);
        position++;
        break;
      case '-':
        next = Token(TokenType.minus, 0);
        position++;
        break;
      case '*':
        next = Token(TokenType.multiply, 0);
        position++;
        break;
      case '/':
        next = Token(TokenType.divide, 0);
        position++;
        break;
      case '(':
        next = Token(TokenType.openParen, 0);
        position++;
        break;
      case ')':
        next = Token(TokenType.closeParen, 0);
        position++;
        break;
      case '=':
        next = Token(TokenType.equal, 0);
        position++;
        break;
      case ',':
        next = Token(TokenType.comma, 0);
        position++;
        break;
      default:
        if (char.startsWith(RegExp(r'[a-zA-Z_]'))) {
          final start = position;
          while (position < source.length &&
              source[position].contains(RegExp(r'^[a-zA-Z0-9_]+$'))) {
            position++;
          }
          final identifier = source.substring(start, position);
          if (keywordTokens.containsKey(identifier)) {
            next = Token(keywordTokens[identifier]!, identifier);
          } else {
            next = Token(TokenType.identifier, identifier);
          }
        } else if (char.startsWith(RegExp(r'^\d'))) {
          final start = position;
          while (position < source.length &&
              source[position].contains(RegExp(r'\d'))) {
            position++;
          }
          final number = int.parse(source.substring(start, position));
          next = Token(TokenType.integer, number);
        } else {
          throw FormatException(
              "Unrecognized character '$char' at position $position");
        }
        break;
    }
  }
}
