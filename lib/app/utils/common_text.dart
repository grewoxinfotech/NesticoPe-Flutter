import 'package:flutter/material.dart';

import '../constants/color_res.dart';

class CustomText extends StatelessWidget {
  // Text properties
  final String text;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool softWrap;
  final TextOverflow? overflow;
  final double textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis textWidthBasis;

  // TextStyle properties
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final String? fontFamily;
  final List<Shadow>? shadows;
  final Paint? foreground;
  final Paint? background;

  const CustomText(
    this.text, {
    Key? key,
    // Text defaults
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.locale,
    this.softWrap = true,
    this.overflow,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis = TextWidthBasis.parent,
    // TextStyle defaults
    this.color = ColorRes.textPrimary,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.fontFamily,
    this.shadows,
    this.foreground,
    this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      // ignore: deprecated_member_use
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        shadows: shadows,
        foreground: foreground,
        background: background,
      ),
    );
  }
}
