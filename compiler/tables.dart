
import 'operands.dart';

class FuncTable {
  FuncTable._privateConstructor();

  static final FuncTable _instance = FuncTable._privateConstructor();

  static FuncTable get instance => _instance;

  final Map<String, dynamic> _table = {};

  void set({required String key, required Node node}) {
    if (_table[key] == null) {
      _table[key] = node;
    } else {
      throw Exception('Function already defined: $key');
    }
  }

  dynamic get(String key) {
    final value = _table[key];
    if (value == null) {
      throw Exception('Undefined function: $key');
    }
    return value;
  }
}

class SymbolTable {
  SymbolTable._privateConstructor();

  static final SymbolTable _instance = SymbolTable._privateConstructor();

  static SymbolTable get instance => _instance;

  static SymbolTable getNewInstance() {
    return SymbolTable._privateConstructor();
  }

  final Map<String, Map<String, dynamic>> _table = {};
  final Map<String, Map<String, dynamic>> _classes = {};

  void set({
    required String key,
    required dynamic value,
    required dynamic type,
    required bool isLocal
  }) {
    if (!isLocal) {
      // Permitir redefinição de variáveis
      _table[key] = {'value': value, 'type': type};
    } else {
      if (_table[key] == null) {
        _table[key] = {'value': value, 'type': type};
      } else {
        throw Exception('Variable already defined: $key (local)');
      }
    }
  }

  void setClass(String className, Map<String, dynamic> attributes) {
    if (_classes[className] == null) {
      _classes[className] = attributes;
    } else {
      throw Exception('Class already defined: $className');
    }
  }

  Map<String, dynamic>? getClass(String className) {
    return _classes[className];
  }

  ({dynamic value, String type}) get(String key) {
    final value = _table[key];
    if (value == null) {
      throw Exception('Undefined variable: $key');
    }
    return (value: value['value'], type: value['type']);
  }
}
