import 'package:flutter/material.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../app/constants/app_font_sizes.dart';
import 'alphabet_search.dart';

class ChangeLocation extends StatefulWidget {
  const ChangeLocation({super.key});

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          title: buildCommonText(
            'Change Location',

            AppFontSizes.subtitle,
            AppFontWeights.semiBold,
            ColorRes.textColor,
            1,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildFilterHeadingPadding('Popular cities'),
                const SizedBox(height: 7),

                SizedBox(
                  height: MediaQuery.of(context).size.height - 195,
                  child: CityAlphabetList(letterCity: letterAlphabate),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
