import 'dart:convert';

import 'package:sealed_class_generator/extensions.dart';

class ClassDataModel{
    String sealedClassName='';
   final List<String> inheritorsNames=[];
   final List<String> functionNames=[];

  final String fileData;

  ClassDataModel({required this.fileData}){
    final LineSplitter lineSplitter=LineSplitter();
    final lines=lineSplitter.convert(fileData);
    for (var line in lines) {
      final wordsInLine=line.split(' ');
      String previousWord='';
      String wordBeforePrevious='';
      for (var word in wordsInLine) {
        if(previousWord=='class'&& wordBeforePrevious=='sealed'){
          sealedClassName=word;
        }else if(previousWord=='class'){
          inheritorsNames.add(word);
          final funcName=word.replaceAll(sealedClassName, '').firstLetterLowerCase;
          functionNames.add(funcName);
        }
        wordBeforePrevious=previousWord;
        previousWord=word;
      }
    }
  }
}