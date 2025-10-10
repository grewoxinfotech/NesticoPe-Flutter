import 'package:flutter/material.dart';

import '../../app/constants/color_res.dart';

class NesticoPeExpandableTile extends StatefulWidget {
  // Core content
  final String title;
  final String? subtitle;
  final Widget? customTitle;
  final Widget? customSubtitle;

  // Icons and leading/trailing widgets
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final IconData? trailingIcon;
  final Widget? customTrailingWidget;

  // Children and content
  final List<Widget>? children;
  final Widget? expandedContent;
  final Widget Function(BuildContext context, bool isExpanded)? builder;

  // Styling
  final Color? backgroundColor;
  final Color? expandedBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final Border? border;
  final BoxShadow? shadow;
  final double? elevation;

  // Colors
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? trailingIconColor;

  // Text styles
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  // Animation
  final Duration? animationDuration;
  final Curve? animationCurve;

  // Behavior
  final bool initiallyExpanded;
  final bool maintainState;
  final ValueChanged<bool>? onExpansionChanged;
  final VoidCallback? onTap;
  final bool enabled;

  // Layout
  final CrossAxisAlignment? tileCrossAxisAlignment;
  final MainAxisAlignment? tileMainAxisAlignment;
  final CrossAxisAlignment? expandedCrossAxisAlignment;
  final MainAxisAlignment? expandedMainAxisAlignment;
  final WrapAlignment? wrapAlignment;
  final WrapCrossAlignment? wrapCrossAlignment;
  final double? wrapSpacing;
  final double? wrapRunSpacing;

  // Divider
  final bool showDivider;
  final Widget? customDivider;
  final Color? dividerColor;
  final double? dividerHeight;
  final double? dividerThickness;
  final EdgeInsetsGeometry? dividerIndent;

  const NesticoPeExpandableTile({
    super.key,
    required this.title,
    this.subtitle,
    this.customTitle,
    this.customSubtitle,
    this.leadingIcon,
    this.leadingWidget,
    this.trailingIcon,
    this.customTrailingWidget,
    this.children,
    this.expandedContent,
    this.builder,
    this.backgroundColor,
    this.expandedBackgroundColor,
    this.padding,
    this.margin,
    this.contentPadding,
    this.borderRadius,
    this.border,
    this.shadow,
    this.elevation,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.trailingIconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.animationDuration,
    this.animationCurve,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.onExpansionChanged,
    this.onTap,
    this.enabled = true,
    this.tileCrossAxisAlignment,
    this.tileMainAxisAlignment,
    this.expandedCrossAxisAlignment,
    this.expandedMainAxisAlignment,
    this.wrapAlignment,
    this.wrapCrossAlignment,
    this.wrapSpacing,
    this.wrapRunSpacing,
    this.showDivider = false,
    this.customDivider,
    this.dividerColor,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerIndent,
  });

  @override
  State<NesticoPeExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<NesticoPeExpandableTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve ?? Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    if (!widget.enabled) return;

    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    widget.onExpansionChanged?.call(_isExpanded);
    widget.onTap?.call();
  }

  Widget _buildLeadingWidget() {
    if (widget.leadingWidget != null) {
      return widget.leadingWidget!;
    } else if (widget.leadingIcon != null) {
      return Icon(
        widget.leadingIcon,
        color: widget.iconColor ?? Theme.of(context).primaryColor,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTrailingWidget() {
    if (widget.customTrailingWidget != null) {
      return widget.customTrailingWidget!;
    } else if (widget.trailingIcon != null) {
      return AnimatedRotation(
        turns: _isExpanded ? 0.5 : 0,
        duration: widget.animationDuration ?? const Duration(milliseconds: 300),
        child: Icon(
          widget.trailingIcon,
          color: widget.trailingIconColor ?? Colors.grey[700],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTitleWidget() {
    if (widget.customTitle != null) {
      return widget.customTitle!;
    }
    return Text(
      widget.title,
      style:
          widget.titleStyle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: widget.titleColor,
          ),
    );
  }

  Widget? _buildSubtitleWidget() {
    if (widget.customSubtitle != null) {
      return widget.customSubtitle;
    } else if (widget.subtitle != null) {
      return Text(
        widget.subtitle!,
        style:
            widget.subtitleStyle ??
            TextStyle(
              fontSize: 12,
              color: widget.subtitleColor ?? Colors.grey[600],
            ),
      );
    }
    return null;
  }

  Widget _buildExpandedContent() {
    if (widget.builder != null) {
      return widget.builder!(context, _isExpanded);
    } else if (widget.expandedContent != null) {
      return widget.expandedContent!;
    } else if (widget.children != null && widget.children!.isNotEmpty) {
      return Wrap(
        spacing: widget.wrapSpacing ?? 8,
        runSpacing: widget.wrapRunSpacing ?? 8,
        alignment: widget.wrapAlignment ?? WrapAlignment.start,
        crossAxisAlignment:
            widget.wrapCrossAlignment ?? WrapCrossAlignment.start,
        clipBehavior: Clip.none,
        children: widget.children!,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDivider() {
    if (!widget.showDivider) return const SizedBox.shrink();

    if (widget.customDivider != null) {
      return widget.customDivider!;
    }

    return Container(
      margin: widget.dividerIndent,
      child: Divider(
        height: widget.dividerHeight ?? 1,
        thickness: widget.dividerThickness ?? 0.5,
        color: widget.dividerColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget tile = Column(
      crossAxisAlignment:
          widget.tileCrossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisAlignment:
          widget.tileMainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        // Main tile
        Container(
          margin: widget.margin,
          decoration: BoxDecoration(
            color:
                _isExpanded
                    ? (widget.expandedBackgroundColor ?? widget.backgroundColor)
                    : widget.backgroundColor,
            borderRadius: widget.borderRadius,
            border: widget.border,
            boxShadow: widget.shadow != null ? [widget.shadow!] : null,
          ),
          child: Material(
            color: ColorRes.transparentColor,
            child: InkWell(
              borderRadius: widget.borderRadius,
              onTap: widget.enabled ? _toggleExpand : null,
              child: Padding(
                padding: widget.contentPadding ?? const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Leading
                    _buildLeadingWidget(),
                    if (widget.leadingWidget != null ||
                        widget.leadingIcon != null)
                      const SizedBox(width: 16),

                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTitleWidget(),
                          if (_buildSubtitleWidget() != null) ...[
                            const SizedBox(height: 4),
                            _buildSubtitleWidget()!,
                          ],
                        ],
                      ),
                    ),

                    // Trailing
                    const SizedBox(width: 16),
                    _buildTrailingWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Expanded content
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            width: double.infinity,
            padding: widget.padding,
            child: Column(
              crossAxisAlignment:
                  widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.start,
              mainAxisAlignment:
                  widget.expandedMainAxisAlignment ?? MainAxisAlignment.start,
              children: [_buildExpandedContent()],
            ),
          ),
        ),

        // Divider
        _buildDivider(),
      ],
    );

    // Add elevation if specified
    if (widget.elevation != null && widget.elevation! > 0) {
      return Card(
        elevation: widget.elevation,
        margin: EdgeInsets.zero,
        child: tile,
      );
    }

    return tile;
  }
}

// Helper class for common configurations
class ExpandableTileConfig {
  static NesticoPeExpandableTile simple({
    required String title,
    String? subtitle,
    IconData? leadingIcon,
    IconData trailingIcon = Icons.keyboard_arrow_down,
    List<Widget> children = const [],
    bool initiallyExpanded = false,
    ValueChanged<bool>? onExpansionChanged,
  }) {
    return NesticoPeExpandableTile(
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      children: children,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
    );
  }

  static NesticoPeExpandableTile card({
    required String title,
    String? subtitle,
    IconData? leadingIcon,
    IconData trailingIcon = Icons.keyboard_arrow_down,
    List<Widget> children = const [],
    Color? backgroundColor,
    double elevation = 2,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return NesticoPeExpandableTile(
      title: title,
      subtitle: subtitle,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      children: children,
      backgroundColor: backgroundColor,
      elevation: elevation,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      showDivider: false,
    );
  }

  static NesticoPeExpandableTile custom({
    required Widget customTitle,
    Widget? customSubtitle,
    Widget? leadingWidget,
    Widget? customTrailingWidget,
    Widget? expandedContent,
    Widget Function(BuildContext, bool)? builder,
    Duration? animationDuration,
    Curve? animationCurve,
    bool initiallyExpanded = false,
    ValueChanged<bool>? onExpansionChanged,
  }) {
    return NesticoPeExpandableTile(
      title: '', // Required but not used when customTitle is provided
      customTitle: customTitle,
      customSubtitle: customSubtitle,
      leadingWidget: leadingWidget,
      customTrailingWidget: customTrailingWidget,
      expandedContent: expandedContent,
      builder: builder,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
    );
  }
}

// Usage Examples:

// 1. Simple usage (like your original)
/*
ExpandableTile(
  title: "Settings",
  subtitle: "Configure your preferences",
  leadingIcon: Icons.settings,
  trailingIcon: Icons.keyboard_arrow_down,
  children: [
    Chip(label: Text("Option 1")),
    Chip(label: Text("Option 2")),
  ],
)
*/

// 2. Card style
/*
ExpandableTileConfig.card(
  title: "Categories",
  leadingIcon: Icons.category,
  backgroundColor: Colors.blue.shade50,
  children: categoryWidgets,
)
*/

// 3. Fully custom
/*
ExpandableTile(
  title: "Custom",
  customTitle: Row(
    children: [
      CircleAvatar(child: Text("A")),
      SizedBox(width: 8),
      Text("Custom Title"),
    ],
  ),
  builder: (context, isExpanded) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isExpanded ? 200 : 0,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          title: Text("Item $index"),
        ),
      ),
    );
  },
)
*/

// 4. Data-driven approach
/*
class DataExpandableTile<T> extends ExpandableTile {
  final List<T> data;
  final Widget Function(T item) itemBuilder;
  final String Function(T item)? itemTitle;
  final String Function(T item)? itemSubtitle;

  DataExpandableTile({
    required String title,
    required this.data,
    required this.itemBuilder,
    this.itemTitle,
    this.itemSubtitle,
    super.key,
    super.subtitle,
    super.leadingIcon,
    super.trailingIcon,
  }) : super(
    title: title,
    children: data.map((item) => itemBuilder(item)).toList(),
  );
}
*/
