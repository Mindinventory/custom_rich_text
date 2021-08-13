library custom_rich_text;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'helper_class.dart';
import 'models/read_more_less_model.dart';

class CustomRichText extends StatefulWidget {
  final String text;
  final List<String>? highlightTerms;
  final RegExp? customRegExp;
  final bool caseSensitive;
  final StringArgumentCallback? onWebLinkTap,
      onPhoneTap,
      onEmailTap,
      onTermTap,
      onCustomRegExpTap;
  final VoidArgumentCallback? onReadMoreLessTap;
  final ReadMoreLessModel? readMoreLessModel;

  final TextStyle? textStyle, linkStyle, highlightTermsStyle, customRegExpStyle;
  final bool? humanize;

  CustomRichText(
      {required this.text,
      this.readMoreLessModel,
      this.highlightTerms,
      this.customRegExp,
      this.caseSensitive = false,
      this.textStyle,
      this.linkStyle,
      this.highlightTermsStyle,
      this.customRegExpStyle,
      this.onWebLinkTap,
      this.onEmailTap,
      this.onPhoneTap,
      this.onTermTap,
      this.onCustomRegExpTap,
      this.onReadMoreLessTap,
      this.humanize = false});

  @override
  _CustomRichTextState createState() => _CustomRichTextState();
}

class _CustomRichTextState extends State<CustomRichText> {
  bool _readMore = true;

  void _onReadMoreLessTap() {
    if (widget.onReadMoreLessTap != null) widget.onReadMoreLessTap!();
    setState(() => _readMore = !_readMore);
  }

  _onLinkTap(String link, MatchType type) {
    switch (type) {
      case MatchType.phone:
        widget.onPhoneTap!(link);
        break;
      case MatchType.email:
        widget.onEmailTap!(link);
        break;
      case MatchType.link:
        widget.onWebLinkTap!(link);
        break;
      case MatchType.customRegExp:
        widget.onCustomRegExpTap!(link);
        break;
      case MatchType.none:
        break;
    }
  }

  String _getTypes() {
    String types = '';
    if (widget.onWebLinkTap != null) types += 'web';
    if (widget.onEmailTap != null) types += 'email';
    if (widget.onPhoneTap != null) types += 'phone';
    if (widget.onCustomRegExpTap != null) types += 'regExp';
    return types;
  }

  List<TextSpan> _buildTextSpans(String fullText, {TextSpan? link}) {
    List<TextSpan> textSpans = findMatches(
            fullText, _getTypes(), widget.humanize!,
            regExp: widget.customRegExp)
        .map((match) {
      if (match.type == MatchType.none) {
        return termTextSpan(match.text);
      }
      final recognizer = TapGestureRecognizer();
      recognizer.onTap = () => _onLinkTap(match.text, match.type);
      return TextSpan(
          text: match.text,
          style: match.type == MatchType.customRegExp
              ? widget.customRegExpStyle
              : widget.linkStyle ?? kLinkTextStyle,
          recognizer: recognizer);
    }).toList();
    if (link != null) textSpans.add(link);
    return textSpans;
  }

  TextSpan termTextSpan(String text) {
    final String textLC = widget.caseSensitive ? text : text.toLowerCase();

    final List<String> termList = widget.highlightTerms ?? [];

    // remove empty search terms ('') because they cause infinite loops
    final List<String> termListLC = termList
        .where((s) => s.isNotEmpty)
        .map((s) => widget.caseSensitive ? s : s.toLowerCase())
        .toList();

    List<InlineSpan> children = [];

    int start = 0;
    int idx = 0;
    while (idx < textLC.length) {
      nonHighlightAdd(int end) => children.add(TextSpan(
          text: text.substring(start, end),
          style: widget.textStyle ?? kTextStyle));

      // find index of term that's closest to current idx position
      int iNearest = -1;
      int idxNearest = int64MaxValue;
      for (int i = 0; i < termListLC.length; i++) {
        int at;
        if ((at = textLC.indexOf(termListLC[i], idx)) >= 0) //MAGIC//CORE
        {
          if (at < idxNearest) {
            iNearest = i;
            idxNearest = at;
          }
        }
      }

      if (iNearest >= 0) {
        // found one of the terms at or after idx
        // iNearest is the index of the closest term at or after idx that matches
        if (start < idxNearest) {
          // we found a match BUT FIRST output non-highlighted text that comes BEFORE this match
          nonHighlightAdd(idxNearest);
          start = idxNearest;
        }

        // output the match using desired highlighting
        int termLen = termListLC[iNearest].length;
        final recognizer = TapGestureRecognizer();
        if (widget.onTermTap != null)
          recognizer.onTap = () => widget.onTermTap!(termListLC[iNearest]);

        children.add(TextSpan(
            text: text.substring(start, idxNearest + termLen),
            style: widget.highlightTermsStyle ?? kLinkTextStyle,
            recognizer: recognizer));
        start = idx = idxNearest + termLen;
      } else {
        // if none match at all (ever!)
        // --or--
        // one or more matches but during this iteration there are NO MORE matches
        // in either case, add reminder of text as non-highlighted text
        nonHighlightAdd(textLC.length);
        break;
      }
    }

    return TextSpan(children: children, style: widget.textStyle ?? kTextStyle);
  }

  @override
  Widget build(BuildContext context) {
    TextSpan link;
    if (widget.readMoreLessModel != null) {
      link = TextSpan(
          text: _readMore
              ? widget.readMoreLessModel!.readMoreText
              : widget.readMoreLessModel!.readLessText,
          style: widget.readMoreLessModel!.readMoreLessStyle,
          recognizer: TapGestureRecognizer()..onTap = _onReadMoreLessTap);
      Widget result = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          assert(constraints.hasBoundedWidth);
          final double maxWidth = constraints.maxWidth;
          // Create a TextSpan with data
          final text = TextSpan(
            text: widget.text,
          );
          // Layout and measure link
          TextPainter textPainter = TextPainter(
            text: link,
            textDirection: TextDirection.ltr,
            //better to pass this from master widget if ltr and rtl both supported
            maxLines: widget.readMoreLessModel!.trimLines,
            ellipsis: '...',
          );
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: maxWidth);
          final linkSize = textPainter.size;
          // Layout and measure text
          textPainter.text = text;
          textPainter.layout(
              minWidth: constraints.minWidth, maxWidth: maxWidth);
          final textSize = textPainter.size;
          // Get the endIndex of data
          int endIndex;
          final pos = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset)!;

          var textSpan;

          if (textPainter.didExceedMaxLines) {
            textSpan = TextSpan(
              style: widget.textStyle ?? kTextStyle,
              children: _buildTextSpans(
                  _readMore ? widget.text.substring(0, endIndex) : widget.text,
                  link: link),
            );
          } else {
            textSpan = TextSpan(
                style: widget.textStyle ?? kTextStyle,
                children: _buildTextSpans(widget.text));
          }

          return RichText(
            softWrap: true,
            overflow: TextOverflow.clip,
            text: textSpan,
          );
        },
      );
      return result;
    }

    return RichText(
      text: TextSpan(
          style: widget.textStyle ?? kTextStyle,
          children: _buildTextSpans(widget.text)),
    );
  }
}
