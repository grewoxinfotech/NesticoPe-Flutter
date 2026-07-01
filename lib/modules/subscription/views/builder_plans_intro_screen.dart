import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/enum.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/subscription/views/suscription_plan_screen.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/intro_common.dart';

class BuilderPlansIntroScreen extends StatelessWidget {
  const BuilderPlansIntroScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: Get.back,
        ),
        title: Text(
          'Builder Plans',
          style: TextStyle(fontWeight: AppFontWeights.semiBold, color: ColorRes.white),
        ),
        backgroundColor: ColorRes.primary,



      ),
      body: SafeArea(

        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSection(onViewPlans: _openPlans),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Developer Solutions', subtitle: 'Designed for large scale projects and high-volume sales management'),
              const SizedBox(height: 16),
              _FeaturesRow(children: const [
                _FeatureCard(icon: Icons.photo_library_outlined, title: 'Project Showcase', subtitle: 'Feature your entire project portfolio with dedicated galleries.'),
                _FeatureCard(icon: Icons.groups_3_outlined, title: 'Bulk Lead Generation', subtitle: 'Get high-intent corporate and individual leads.'),
                _FeatureCard(icon: Icons.badge_outlined, title: 'Developer Authority', subtitle: 'Premium verified builder profile and RERA badges.'),
                _FeatureCard(icon: Icons.support_agent_outlined, title: 'Enterprise Support', subtitle: 'Dedicated account managers for seamless updates.'),
              ]),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Premium Developer Projects', subtitle: 'Showcase your architectural marvels to high-intent investors'),
              const SizedBox(height: 12),
              const _ProjectList(),
              const SizedBox(height: 24),
              _SectionTitle(title: 'Sell with NesticoPe', subtitle: "Join India's fastest growing developer ecosystem and scale your sales"),
              const SizedBox(height: 16),
              _SellWithForm(onViewPlans: _openPlans),
              const SizedBox(height: 24),
              _ScaleCta(onViewPlans: _openPlans),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPlans() async {
    
    Get.to(
      () => SubscriptionPlansScreen(
        role: Roles.sellerBuilder.name,
  
        origin: 'buyer',
        isNotFromBuyerSide: false,
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final VoidCallback onViewPlans;
  const _HeroSection({required this.onViewPlans});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: ColorRes.primary,

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Scale Your Real Estate Vision',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'The most powerful ecosystem for developers to showcase projects and manage inventory',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(text: 'View Plans', onTap: onViewPlans, backgroundColor: ColorRes.primary, textColor: Colors.white),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _StatItem(value: '500+', label: 'Projects listed'),
              _StatItem(value: '50k+', label: 'Monthly leads'),
              _StatItem(value: '100+', label: 'Top Developers'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.leadGreyColor[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesRow extends StatelessWidget {
  final List<Widget> children;
  const _FeaturesRow({required this.children});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(width: 260, child: children[index]);
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCard({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ColorRes.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList();
  @override
  Widget build(BuildContext context) {
    final items = [
      {'image': IMGRes.home1, 'title': 'Skyline Residency', 'subtitle': 'Vesu, Surat', 'badge': 'Featured', 'badgeColor': const Color(0xFFF59E0B)},
      {'image': IMGRes.project_2, 'title': 'Business Hub Center', 'subtitle': 'Adajan, Surat', 'badge': 'Premium', 'badgeColor': const Color(0xFF7C3AED)},
      {'image': IMGRes.home3, 'title': 'Green Valley Estates', 'subtitle': 'Dumas, Surat', 'badge': 'Elite', 'badgeColor': const Color(0xFF10B981)},
      {'image': IMGRes.home4, 'title': 'Metro Heights', 'subtitle': 'Varachha, Surat', 'badge': 'Standard', 'badgeColor': const Color(0xFFF59E0B)},
    ];
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _ProjectCard(
            image: item['image'] as String,
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            badge: item['badge'] as String,
            badgeColor: item['badgeColor'] as Color,
          );
        },
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  const _ProjectCard({required this.image, required this.title, required this.subtitle, required this.badge, required this.badgeColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(image, height: 140, width: 280, fit: BoxFit.cover),
                Positioned(top: 10, right: 10, child: TagChip(text: badge, color: badgeColor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: AppFontSizes.body, fontWeight: AppFontWeights.semiBold, color: ColorRes.leadGreyColor[900]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SellWithForm extends StatelessWidget {
  final VoidCallback onViewPlans;
  const _SellWithForm({required this.onViewPlans});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Bullet(text: 'Massive Buyer Network'),
                SizedBox(height: 12),
                _Bullet(text: 'NesticoPe Premium Support'),
                SizedBox(height: 12),
                _Bullet(text: 'Advanced CRM Tools'),
                SizedBox(height: 12),
                _Bullet(text: 'Brand Authority'),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Send Inquiry', style: TextStyle(fontWeight: AppFontWeights.semiBold, fontSize: AppFontSizes.body)),
                  const SizedBox(height: 12),
                  _Input(hint: 'Full Name'),
                  const SizedBox(height: 10),
                  _Input(hint: 'Email Address'),
                  const SizedBox(height: 10),
                  _Input(hint: 'Phone Number'),
                  const SizedBox(height: 12),
                  _PrimaryButton(text: 'Get Started Now', onTap: onViewPlans, textColor: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: ColorRes.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: ColorRes.leadGreyColor[900], fontWeight: AppFontWeights.semiBold),
          ),
        ),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  final String hint;
  const _Input({required this.hint});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}

class _ScaleCta extends StatelessWidget {
  final VoidCallback onViewPlans;
  const _ScaleCta({required this.onViewPlans});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CircleAvatar(radius: 22, backgroundColor: ColorRes.leadGreyColor.shade100, child: Icon(Icons.apartment_outlined, color: ColorRes.primary)),
          const SizedBox(height: 12),
          Text('Scale Your Construction Business Today!', textAlign: TextAlign.center, style: TextStyle(fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.leadGreyColor[900],)),
          const SizedBox(height: 8),
          Text('Join the elite group of developers who trust NesticoPe.', textAlign: TextAlign.center, style: TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor[600])),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            _MetricItem(value: '500+', label: 'ACTIVE BUILDERS'),
            _MetricDivider(),
            _MetricItem(value: '10k+', label: 'UNITS SOLD'),
            _MetricDivider(),
            _MetricItem(value: '24/7', label: 'SUPPORT'),
          ]),
          const SizedBox(height: 16),
          _PrimaryButton(text: 'View Plans', onTap: onViewPlans, textColor: Colors.white),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  const _PrimaryButton({required this.text, required this.onTap, this.backgroundColor, this.textColor});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: backgroundColor ?? ColorRes.primary,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? ColorRes.primary).withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? ColorRes.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: AppFontSizes.caption, color: Colors.white.withOpacity(0.9))),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String label;
  const _MetricItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: AppFontWeights.semiBold, color: ColorRes.leadGreyColor[900])),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor[600])),
        ],
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();
  @override
  Widget build(BuildContext context) {
    return Container(height: 24, width: 1, color: ColorRes.leadGreyColor.shade300, margin: const EdgeInsets.symmetric(horizontal: 8));
  }
}
