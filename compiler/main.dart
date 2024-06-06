import 'dart:io';
import 'parser.dart';
import 'pre_pro.dart';
import 'tables.dart';


void main(List<String> args) {
  if (args.isEmpty) {
    throw ArgumentError('Please provide an expression to parse');
  }
  PrePro prePro = PrePro();
  final file = File(args[0]);
  final content = file.readAsStringSync();
  final filtered = prePro.filter(content);
  try {
    final SymbolTable table = SymbolTable.instance;
    final FuncTable funcTable = FuncTable.instance;
    final parser = Parser(filtered);
    final ast = parser.run();
    if (ast.children.isEmpty) {
      throw Exception('No statements found');
    }
    final result = ast.Evaluate(table, funcTable);
    if (result != null) {
      stdout.writeln(result);
    }
  } catch (e, s) {
    // print('Error: ${e.toString()}');
    // print('Stack Trace:\n$s');
    throw e;
  }
}
