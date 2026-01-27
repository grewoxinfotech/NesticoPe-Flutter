import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart' hide ColorRes;

import '../../../app/constants/color_res.dart';
import '../../../data/network/news/news_model.dart';
import '../../news/view/news_detail_screen.dart';

class AllNewsArticleScreen extends StatefulWidget {
  final List<NewsItem> articles;
  const AllNewsArticleScreen({super.key,required this.articles});

  @override
  State<AllNewsArticleScreen> createState() => _AllNewsArticleScreenState();
}

class _AllNewsArticleScreenState extends State<AllNewsArticleScreen> {
  @override
  Widget build(BuildContext context) {
    bool isNewArticle(String? publishDate) {
      if (publishDate == null) return false;
      final published = DateTime.tryParse(publishDate);
      if (published == null) return false;
      return DateTime.now().difference(published).inDays <= 7;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("News & Articles",style: TextStyle(fontWeight: AppFontWeights.semiBold),),

      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        clipBehavior: Clip.none,
        itemCount:widget. articles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final article =widget. articles[index];
          final isNew = isNewArticle(article.publishDate);
          print("Image ------------------> ${article.coverImage}");
          return GestureDetector(
            onTap: () {
              Get.to(() => NewsDetailScreen(newsItem: article));
            },
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorRes.leadGreyColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top image section - No rounded top corners
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.black,
                      child: CustomImage(
                        type: CustomImageType.network,
                        src: article.coverImage,
                        height: 120,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  /// Content section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          article.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          article.content ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            height: 1.5,
                            color: ColorRes.leadGreyColor.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// Footer: author info and stats
                        Row(
                          children: [
                            // Author avatar
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Author name and date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.author ?? '',
                                    style: TextStyle(
                                      fontSize: AppFontSizes.small,
                                      color: ColorRes.textPrimary,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          article.slug ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.extraSmall,
                                            color:
                                            ColorRes
                                                .leadGreyColor
                                                .shade700,
                                            fontWeight:
                                            AppFontWeights.regular,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        _formatDate(article.publishDate),
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          color: ColorRes.leadGreyColor,
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = [
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
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
