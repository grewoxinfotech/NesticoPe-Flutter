import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../widgets/New folder/inputs/search_dropdown_field.dart';
import '../../../google_search/controllers/google_map_search_controller.dart';
import '../../../search_property/model/search_model.dart';

class CityZipcodeSelector extends StatefulWidget {
  final Function(String city, String zipcode)? onSelected;
  final String? initialCity;
  final String? initialZipcode;

  const CityZipcodeSelector({
    super.key,
    this.onSelected,
    this.initialCity,
    this.initialZipcode,
  });

  @override
  State<CityZipcodeSelector> createState() => _CityZipcodeSelectorState();
}

class _CityZipcodeSelectorState extends State<CityZipcodeSelector> {
  final GoogleMapSearchController _controller = Get.put(
    GoogleMapSearchController(),
  );
  final TextEditingController _zipcodeController = TextEditingController();

  final RxString _selectedCity = ''.obs;
  final RxBool _isZipcodeValid = false.obs;
  final RxString _zipErrorText = ''.obs;

  @override
  void initState() {
    super.initState();
    if (widget.initialCity != null) _selectedCity.value = widget.initialCity!;
    if (widget.initialZipcode != null) {
      _zipcodeController.text = widget.initialZipcode!;
      _isZipcodeValid.value = true;
    }
  }

  void _onCitySelected(Prediction p) {
    _selectedCity.value =
        p.structuredFormatting?.mainText ?? p.description ?? '';
    _zipcodeController.clear();
    _isZipcodeValid.value = false;
    _zipErrorText.value = '';

    // Reset predictions list so it's fresh for the next search
    _controller.predictions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- City Search Dropdown ---
        Expanded(
          flex: 6,
          child: Obx(
            () => NesticoPeSearchDropdown<Prediction>(
              title: "City",
              isRequired: true,
              hintText:
                  _selectedCity.value.isEmpty
                      ? "Search City"
                      : _selectedCity.value,
              items: _controller.predictions.toList(),
              itemLabel:
                  (p) =>
                      p.structuredFormatting?.mainText ?? p.description ?? '',
              isLoading: _controller.isLoading.value,
              prefixIcon: Icons.location_city,
              onSearchChanged: (val) {
                if (val.length > 2) _controller.fetchPredictionsCity(val);
              },
              onChanged: (prediction) => _onCitySelected(prediction),
              titleStyle: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // --- Pincode Input ---
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pincode",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
              AppSpacing.verticalSmall,
              Obx(
                () => TextField(
                  controller: _zipcodeController,
                  enabled: _selectedCity.value.isNotEmpty,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    hintText: "Pin Code",
                    contentPadding: const EdgeInsets.all(AppPadding.small),
                    filled: true,
                    fillColor:
                        _selectedCity.value.isNotEmpty
                            ? Colors.white
                            : Colors.grey.shade100,
                    // prefixIcon:
                    //     _controller.isVerifying.value
                    //         ? const Padding(
                    //           padding: EdgeInsets.all(12),
                    //           child: CircularProgressIndicator(strokeWidth: 2),
                    //         )
                    //         : const Icon(Icons.location_on_outlined, size: 20),
                    suffixIcon:
                        _isZipcodeValid.value
                            ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                            : null,
                    errorText:
                        _zipErrorText.value.isEmpty
                            ? null
                            : _zipErrorText.value,
                    enabledBorder: _tile(Get.theme.dividerColor),
                    focusedBorder: _tile(Get.theme.primaryColor),
                    disabledBorder: _tile(ColorRes.leadGreyColor),
                    errorBorder: _tile(ColorRes.error),
                    focusedErrorBorder: _tile(ColorRes.error),
                  ),
                  onChanged: (val) async {
                    if (val.length == 6) {
                      bool valid = await _controller.verifyZipcodeDynamic(
                        val,
                        _selectedCity.value,
                      );
                      _isZipcodeValid.value = valid;
                      _zipErrorText.value = valid ? "" : "Invalid Zip";
                      if (valid)
                        widget.onSelected?.call(_selectedCity.value, val);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputBorder _tile(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.medium),
    borderSide: BorderSide(color: color, width: 1),
  );
}
