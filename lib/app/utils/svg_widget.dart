import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgIcon extends StatelessWidget {
  final String assetName;
  final double size;
  final Color? color;
  final String folder;

  const AppSvgIcon({
    Key? key,
    required this.assetName,
    this.size = 24,
    this.color,
    this.folder='svg'

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/$folder/$assetName.svg';
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      placeholderBuilder:
          (_) => Icon(Icons.help_outline, size: size, color: color),
    );
  }
}
