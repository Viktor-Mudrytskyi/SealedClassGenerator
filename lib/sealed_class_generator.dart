import 'dart:io';
import 'class_data_model.dart';

void writeToFile(File file) {
  try {
    final stringData = file.readAsStringSync();
    final dataModel = ClassDataModel(fileData: stringData);
    // file.writeAsStringSync('Heloo edited from exe');
    final editedFileString = editFile(dataModel, stringData).toString();
    file.writeAsStringSync(editedFileString);
    stdout.writeln('Successfully edited ${file.path}');
  } catch (e) {
    stdout.writeln(e.toString());
  }
}

StringBuffer editFile(ClassDataModel dataModel, String fileData) {
  // final LineSplitter lineSplitter=LineSplitter();
  //   final lines=lineSplitter.convert(fileData);
  final buffer = StringBuffer();
  final firstBrace = fileData.indexOf('{');
  buffer.writeln(fileData.substring(0, firstBrace + 1));
  buffer.writeln(
    methodRepresentation(
      name: 'map',
      params: generateParams(dataModel, true),
      body: generateMapBody(dataModel),
      isReturnNullable: false,
    ),
  );
  buffer.writeln(
    methodRepresentation(
      name: 'maybeMap',
      params: 'required T Function() orElse, \n${generateParams(
        dataModel,
        false,
      )}',
      body: generateMaybeMapBody(dataModel),
      isReturnNullable: false,
    ),
  );

  buffer.writeln(
    methodRepresentation(
      name: 'mapOrNull',
      params: generateParams(
        dataModel,
        false,
      ),
      body: generateMapOrNullBody(dataModel),
      isReturnNullable: true,
    ),
  
  );

  buffer.write(fileData.substring(firstBrace + 1, fileData.length));
  return buffer;
}

String generateParams(ClassDataModel dataModel, bool isRequired) {
  String params = '';
  for (var i = 0; i < dataModel.functionNames.length; i++) {
    final currentFunctionName = dataModel.functionNames[i];
    final currentClassName = dataModel.inheritorsNames[i];
    final required = isRequired ? 'required' : '';
    final nullable=isRequired?'':'?';
    params +=
        '$required T Function($currentClassName $currentFunctionName)$nullable $currentFunctionName,\n';
  }
  return params;
}

String methodRepresentation({
  required String name,
  required String params,
  required String body,
  required bool isReturnNullable,
}) {
  String str = '';
  final generic = isReturnNullable ? 'T?' : 'T';
  str += '$generic $name<T>({$params}){\n$body\n}';
  return str;
}

String generateMapBody(ClassDataModel dataModel) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('return switch (this) {');
  for (var i = 0; i < dataModel.functionNames.length; i++) {
    final currentFunctionName = dataModel.functionNames[i];
    final currentClassName = dataModel.inheritorsNames[i];
    buffer.writeln(
        '$currentClassName() => $currentFunctionName(this as $currentClassName,),');
  }
  buffer.writeln('};');
  return buffer.toString();
}

String generateMaybeMapBody(ClassDataModel dataModel) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('return switch (this) {');
  for (var i = 0; i < dataModel.functionNames.length; i++) {
    final currentFunctionName = dataModel.functionNames[i];
    final currentClassName = dataModel.inheritorsNames[i];
    buffer.writeln(
        '$currentClassName() => $currentFunctionName!=null? $currentFunctionName(this as $currentClassName,):orElse(),');
  }
  buffer.writeln('};');
  return buffer.toString();
}

String generateMapOrNullBody(ClassDataModel dataModel) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('return switch (this) {');
  for (var i = 0; i < dataModel.functionNames.length; i++) {
    final currentFunctionName = dataModel.functionNames[i];
    final currentClassName = dataModel.inheritorsNames[i];
    buffer.writeln(
        '$currentClassName() => $currentFunctionName!=null? $currentFunctionName(this as $currentClassName,):null,');
  }
  buffer.writeln('};');
  return buffer.toString();
}
