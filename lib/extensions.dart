extension MakeLetterCapital on String {
  String get firstLetterLowerCase {
    return this[0].toLowerCase() + substring(1);
  }
}
