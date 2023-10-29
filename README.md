# SealedClassGenerator
Generates a few simple method that make working with sealed classes, and pattern matching as a whole, a lot easier.
Such as map, maybeMap and mapOrNull
Works the same way as the freezed version

# Instruction
To generate, all you need to do is provide a path to the file that you want to change.
*Important* classes should have following naming convention:
sealed class HomeState{}

class LoadingHomeState extends HomeState{}

class LoadedHomeState extends HomeState{}

class ErrorHomeState extends HomeState{}

This will allow the generator to handle function names.
Example: (LoadedHomeState loaded) => loaded,
