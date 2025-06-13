import 'package:flutter/material.dart';

extension TextExtensions on Text {
  Widget get ellipsized => Text(
    data ?? '',
    style: style,
    maxLines: maxLines ?? 1,
    overflow: TextOverflow.ellipsis,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    textScaler: textScaler,
    semanticsLabel: semanticsLabel,
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
  );

  Widget get responsiveText => LayoutBuilder(
    builder: (context, constraints) {
      final textStyle = style ?? Theme.of(context).textTheme.bodyMedium!;
      final fontSize = textStyle.fontSize ?? 14.0;

      // Reduce font size for very small screens
      final responsiveFontSize = constraints.maxWidth < 350 ? fontSize * 0.9 : fontSize;

      return Text(
        data ?? '',
        style: textStyle.copyWith(fontSize: responsiveFontSize),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        textScaler: textScaler,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      );
    },
  );
}

extension StringExtensions on String {
  bool get containsHtml => contains('<') && contains('>');

  String get stripHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  String get truncated => length > 100 ? '${substring(0, 100)}...' : this;
}

extension ResponsiveTextWidget on Widget {
  Widget responsive({double minWidth = 350}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < minWidth) {
          return Transform.scale(scale: 0.9, child: this);
        }
        return this;
      },
    );
  }
}
