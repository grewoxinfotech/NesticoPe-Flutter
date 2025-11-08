import 'package:flutter/material.dart';

import '../../constants/app_font_sizes.dart';
import '../../constants/color_res.dart';

/// Optimized ExpandableTile with better animation performance
class ExpandableTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final List<Widget> children;

  const ExpandableTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.children,
  });

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(widget.leadingIcon, color: ColorRes.primary),
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
          subtitle:
              widget.subtitle != null
                  ? Text(
                    widget.subtitle!,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.leadGreyColor[600],
                    ),
                  )
                  : null,
          trailing: AnimatedRotation(
            turns: _isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              widget.trailingIcon,
              color: ColorRes.leadGreyColor[700],
            ),
          ),
          onTap: _toggleExpand,
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Wrap(
            spacing: 8,
            clipBehavior: Clip.none,
            runSpacing: 8,
            children: widget.children,
          ),
        ),

        // const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}

/// Optimized SubItems with better visual design and performance
class SubItems extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isNew;
  final VoidCallback? onTap;

  const SubItems({
    super.key,
    required this.title,
    required this.icon,
    this.isNew = false,
    this.onTap,
  });

  static const double _itemHeight = 100.0;
  static const double _iconSize = 22.0;
  static const double _badgeSize = 16.0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: ColorRes.transparentColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: _itemHeight,
          width: screenWidth / 3.5,
          // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorRes.white, ColorRes.leadGreyColor.shade50],
            ),
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.08),
            //     blurRadius: 8,
            //     offset: const Offset(0, 2),
            //     spreadRadius: 0,
            //   ),
            // ],
            border: Border.all(
              color: ColorRes.leadGreyColor.shade200,
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconWithBadge(),
              const SizedBox(height: 8),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithBadge() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: ColorRes.primary, size: _iconSize),
        ),
        if (isNew) _buildNewBadge(),
      ],
    );
  }

  Widget _buildNewBadge() {
    return Positioned(
      right: -4,
      top: -4,
      child: Container(
        width: _badgeSize,
        height: _badgeSize,
        decoration: BoxDecoration(
          color: ColorRes.error.shade600,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: ColorRes.error.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "!",
            style: TextStyle(
              color: ColorRes.white,
              fontSize: AppFontSizes.extraSmall,
              fontWeight: AppFontWeights.extraBold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Flexible(
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: AppFontSizes.small,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.leadGreyColor.shade700,
          // height: 1.1,
        ),
      ),
    );
  }
}
