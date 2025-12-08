import 'package:flutter/material.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../controller/contractor_my_service_controller.dart';
import 'package:get/get.dart';


class MyServiceScreen extends StatelessWidget {
  const MyServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractorMyServiceController>();
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: Text(
          'Service Categories',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: controller.contractorServiceCategory.value?.data.items.length,
          itemBuilder: (context, index) {
            final service = controller.contractorServiceCategory.value?.data.items[index];
            return GestureDetector(onTap: () {
              _showServiceDialog(context, service??ContractorServiceCategory.fromMap({}));
            },child: _buildServiceCard(service??ContractorServiceCategory.fromMap({})));
          },
        ),
      ),
    );
  }
  void _showServiceDialog(BuildContext context, ContractorServiceCategory service) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: ColorRes.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service.name,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: service.isActive
                            ? ColorRes.success.withOpacity(0.1)
                            : ColorRes.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: service.isActive
                              ? ColorRes.success
                              : ColorRes.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.medium,
                        color: ColorRes.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(ContractorServiceCategory service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(12),
      border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: service.isActive
                      ? ColorRes.success.withOpacity(0.1)
                      : ColorRes.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                    color:
                    service.isActive ? ColorRes.success : ColorRes.error,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Description
          Text(
            service.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textSecondary,
              fontWeight: AppFontWeights.regular,
            ),
          ),

          const SizedBox(height: 10),

          // Date
          Text(
            _formatDate(service.createdAt),
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format like "15 Aug 2023"
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}
