import 'dart:io';

import 'tables.dart';

abstract class Node {
  dynamic value;
  List<Node> children = [];
  Node(this.value);

  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable);
}

class BinOp extends Node {
  final Node left;
  final Node right;
  BinOp(this.left, this.right, String op) : super(op);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var leftResult = left.Evaluate(_table, _funcTable);
    var rightResult = right.Evaluate(_table, _funcTable);

    if (rightResult == null) {
      rightResult = {'value': 0, 'type': 'integer'};
    }

    if (leftResult == null) {
      leftResult = {'value': 0, 'type': 'integer'};
    }

    if (value != "TokenType.and" && value != "TokenType.or") {
      if (leftResult['type'] == 'boolean') {
        leftResult['value'] = leftResult['value'] ? 1 : 0;
        leftResult['type'] = 'integer';
      }
      if (rightResult['type'] == 'boolean') {
        rightResult['value'] = rightResult['value'] ? 1 : 0;
        rightResult['type'] = 'integer';
      }
    }

    switch (value) {
      case "TokenType.plus":
        if (leftResult['type'] == 'string' && rightResult['type'] == 'string') {
          return {
            'value': leftResult['value'].toString() +
                rightResult['value'].toString(),
            'type': 'string'
          };
        } else if (leftResult['type'] == 'integer' &&
            rightResult['type'] == 'integer') {
          return {
            'value': leftResult['value'] + rightResult['value'],
            'type': 'integer'
          };
        }
        break;
      case "TokenType.concat":
        if (leftResult['type'] == 'string' || rightResult['type'] == 'string') {
          return {
            'value': leftResult['value'].toString() +
                rightResult['value'].toString(),
            'type': 'string'
          };
        } else if (leftResult['type'] == 'integer' &&
            rightResult['type'] == 'integer') {
          return {
            'value': leftResult['value'].toString() +
                rightResult['value'].toString(),
            'type': 'integer'
          };
        }
        break;

      case "TokenType.minus":
        if (leftResult['type'] == 'integer' &&
            rightResult['type'] == 'integer') {
          return {
            'value': leftResult['value'] - rightResult['value'],
            'type': 'integer'
          };
        }
        break;

      case "TokenType.multiply":
        if (leftResult['type'] == 'integer' &&
            rightResult['type'] == 'integer') {
          return {
            'value': leftResult['value'] * rightResult['value'],
            'type': 'integer'
          };
        }
        break;

      case "TokenType.divide":
        if (leftResult['type'] == 'integer' &&
            rightResult['type'] == 'integer') {
          return {
            'value': leftResult['value'] ~/ rightResult['value'],
            'type': 'integer'
          };
        }
        break;

      case "TokenType.greater":
      case "TokenType.less":
      case "TokenType.equalEqual":
        if (leftResult['type'] == rightResult['type']) {
          return {
            'value': evalComparison(
                leftResult['value'], rightResult['value'], value),
            'type': 'boolean'
          };
        }
        break;

      case "TokenType.and":
      case "TokenType.or":
        if (leftResult['type'] == 'boolean' &&
            rightResult['type'] == 'boolean') {
          return {
            'value': value == "TokenType.and"
                ? leftResult['value'] && rightResult['value']
                : leftResult['value'] || rightResult['value'],
            'type': 'boolean'
          };
        }
        break;
    }
    throw Exception('Invalid operator or type mismatch');
  }

  dynamic evalComparison(dynamic left, dynamic right, String operation) {
    if (left is String && right is String) {
      switch (operation) {
        case "TokenType.greater":
          return left.compareTo(right) > 0;
        case "TokenType.less":
          return left.compareTo(right) < 0;
        case "TokenType.equalEqual":
          return left.compareTo(right) == 0;
        default:
          throw Exception('Unsupported comparison operation');
      }
    }
    switch (operation) {
      case "TokenType.greater":
        return left > right;
      case "TokenType.less":
        return left < right;
      case "TokenType.equalEqual":
        return left == right;
      default:
        throw Exception('Unsupported comparison operation');
    }
  }
}

class UnOp extends Node {
  final Node expr;
  UnOp(this.expr, String op) : super(op);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var result = expr.Evaluate(_table, _funcTable);
    if (value == "!" && result['type'] == 'boolean') {
      return {'value': !result['value'], 'type': 'boolean'};
    } else if (value == "-" && result['type'] == 'integer') {
      return {'value': -result['value'], 'type': 'integer'};
    } else if (value == "+" && result['type'] == 'integer') {
      return {'value': result['value'], 'type': 'integer'};
    } else {
      throw Exception('Invalid unary operator or type mismatch');
    }
  }
}

class IntVal extends Node {
  IntVal(int value) : super({'value': value, 'type': 'integer'});

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    return value;
  }
}

class NoOp extends Node {
  NoOp() : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    return null;
  }
}

class ShowOp extends Node {
  final Node expr;
  ShowOp(this.expr) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var result = expr.Evaluate(_table, _funcTable);
    if (result["type"] == "boolean") {
      result["value"] = result["value"] ? 1 : 0;
    }
    print(result['value']);
  }
}

class Identifier extends Node {
  final String name;
  Identifier(this.name) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var entry = _table.get(name);
    return {'value': entry.value, 'type': entry.type};
  }
}

class AssignOp extends Node {
  final Identifier identifier;
  final Node expr;
  AssignOp(this.identifier, this.expr) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var exprResult = expr.Evaluate(_table, _funcTable);

    _table.set(
      key: identifier.name,
      value: exprResult['value'],
      type: exprResult['type'],
      isLocal: false,
    );
  }
}

class VarDecOp extends Node {
  final Identifier identifier;
  final Node expr;
  VarDecOp(this.identifier, this.expr) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var exprResult = expr.Evaluate(_table, _funcTable);
    _table.set(
      key: identifier.name,
      value: exprResult['value'],
      type: exprResult['type'],
      isLocal: true,
    );
  }
}

class Block extends Node {
  Block() : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    for (var child in children) {
      child.Evaluate(_table, _funcTable);
    }
  }
}

class AutoOp extends Node {
  final Node condition;
  final Node block;
  AutoOp(this.condition, this.block) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    while (condition.Evaluate(_table, _funcTable)['value']) {
      block.Evaluate(_table, _funcTable);
    }
  }
}

class CheckOp extends Node {
  final Node condition;
  final Node ifOp;
  final Node? elseOp;

  CheckOp(this.condition, this.ifOp, this.elseOp) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    if (condition.Evaluate(_table, _funcTable)['value']) {
      ifOp.Evaluate(_table, _funcTable);
    } else {
      elseOp?.Evaluate(_table, _funcTable);
    }
  }
}

class NullOp extends Node {
  NullOp() : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    return {"value": null, "type": null};
  }
}

class ClassInitOp extends Node {
  final Identifier className;
  final List<Identifier> attributes;
  ClassInitOp(this.className, this.attributes) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    final Map<String, dynamic> classAttributes = {};
    for (final attribute in attributes) {
      classAttributes[attribute.name] = null;
    }
    _table.set(
      key: className.name,
      value: classAttributes,
      type: 'class',
      isLocal: false,
    );
  }
}

class AttributeAccessOp extends Node {
  final Identifier className;
  final Identifier attribute;
  AttributeAccessOp(this.className, this.attribute) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var classInstance = _table.get(className.name).value;
    if (classInstance is Map<String, dynamic>) {
      if (classInstance.containsKey(attribute.name)) {
        return {'value': classInstance[attribute.name], 'type': 'integer'};
      } else {
        throw Exception('Undefined attribute: ${attribute.name}');
      }
    } else {
      throw Exception('Undefined class: ${className.name}');
    }
  }
}

class ClassAttributeAssignOp extends Node {
  final Identifier className;
  final Identifier attribute;
  final Node expr;
  ClassAttributeAssignOp(this.className, this.attribute, this.expr)
      : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var classInstance = _table.get(className.name).value;
    if (classInstance is Map<String, dynamic>) {
      var exprResult = expr.Evaluate(_table, _funcTable);
      classInstance[attribute.name] = exprResult['value'];
    } else {
      throw Exception('Undefined class: ${className.name}');
    }
  }
}
