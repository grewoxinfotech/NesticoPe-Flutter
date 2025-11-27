import 'package:flutter/material.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';

class RatingField extends FormField<double> {
  RatingField({
    super.key,
    required String title,
    required double rating,
    required Function(double) onRatingChanged,
    bool isRequired = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
         initialValue: rating,
         autovalidateMode: autovalidateMode,
         validator: (value) {
           if (isRequired && (value == null || value == 0)) {
             return 'Please provide a rating';
           }
           return null;
         },
         builder: (state) {
           final currentRating = state.value ?? 0.0;

           return Container(
             padding: const EdgeInsets.all(AppPadding.medium),
             decoration: BoxDecoration(
               color: ColorRes.white,
               borderRadius: BorderRadius.circular(AppRadius.medium),
               border: Border.all(
                 color:
                     state.hasError
                         ? ColorRes.error
                         : ColorRes.leadGreyColor.shade300,
               ),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Text(
                       title,
                       style: TextStyle(
                         fontSize: AppFontSizes.bodySmall,
                         fontWeight: AppFontWeights.semiBold,
                         color: ColorRes.textPrimary,
                       ),
                     ),
                     if (isRequired)
                       Text(
                         ' *',
                         style: TextStyle(
                           color: ColorRes.error,
                           fontSize: AppFontSizes.medium,
                         ),
                       ),
                     const Spacer(),
                     Text(
                       currentRating == 0
                           ? 'Not rated'
                           : currentRating <= 2
                           ? 'Less'
                           : currentRating <= 3
                           ? 'Good'
                           : currentRating <= 4
                           ? 'Very Good'
                           : 'Excellent',
                       style: TextStyle(
                         fontSize: AppFontSizes.small,
                         fontWeight: AppFontWeights.medium,
                         color:
                             currentRating == 0
                                 ? ColorRes.leadGreyColor
                                 : currentRating <= 2
                                 ? Colors.redAccent
                                 : currentRating <= 3
                                 ? Colors.orange
                                 : currentRating <= 4
                                 ? Colors.green
                                 : ColorRes.primary.withOpacity(0.9),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 12),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: List.generate(5, (index) {
                     return GestureDetector(
                       onTap: () {
                         final newRating = (index + 1).toDouble();
                         onRatingChanged(newRating);
                         state.didChange(newRating);
                       },
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 4),
                         child: Icon(
                           index < currentRating.floor()
                               ? Icons.star
                               : (index < currentRating
                                   ? Icons.star_half
                                   : Icons.star_outline),
                           color:
                               index < currentRating
                                   ? ColorRes.homeAmber.withOpacity(0.9)
                                   : ColorRes.leadGreyColor.shade300,
                           size: 30,
                         ),
                       ),
                     );
                   }),
                 ),
                 if (state.hasError)
                   Padding(
                     padding: const EdgeInsets.only(top: AppPadding.small),
                     child: Text(
                       state.errorText!,
                       style: TextStyle(
                         color: ColorRes.error,
                         fontSize: AppFontSizes.small,
                       ),
                     ),
                   ),
               ],
             ),
           );
         },
       );
}
