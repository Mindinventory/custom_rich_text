import 'package:flutter/material.dart';

import '../helper_class.dart';

class ReadMoreLessModel {
  int? trimLines;
  late String? readMoreText;
  late String? readLessText;
  late TextStyle? readMoreLessStyle;

  ReadMoreLessModel(
      {required int? trimLines,
      String? readMoreText,
      String? readLessText,
      TextStyle? readMoreLessStyle}) {
    this.trimLines = 2;
    this.readMoreText = readMoreText ?? kReadMore;
    this.readLessText = readLessText ?? kReadLess;
    this.readMoreLessStyle =
        readMoreLessStyle ?? TextStyle(fontSize: 16, color: Colors.pink);
  }
}
