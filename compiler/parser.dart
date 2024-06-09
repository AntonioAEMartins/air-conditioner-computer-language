import 'operands.dart';
import 'tokenizer.dart';

class Parser {
  late final Tokenizer tokenizer;

  Parser(String source) {
    tokenizer = Tokenizer(source);
  }

  Node parseExpression() {
    Node result = parseTerm();
    while (tokenizer.next.type == TokenType.plus ||
        tokenizer.next.type == TokenType.minus) {
      var operator = tokenizer.next.type;
      tokenizer.selectNext(); // Consume operator
      Node right = parseTerm();
      result = BinOp(result, right, operator.toString());
    }
    return result;
  }

  Node statement() {
    if (tokenizer.next.type == TokenType.identifier) {
      final Token identifier = tokenizer.next;
      tokenizer.selectNext(); // Consume identifier

      if (tokenizer.next.type == TokenType.dot) {
        // Handle class attribute assignment
        tokenizer.selectNext(); // Consume '.'
        if (tokenizer.next.type != TokenType.identifier) {
          throw FormatException(
              "Expected identifier but found ${tokenizer.next.type}");
        }
        final Token attribute = tokenizer.next;
        tokenizer.selectNext(); // Consume attribute identifier
        if (tokenizer.next.type != TokenType.equal) {
          throw FormatException(
              "Expected '=' but found ${tokenizer.next.type}");
        }
        tokenizer.selectNext(); // Consume '='
        final Node expression = boolExpression();
        return ClassAttributeAssignOp(Identifier(identifier.value),
            Identifier(attribute.value), expression);
      } else if (tokenizer.next.type == TokenType.equal) {
        tokenizer.selectNext(); // Consume '='
        final Node expression = boolExpression();
        final Identifier id = Identifier(identifier.value);
        if (tokenizer.next.type == TokenType.equal) {
          throw FormatException("Token not expected ${tokenizer.next.type}");
        }
        return AssignOp(id, expression);
      }

      throw FormatException("Token not expected ${tokenizer.next.type}");
    } else if (tokenizer.next.type == TokenType.set) {
      tokenizer.selectNext(); // Consume 'set'
      if (tokenizer.next.type != TokenType.identifier) {
        throw FormatException(
            "Expected identifier but found ${tokenizer.next.type}");
      }
      final Token identifier = tokenizer.next;
      final Identifier id = Identifier(identifier.value);
      tokenizer.selectNext(); // Consume identifier
      if (tokenizer.next.type == TokenType.dot) {
        // Handle class attribute declaration
        tokenizer.selectNext(); // Consume '.'
        if (tokenizer.next.type != TokenType.identifier) {
          throw FormatException(
              "Expected identifier but found ${tokenizer.next.type}");
        }
        final Token attribute = tokenizer.next;
        final Identifier attrId = Identifier(attribute.value);
        tokenizer.selectNext(); // Consume attribute identifier
        if (tokenizer.next.type != TokenType.equal) {
          throw FormatException(
              "Expected '=' but found ${tokenizer.next.type}");
        }
        tokenizer.selectNext(); // Consume '='
        final Node expression = boolExpression();
        return ClassAttributeAssignOp(id, attrId, expression);
      } else if (tokenizer.next.type == TokenType.lineBreak) {
        return VarDecOp(id, NullOp());
      }
      if (tokenizer.next.type != TokenType.equal) {
        throw FormatException("Expected '=' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume '='
      final Node expression = boolExpression();
      return VarDecOp(id, expression);
    } else if (tokenizer.next.type == TokenType.show) {
      tokenizer.selectNext(); // Consume 'show'
      if (tokenizer.next.type != TokenType.openParen) {
        throw FormatException("Expected '(' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume '('
      final Node expression = boolExpression();
      if (tokenizer.next.type != TokenType.closeParen) {
        throw FormatException("Expected ')' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume ')'
      return PrintOp(expression);
    } else if (tokenizer.next.type == TokenType.autoToken) {
      tokenizer.selectNext(); // Consume 'auto'
      final Node condition = boolExpression();
      if (tokenizer.next.type != TokenType.doToken) {
        throw FormatException("Expected 'do' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume 'do'
      if (tokenizer.next.type != TokenType.lineBreak) {
        throw FormatException(
            "Expected line break but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume line break
      final Node block = this.endBlock();
      if (tokenizer.next.type != TokenType.doneToken) {
        throw FormatException(
            "Expected 'done' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume 'done'
      return WhileOp(condition, block);
    } else if (tokenizer.next.type == TokenType.checkToken) {
      tokenizer.selectNext(); // Consume 'check'
      final Node condition = boolExpression();
      if (tokenizer.next.type != TokenType.ifToken) {
        throw FormatException("Expected 'if' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume 'if'
      if (tokenizer.next.type != TokenType.lineBreak) {
        throw FormatException(
            "Expected line break but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume line break
      final Node block = this.endBlock();
      if (tokenizer.next.type == TokenType.elseToken) {
        tokenizer.selectNext(); // Consume 'else'
        final Node elseBlock = this.endBlock();
        if (tokenizer.next.type != TokenType.doneToken) {
          throw FormatException(
              "Expected 'done' but found ${tokenizer.next.type}");
        }
        tokenizer.selectNext(); // Consume 'done'
        return IfOp(condition, block, elseBlock);
      }
      if (tokenizer.next.type != TokenType.doneToken) {
        throw FormatException(
            "Expected 'done' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume 'done'
      return IfOp(condition, block, null);
    } else if (tokenizer.next.type == TokenType.initToken) {
      tokenizer.selectNext(); // Consume 'init'
      if (tokenizer.next.type != TokenType.identifier) {
        throw FormatException(
            "Expected identifier but found ${tokenizer.next.type}");
      }
      final Identifier className = Identifier(tokenizer.next.value);
      tokenizer.selectNext(); // Consume class name
      if (tokenizer.next.type != TokenType.openParen) {
        throw FormatException("Expected '(' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume '('
      final List<Identifier> attributes = [];
      if (tokenizer.next.type != TokenType.closeParen) {
        attributes.add(Identifier(tokenizer.next.value));
        tokenizer.selectNext(); // Consume identifier
        while (tokenizer.next.type == TokenType.comma) {
          tokenizer.selectNext(); // Consume ','
          attributes.add(Identifier(tokenizer.next.value));
          tokenizer.selectNext(); // Consume identifier
        }
      }
      if (tokenizer.next.type != TokenType.closeParen) {
        throw FormatException("Expected ')' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume ')'
      return ClassInitOp(className, attributes);
    }
    if (tokenizer.next.type != TokenType.lineBreak) {
      throw FormatException(
          "Expected line break but found ${tokenizer.next.type}");
    }
    tokenizer.selectNext();
    return NoOp();
  }

  Node block() {
    Node result = Block();
    while (tokenizer.next.type != TokenType.eof &&
        tokenizer.next.type != TokenType.doneToken) {
      result.children.add(statement());
    }
    if (tokenizer.next.type == TokenType.doneToken) {
      throw FormatException("The block is not closed");
    }
    return result;
  }

  Node endBlock() {
    Node result = Block();
    while (tokenizer.next.type != TokenType.doneToken &&
        tokenizer.next.type != TokenType.elseToken &&
        tokenizer.next.type != TokenType.eof) {
      if (tokenizer.next.type == TokenType.closeParen) {
        throw FormatException("The block is not closed");
      }
      result.children.add(statement());
    }
    return result;
  }

  Node parseTerm() {
    Node result = parseFactor();
    while (tokenizer.next.type == TokenType.multiply ||
        tokenizer.next.type == TokenType.divide) {
      var operator = tokenizer.next.type;
      tokenizer.selectNext(); // Consume operator
      Node right = parseFactor();
      result = BinOp(result, right, operator.toString());
    }
    return result;
  }

  Node parseFactor() {
    if (tokenizer.next.type == TokenType.integer) {
      int value = tokenizer.next.value;
      tokenizer.selectNext(); // Consume number
      return IntVal(value);
    } else if (tokenizer.next.type == TokenType.identifier) {
      final Token identifier = tokenizer.next;
      tokenizer.selectNext();
      if (tokenizer.next.type == TokenType.dot) {
        tokenizer.selectNext(); // Consume '.'
        if (tokenizer.next.type != TokenType.identifier) {
          throw FormatException(
              "Expected identifier but found ${tokenizer.next.type}");
        }
        final Token attribute = tokenizer.next;
        tokenizer.selectNext(); // Consume attribute identifier
        return AttributeAccessOp(
            Identifier(identifier.value), Identifier(attribute.value));
      }
      if (tokenizer.next.type == TokenType.openParen) {
        tokenizer.selectNext(); // Consume '('
        List<Node> parameters = [];
        if (tokenizer.next.type != TokenType.closeParen) {
          parameters.add(boolExpression());
          while (tokenizer.next.type == TokenType.comma) {
            tokenizer.selectNext(); // Consume ','
            parameters.add(boolExpression());
          }
        }
        if (tokenizer.next.type != TokenType.closeParen) {
          throw FormatException(
              "Expected ')' but found ${tokenizer.next.type}");
        }
        tokenizer.selectNext(); // Consume ')'
        return FuncCallOp(Identifier(identifier.value), parameters);
      }
      return Identifier(identifier.value);
    } else if (tokenizer.next.type == TokenType.plus) {
      tokenizer.selectNext(); // Consume operator
      return UnOp(parseFactor(), '+');
    } else if (tokenizer.next.type == TokenType.minus) {
      tokenizer.selectNext(); // Consume operator
      return UnOp(parseFactor(), '-');
    } else if (tokenizer.next.type == TokenType.not) {
      tokenizer.selectNext(); // Consume operator
      return UnOp(parseFactor(), '!');
    } else if (tokenizer.next.type == TokenType.openParen) {
      tokenizer.selectNext(); // Consume '('
      Node result = boolExpression();
      if (tokenizer.next.type != TokenType.closeParen) {
        throw FormatException("Expected ')' but found ${tokenizer.next.type}");
      }
      tokenizer.selectNext(); // Consume ')'
      return result;
    } else {
      throw FormatException("Expected number but found ${tokenizer.next.type}");
    }
  }

  Node boolExpression() {
    Node result = boolTerm();
    while (tokenizer.next.type == TokenType.or) {
      var operator = tokenizer.next.type;
      tokenizer.selectNext(); // Consume operator
      Node right = boolTerm();
      result = BinOp(result, right, operator.toString());
    }
    return result;
  }

  Node boolTerm() {
    Node result = relExpression();
    while (tokenizer.next.type == TokenType.and) {
      var operator = tokenizer.next.type;
      tokenizer.selectNext(); // Consume operator
      Node right = relExpression();
      result = BinOp(result, right, operator.toString());
    }
    return result;
  }

  Node relExpression() {
    Node result = parseExpression();
    switch (tokenizer.next.type) {
      case TokenType.equalEqual:
      case TokenType.greater:
      case TokenType.less:
        var operator = tokenizer.next.type;
        tokenizer.selectNext(); // Consume operator
        Node right = parseExpression();
        result = BinOp(result, right, operator.toString());
        break;
      default:
        break;
    }
    return result;
  }

  Node run() {
    Node result = block();
    return result;
  }
}
