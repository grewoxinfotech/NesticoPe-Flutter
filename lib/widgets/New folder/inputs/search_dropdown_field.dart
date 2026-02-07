import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/constants/ic_res.dart';
import '../../../app/constants/size_manager.dart';
import '../../display/ic.dart';

class NesticoPeSearchDropdown<T> extends StatefulWidget {
  final String? title;
  final String? hintText;
  final List<T> items;
  final String Function(T) itemLabel;
  final Function(T) onChanged;
  final Function(String) onSearchChanged;
  final bool isRequired;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isLoading;
  final TextStyle titleStyle;

  const NesticoPeSearchDropdown({
    super.key,
    this.title,
    this.hintText,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    required this.onSearchChanged,
    this.isRequired = false,
    this.prefixIcon,
    this.enabled = true,
    this.isLoading = false,
    this.titleStyle = const TextStyle(
      fontSize: AppFontSizes.medium,
      color: ColorRes.textSecondary,
      fontWeight: AppFontWeights.bold,
    ),
  });

  @override
  State<NesticoPeSearchDropdown<T>> createState() =>
      _NesticoPeSearchDropdownState<T>();
}

class _NesticoPeSearchDropdownState<T>
    extends State<NesticoPeSearchDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _hideOverlay();
    });
  }

  // REFRESH LOGIC: Rebuild overlay when data changes
  @override
  void didUpdateWidget(covariant NesticoPeSearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen && _overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  void _showOverlay() {
    if (_isOpen) {
      _overlayEntry?.markNeedsBuild();
      return;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _hideOverlay() {
    if (!_isOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 5),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                color: Colors.white,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.dividerColor),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child:
                      widget.isLoading
                          ? const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : widget.items.isEmpty
                          ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No results found"),
                          )
                          : ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            separatorBuilder:
                                (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade300,
                                ),
                            itemBuilder: (context, index) {
                              final item = widget.items[index];
                              return ListTile(
                                title: Text(
                                  widget.itemLabel(item),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                onTap: () {
                                  widget.onChanged(item);
                                  _searchController.text = widget.itemLabel(
                                    item,
                                  );
                                  _hideOverlay();
                                  _focusNode.unfocus();
                                },
                              );
                            },
                          ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Row(
              children: [
                Text(widget.title!, style: widget.titleStyle),
                if (widget.isRequired)
                  const Text(' *', style: TextStyle(color: ColorRes.error)),
              ],
            ),
            AppSpacing.verticalSmall,
          ],
          TextFormField(
            controller: _searchController,
            focusNode: _focusNode,
            enabled: widget.enabled,
            onTap: _showOverlay,
            onChanged: (val) {
              _showOverlay();
              widget.onSearchChanged(val);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(AppPadding.small),
              filled: true,
              fillColor: widget.enabled ? Colors.white : Colors.grey.shade100,
              hintText: widget.hintText,
              prefixIcon:
                  widget.prefixIcon != null
                      ? Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: ColorRes.primary,
                      )
                      : null,
              suffixIcon: Icon(
                _isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: Get.theme.primaryColor,
              ),
              enabledBorder: _tile(Get.theme.dividerColor),
              focusedBorder: _tile(Get.theme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _tile(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.medium),
    borderSide: BorderSide(color: color, width: 1),
  );
}
