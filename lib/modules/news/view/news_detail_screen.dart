import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/network/news/news_model.dart';

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
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar with Cover Image
              SliverAppBar(
                expandedHeight: isTablet ? 400 : 250,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: ColorRes.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: ColorRes.white),
                      onPressed: _shareArticle,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
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
                ],
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
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[300],
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
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
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
                            style: const TextStyle(
                              color: ColorRes.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        newsItem.title ?? 'Untitled',
                        style: TextStyle(
                          fontSize: isTablet ? 32 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Summary
                      if (newsItem.summary != null)
                        Text(
                          newsItem.summary!,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Author Info and Metadata
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (newsItem.authorDesignation != null)
                                    Text(
                                      newsItem.authorDesignation!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
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
                        spacing: 20,
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
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //
                          //     Icon(
                          //       Icons.calendar_today,
                          //       size: 16,
                          //       color: Colors.grey[600],
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       _formatDate(newsItem.publishDate),
                          //       style: TextStyle(
                          //         color: Colors.grey[600],
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          //
                          // // const SizedBox(width: 20),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //
                          //   children: [
                          //     Icon(
                          //       Icons.access_time,
                          //       size: 16,
                          //       color: Colors.grey[600],
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       '${newsItem.readTime ?? 5} min read',
                          //       style: TextStyle(
                          //         color: Colors.grey[600],
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          //
                          // // const SizedBox(width: 20),
                          // Row(
                          //   mainAxisSize: MainAxisSize.min,
                          //
                          //   children: [
                          //     Icon(
                          //       Icons.visibility,
                          //       size: 16,
                          //       color: Colors.grey[600],
                          //     ),
                          //     const SizedBox(width: 4),
                          //     Text(
                          //       '${newsItem.viewCount ?? 0} views',
                          //       style: TextStyle(
                          //         color: Colors.grey[600],
                          //         fontSize: 14,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Tags
                      if (newsItem.tags != null && newsItem.tags!.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              newsItem.tags!.map((tag) {
                                return Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorRes.primary,
                                  ),
                                );
                              }).toList(),
                        ),
                      const SizedBox(height: 24),

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
                      //         fontWeight: FontWeight.bold,
                      //         margin: Margins.symmetric(vertical: 16),
                      //       ),
                      //       "h2": Style(
                      //         fontSize: FontSize(isTablet ? 24 : 20),
                      //         fontWeight: FontWeight.bold,
                      //         margin: Margins.symmetric(vertical: 14),
                      //       ),
                      //       "h3": Style(
                      //         fontSize: FontSize(isTablet ? 20 : 18),
                      //         fontWeight: FontWeight.bold,
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
                      Text(
                        '${newsItem.content}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 40),

                      // Share Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Share this article',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: _shareArticle,
                                  tooltip: 'Share',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: newsItem.title ?? ''),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Link copied to clipboard',
                                        ),
                                      ),
                                    );
                                  },
                                  tooltip: 'Copy Link',
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

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: ColorRes.primary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }
}
