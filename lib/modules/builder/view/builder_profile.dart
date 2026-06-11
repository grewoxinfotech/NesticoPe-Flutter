import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/modules/property_rating/view/widget/read_more_or_less.dart';

class BuilderProfile extends StatelessWidget {
  const BuilderProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        shadowColor: ColorRes.black,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: ColorRes.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              buildCompanyInfoCard(),
              _buildProjectPortfolio(),
              _buildPerformanceMetrics(),
              _buildTeamSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=400',
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prestige Builders',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Builder ID: PB12345',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
                      ),
                    ),
                    Text(
                      'New York, USA',
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: ColorRes.primary),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: ColorRes.primary,
                  ),
                  child: Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCompanyInfoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Company Info',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 14),

          // First Row: Company Type & Experience
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Type',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.leadGreyColor[600],
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      'Residential Developer',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experience',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor[600],
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '10+ Years',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: ColorRes.leadGreyColor.shade200, height: 1),
          const SizedBox(height: 8),

          // Second Row: Projects Completed & Ongoing Projects
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Projects Completed',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.leadGreyColor[600],
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '42',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ongoing Projects',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.leadGreyColor[600],
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '8',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          ReadMoreClass(
            description:
                'Prestige Builders is a premier real estate development firm specializing in luxury residential properties. With over a decade of experience, we have a proven track record of delivering high-quality homes that exceed expectations.',
            trimLines: 4,
            size: AppFontSizes.extraSmall,
            colorClickableText: ColorRes.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectPortfolio() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Project Portfolio',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(fontSize: AppFontSizes.caption),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildProjectCard(
                  'The Grandview Estates',
                  'Miami, FL',
                  '\$1.2M - \$2.5M',
                  'Sold Out',
                  ColorRes.purpleColor,
                  'https://picsum.photos/400/250?random=1',
                ),
                const SizedBox(width: 12),
                _buildProjectCard(
                  'Oakwood',
                  'Austin, TX',
                  '',
                  'Under Construction',
                  ColorRes.blueColor,
                  'https://picsum.photos/400/250?random=2',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    String location,
    String price,
    String status,
    Color statusColor,
    String image,
  ) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  debugPrint('Image load error: $exception');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.08),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight: AppFontWeights.medium,
                          color: statusColor,
                        ),
                      ),
                    ),

                    if (price.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(width: 8),
                      Text(
                        'Not Available',
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Metrics',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric('120+', 'Properties\nListed', ColorRes.primary),
              Container(
                width: 1,
                height: 60,
                color: ColorRes.leadGreyColor.shade300,
              ),
              _buildMetric('98%', 'Verified\nListings', ColorRes.green),
              Container(
                width: 1,
                height: 60,
                color: ColorRes.leadGreyColor.shade300,
              ),
              _buildMetric('\$75M+', 'Total Sales\nValue', ColorRes.primary),
            ],
          ),
          Divider(
            // width: 1,
            // height: 60,
            color: ColorRes.leadGreyColor.shade300,
          ),
          const SizedBox(height: 12),
          _buildReview(
            'Jane D.',
            'Flawless process from start to finish. Highly recommend!',
          ),
          const SizedBox(height: 12),
          _buildReview(
            'Mark S.',
            'The quality of construction is top-notch. Very impressed.',
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.leadGreyColor[700],
          ),
        ),
      ],
    );
  }

  Widget _buildReview(String name, String review) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: AppFontWeights.semiBold,
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(
                5,
                (index) =>
                    const Icon(Icons.star, color: Colors.orange, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Text(
          //   '"$review"',
          //   style: TextStyle(fontSize: AppFontSizes.extraSmall, color: ColorRes.leadGreyColor[700]),
          // ),
          ReadMoreClass(
            description: review,
            trimLines: 3,
            size: AppFontSizes.extraSmall,
            colorClickableText: ColorRes.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team & Partners',
            style: TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildTeamMember(
            'Sarah Johnson',
            'Lead Architect',
            'https://i.pravatar.cc/300?img=11',
          ),
          const SizedBox(height: 12),
          _buildTeamMember(
            'Michael Chen',
            'Project Manager',
            'https://i.pravatar.cc/300?img=22',
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ColorRes.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: ColorRes.primary, size: 20),
                SizedBox(width: 8),
                Text(
                  'Add Member',
                  style: TextStyle(
                    color: ColorRes.primary,

                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String image) {
    return Row(
      children: [
        CircleAvatar(radius: 24, backgroundImage: NetworkImage(image)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            Text(
              role,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.leadGreyColor[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
