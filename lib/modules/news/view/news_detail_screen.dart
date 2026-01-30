import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/news/news_model.dart';
import '../../property_rating/view/widget/read_more_or_less.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({Key? key, required this.newsItem}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showBackToTop = _scrollController.offset > 500;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _shareArticle() {
    final shareText =
        '${widget.newsItem.title ?? ''}\n\n${widget.newsItem.summary ?? ''}';
    Share.share(shareText);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsItem = widget.newsItem;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: ColorRes.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [

              SliverAppBar(
                expandedHeight: isTablet ? 400 : 250,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorRes.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: ColorRes.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
         /*       actions: [
                  // Container(
                  //   margin: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     color: ColorRes.black.withOpacity(0.5),
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.share, color: ColorRes.white),
                  //     onPressed: _shareArticle,
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorRes.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: ColorRes.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Article saved')),
                        );
                      },
                    ),
                  ),
                ],*/
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (newsItem.coverImage != null)
                        CachedNetworkImage(
                          imageUrl: newsItem.coverImage!,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: ColorRes.leadGreyColor[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: ColorRes.leadGreyColor[300],
                                child: const Icon(Icons.error, size: 50),
                              ),
                        )
                      else
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: const Icon(
                            Icons.article,
                            size: 80,
                            color: ColorRes.white,
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ColorRes.transparentColor,
                              ColorRes.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Article Content
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 40 : 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      if (newsItem.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            newsItem.category!.capitalize.toString().replaceAll(
                              "_",
                              " ",
                            ),
                            style:  TextStyle(
                              color: ColorRes.white,
                              fontSize: AppFontSizes.extraSmall,
                              fontWeight: AppFontWeights.semiBold,
                              letterSpacing: 0.5
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        newsItem.title ?? 'Untitled',
                        style: TextStyle(
                          fontSize: isTablet ? AppFontSizes.subtitle : AppFontSizes.large,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                          height: 1.3,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Summary
                      if (newsItem.summary != null)
                        Text(
                          newsItem.summary!,
                          style: TextStyle(
                            fontSize: isTablet ? AppFontSizes.bodyMedium : AppFontSizes.small,
                            color: ColorRes.leadGreyColor[600],
                            fontWeight: AppFontWeights.regular,
                            height: 1.6,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Author Info and Metadata
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                newsItem.author
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    'A',
                                style: const TextStyle(
                                  color: ColorRes.white,
                                  fontSize: AppFontSizes.body,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    newsItem.author ?? 'Unknown Author',
                                    style:  TextStyle(
                                      fontWeight: AppFontWeights.semiBold,
                                      fontSize: AppFontSizes.bodyMedium,
                                      color: ColorRes.textPrimary
                                    ),
                                  ),
                                  if (newsItem.authorDesignation != null)
                                    Text(
                                      newsItem.authorDesignation!,
                                      style: TextStyle(
                                        color: ColorRes.leadGreyColor[600],
                                        fontSize: AppFontSizes.caption,
                                        fontWeight: AppFontWeights.regular,
                                      ),
                                    ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Article Stats
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildIconText(
                            Icons.calendar_today,
                            _formatDate(newsItem.publishDate),
                          ),
                          _buildIconText(
                            Icons.access_time,
                            '${newsItem.readTime ?? 5} min read',
                          ),
                          _buildIconText(
                            Icons.visibility,
                            '${newsItem.viewCount ?? 0} views',
                          ),

                        ],
                      ),
                      const SizedBox(height: 24),

                      // Tags

                      // Content
                      // if (newsItem.content != null)
                      //   Html(
                      //     data: newsItem.content,
                      //     style: {
                      //       "body": Style(
                      //         fontSize: FontSize(isTablet ? 18 : 16),
                      //         lineHeight: LineHeight(1.6),
                      //         color: Colors.grey[800],
                      //       ),
                      //       "h1": Style(
                      //         fontSize: FontSize(isTablet ? 28 : 24),
                      //         fontWeight: AppFontWeights.extraBold,
                      //         margin: Margins.symmetric(vertical: 16),
                      //       ),
                      //       "h2": Style(
                      //         fontSize: FontSize(isTablet ? 24 : 20),
                      //         fontWeight: AppFontWeights.extraBold,
                      //         margin: Margins.symmetric(vertical: 14),
                      //       ),
                      //       "h3": Style(
                      //         fontSize: FontSize(isTablet ? 20 : 18),
                      //         fontWeight: AppFontWeights.extraBold,
                      //         margin: Margins.symmetric(vertical: 12),
                      //       ),
                      //       "p": Style(
                      //         margin: Margins.only(bottom: 16),
                      //       ),
                      //       "img": Style(
                      //         margin: Margins.symmetric(vertical: 16),
                      //       ),
                      //       "blockquote": Style(
                      //         border: Border(
                      //           left: BorderSide(
                      //             color: Theme.of(context).primaryColor,
                      //             width: 4,
                      //           ),
                      //         ),
                      //         padding: HtmlPaddings.only(left: 16),
                      //         margin: Margins.symmetric(vertical: 16),
                      //         fontStyle: FontStyle.italic,
                      //         color: Colors.grey[700],
                      //       ),
                      //     },
                      //   )
                      // else
                      // Text(
                      //   '${newsItem.content}',
                      //   style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.leadGreyColor[800],fontWeight: AppFontWeights.regular,height: 1.6,),
                      // ),
                      ReadMoreClass(
                        description: '${newsItem.content}',
                        size: AppFontSizes.small,
                        trimLines: 18,
                        colorClickableText: ColorRes.primary,

                      ),
                      const SizedBox(height: 24),
                      if (newsItem.tags != null && newsItem.tags!.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                          newsItem.tags!.map((tag) {
                            return Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodySmall,
                                color: ColorRes.primary,
                                fontWeight: AppFontWeights.medium,
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 20),

                      // Share Section
                      // Container(
                      //   padding: const EdgeInsets.all(20),
                      //   decoration: BoxDecoration(
                      //     border: Border.all(color: ColorRes.leadGreyColor[300]!),
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       const Text(
                      //         'Share this article',
                      //         style: TextStyle(
                      //           fontSize: AppFontSizes.large,
                      //           fontWeight: AppFontWeights.extraBold,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 16),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           IconButton(
                      //             icon: const Icon(Icons.share),
                      //             onPressed: _shareArticle,
                      //             tooltip: 'Share',
                      //           ),
                      //           IconButton(
                      //             icon: const Icon(Icons.copy),
                      //             onPressed: () {
                      //               Clipboard.setData(
                      //                 ClipboardData(text: newsItem.title ?? ''),
                      //               );
                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 const SnackBar(
                      //                   content: Text(
                      //                     'Link copied to clipboard',
                      //                   ),
                      //                 ),
                      //               );
                      //             },
                      //             tooltip: 'Copy Link',
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),


                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: ColorRes.leadGreyColor[300]!,width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Share this article',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Help others discover this success by sharing it on your favorite platform.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: ColorRes.leadGreyColor[600],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildShareButton(
                                  icon: Icons.share,
                                  label: 'Share',
                                  onTap: _shareArticle,
                                ),
                                const SizedBox(width: 16),
                                _buildShareButton(
                                  icon: Icons.copy,
                                  label: 'Copy',
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: newsItem.title ?? ''),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Link copied to clipboard'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),




                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Back to Top Button
          if (_showBackToTop)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward, color: ColorRes.white),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: ColorRes.leadGreyColor[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: ColorRes.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: ColorRes.primary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: ColorRes.leadGreyColor[600], fontSize: AppFontSizes.small,fontWeight: AppFontWeights.medium)),
      ],
    );
  }
}
