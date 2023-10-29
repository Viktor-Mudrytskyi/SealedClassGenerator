import 'dart:io';

import 'package:sealed_class_generator/sealed_class_generator.dart';

void main(List<String> arguments) {
  stdout.writeln('Enter path:');
  final path = stdin.readLineSync()!;
  stdout.writeln('Path: $path');
  // final path='D:/Work/3-1/test.dart';
  final properPath = path.replaceAll(r'\', '/');
  stdout.writeln('Proper path: $properPath');
  try {
    final file = File(properPath);
    writeToFile(file);
  } catch (e) {
    print(e.toString());
  }
  stdin.readLineSync();
}
