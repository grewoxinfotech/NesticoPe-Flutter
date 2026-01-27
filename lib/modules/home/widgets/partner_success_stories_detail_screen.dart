import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/property_rating/view/widget/read_more_or_less.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/history/model/success_story_model.dart';


class ResellerSuccessDetailScreen extends StatelessWidget {
  final BuyerSideResellerSuccessStoryItem successStory;

  const ResellerSuccessDetailScreen({
    Key? key,
    required this.successStory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Success Story Details",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼 Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  successStory.image ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 16),
          
              // 🏷 Title
              Text(
                successStory.title ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
          
              // 📅 Month + Date Info
              Row(
                children: [
                  if (successStory.monthYear != null)
                    Text(
                      "${DateFormat.MMM().format(successStory.monthYear!)} ${successStory.monthYear!.year}",
                      style:  TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                        fontWeight: AppFontWeights.medium
                      ),
                    ),
                  const Spacer(),
                  if (successStory.updatedAt != null)
                    Text(
                      "Updated: ${DateFormat('yyyy-MM-dd').format(successStory.updatedAt!)}",
                      style:  TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
                          fontWeight: AppFontWeights.medium
          
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
          
              // 🏆 Achievement
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ReadMoreClass(description: successStory.achievement??'', trimLines: 3, size: 10, colorClickableText: ColorRes.primary),
              ),
              const SizedBox(height: 16),
          
              // 📖 Description
           /*   Text(
                successStory.description ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),*/
              ReadMoreClass(description: successStory.description ?? '', trimLines: 3, size: 10, colorClickableText: ColorRes.primary),
              const SizedBox(height: 20),
          
              // 💰 Deals + Value + Rating
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300,width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoTile(
                      title: "${successStory.totalDeals ?? 0}",
                      subtitle: "Total Deals",
                      icon: Icons.handshake,
                      color: Colors.blueAccent,
                    ),
                    _infoTile(
                      title:
                      "₹${NumberFormat.compact().format(double.tryParse(successStory.totalValue ?? '0') ?? 0)}",
                      subtitle: "Total Value",
                      icon: Icons.currency_rupee,
                      color: Colors.green,
                    ),
                    _infoTile(
                      title: "${successStory.rating ?? 0}/5",
                      subtitle: "Rating",
                      icon: Icons.star,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
