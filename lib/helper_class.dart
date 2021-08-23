import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

RegExp _emailRegExp = RegExp(
    r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*");
RegExp _linksRegExp = RegExp(
    r"(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})");
RegExp _phoneRegExp = RegExp(r'([+]?\d{1,2}[.-\s]?)?(\d{3}[.-]?){2}\d{4}');

typedef StringArgumentCallback = void Function(String);
typedef VoidArgumentCallback = void Function();

final int int64MaxValue = double.maxFinite.toInt();

enum MatchType { phone, email, link, customRegExp, none }

/// Default textStyles
TextStyle kTextStyle = TextStyle(fontSize: 16, color: Colors.black);
TextStyle kLinkTextStyle = TextStyle(fontSize: 16, color: Colors.blue);
TextStyle kGivenStringTextStyle =
    TextStyle(fontSize: 16, color: Colors.lightGreen);

String kReadMore = ' read more';
String kReadLess = ' read less';

class _MatchedString {
  final MatchType type;
  final String text;

  _MatchedString({required this.text, required this.type});

  @override
  String toString() {
    return text;
  }
}

List<_MatchedString> findMatches(String text, String types, bool humanize,
    {RegExp? regExp}) {
  List<_MatchedString> matched = [
    _MatchedString(type: MatchType.none, text: text)
  ];

  /// If there is phone number in the text it will be added
  /// to the highlighted string list
  if (types.contains('phone')) {
    List<_MatchedString> newMatched = [];
    for (_MatchedString matchedBefore in matched) {
      if (matchedBefore.type == MatchType.none) {
        newMatched
            .addAll(_findLinksByType(matchedBefore.text, MatchType.phone));
      } else
        newMatched.add(matchedBefore);
    }
    matched = newMatched;
  }

  /// If there is email in the text it will be added
  /// to the highlighted string list
  if (types.contains('email')) {
    List<_MatchedString> newMatched = [];
    for (_MatchedString matchedBefore in matched) {
      if (matchedBefore.type == MatchType.none) {
        newMatched.addAll(_findLinksByType(matchedBefore.text, MatchType.email,
            regExp: _emailRegExp));
      } else
        newMatched.add(matchedBefore);
    }
    matched = newMatched;
  }

  /// If there is web link in the text it will be added
  /// to the highlighted string list
  if (types.contains('web')) {
    List<_MatchedString> newMatched = [];
    for (_MatchedString matchedBefore in matched) {
      if (matchedBefore.type == MatchType.none) {
        final webMatches = _findLinksByType(matchedBefore.text, MatchType.link,
            regExp: _linksRegExp);
        for (_MatchedString webMatch in webMatches) {
          if (webMatch.type == MatchType.link &&
              (webMatch.text.startsWith('http://') ||
                  webMatch.text.startsWith('https://')) &&
              humanize) {
            newMatched.add(_MatchedString(
                text: webMatch.text
                    .substring(webMatch.text.startsWith('http://') ? 7 : 8),
                type: MatchType.link));
          } else {
            newMatched.add(webMatch);
          }
        }
      } else
        newMatched.add(matchedBefore);
    }
    matched = newMatched;
  }

  /// If there is any custom regExp provided then it will add the matching
  /// string to the highlighted string list
  if (types.contains('regExp')) {
    List<_MatchedString> newMatched = [];
    for (_MatchedString matchedBefore in matched) {
      if (matchedBefore.type == MatchType.none) {
        newMatched.addAll(_findLinksByType(
            matchedBefore.text, MatchType.customRegExp,
            regExp: regExp));
      } else
        newMatched.add(matchedBefore);
    }
    matched = newMatched;
  }

  return matched;
}

RegExp? _getRegExpByType(MatchType type, RegExp? regExp) {
  switch (type) {
    case MatchType.phone:
      return _phoneRegExp;
    case MatchType.email:
      return _emailRegExp;
    case MatchType.link:
      return _linksRegExp;
    case MatchType.customRegExp:
      return regExp;
    default:
      return null;
  }
}

List<_MatchedString> _findLinksByType(String text, MatchType type,
    {RegExp? regExp}) {
  List<_MatchedString> output = [];
  final matches = _getRegExpByType(type, regExp)!.allMatches(text);

  int endOfMatch = 0;
  for (Match match in matches) {
    final before = text.substring(endOfMatch, match.start);
    if (before.isNotEmpty)
      output.add(_MatchedString(text: before, type: MatchType.none));
    final lastCharacterIndex =
        text[match.end - 1] == ' ' ? match.end - 1 : match.end;
    output.add(_MatchedString(
        type: type, text: text.substring(match.start, lastCharacterIndex)));
    endOfMatch = lastCharacterIndex;
  }
  final endOfText = text.substring(endOfMatch);
  if (endOfText.isNotEmpty)
    output.add(_MatchedString(text: endOfText, type: MatchType.none));
  return output;
}
