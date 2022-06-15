extension StringExtension on String {
  String removeNonNumber() {
    String val = this;

    // validating for non number
    final nonNumber = RegExp(r'[^\d]+');
    if (val.contains(nonNumber)) {
      val = val.replaceAll(RegExp(r'[^\d]+'), '');
    }

    return val;
  }
}
