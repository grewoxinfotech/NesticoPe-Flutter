import 'package:flutter/material.dart';
import 'package:housing_flutter_app/widgets/bar/navigation_bar/navigation_Bar.dart';
import '../../../widgets/dialogs/delete_dialog.dart';
import '../../../widgets/drawer/drawer.dart';
import 'package:get/get.dart';

import '../../home/views/home_screen.dart';
import '../../saved_property/views/saved_property_screen.dart';
import '../../seller/seller_listing/view/seller_listing_view.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final List<String> categories = [
//     'All',
//     'Apartment',
//     'House',
//     'Villa',
//     'Condo',
//     'Penthouse',
//     'Studio',
//     'Commercial',
//   ];
//
//   String selectedCategory = 'All';
//
//   @override
//   Widget build(BuildContext context) {
//     final homeController = Provider.of<HomeController>(context);
//     final authController = Provider.of<AuthController>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Housing App'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_outlined),
//             onPressed: () {
//               // Navigate to notifications
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.favorite_outline),
//             onPressed: () {
//               // Navigate to favorites
//             },
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text('User'),
//               accountEmail: Text('user@example.com'),
//               currentAccountPicture: CircleAvatar(
//                 child: Icon(Icons.person, size: 40),
//               ),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               selected: true,
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.search),
//               title: Text('Search'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to search
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.bookmark_outline),
//               title: Text('Bookings'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to bookings
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person_outline),
//               title: Text('Profile'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to profile
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.settings_outlined),
//               title: Text('Settings'),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Navigate to settings
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 //await authController.logout();
//                 Navigator.of(context).pushReplacementNamed('/login');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: homeController.isLoading
//           ? Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: () async {
//                 await homeController.getFeaturedProperties();
//                 await homeController.getRecommendedProperties();
//               },
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Search Bar
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Search for properties...',
//                             prefixIcon: Icon(Icons.search),
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(vertical: 15),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 24),
//
//                       // Featured Properties
//                       Text(
//                         'Featured Properties',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       SizedBox(height: 16),
//                       SizedBox(
//                         height: 220,
//                         child: homeController.featuredProperties.isEmpty
//                             ? Center(child: Text('No featured properties found'))
//                             : ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: homeController.featuredProperties.length,
//                                 itemBuilder: (context, index) {
//                                   final property = homeController.featuredProperties[index];
//                                   return _buildFeaturedPropertyCard(property);
//                                 },
//                               ),
//                       ),
//                       SizedBox(height: 24),
//
//                       // Categories
//                       Text(
//                         'Categories',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       SizedBox(height: 16),
//                       SizedBox(
//                         height: 50,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categories.length,
//                           itemBuilder: (context, index) {
//                             return _buildCategoryItem(categories[index]);
//                           },
//                         ),
//                       ),
//                       SizedBox(height: 24),
//
//                       // Recommended Properties
//                       Text(
//                         'Recommended For You',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       SizedBox(height: 16),
//                       homeController.recommendedProperties.isEmpty
//                           ? Center(child: Text('No recommended properties found'))
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: homeController.recommendedProperties.length,
//                               itemBuilder: (context, index) {
//                                 final property = homeController.recommendedProperties[index];
//                                 return _buildPropertyCard(property);
//                               },
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
//
//   Widget _buildCategoryItem(String category) {
//     final isSelected = selectedCategory == category;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedCategory = category;
//         });
//       },
//       child: Container(
//         margin: EdgeInsets.only(right: 12),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Center(
//           child: Text(
//             category,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.black,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeaturedPropertyCard(PropertyModel property) {
//     return Container(
//       width: 280,
//       margin: EdgeInsets.only(right: 16),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         clipBehavior: Clip.antiAlias,
//         child: InkWell(
//           onTap: () {
//             // Navigate to home details
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Property Image
//               Stack(
//                 children: [
//                   SizedBox(
//                     height: 120,
//                     width: double.infinity,
//                     child: CachedNetworkImage(
//                       imageUrl: property.imageUrl,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(color: Colors.white),
//                       ),
//                       errorWidget: (context, url, error) => Container(
//                         color: Colors.grey[300],
//                         child: Icon(Icons.error, color: Colors.red),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '\$${property.price.toStringAsFixed(0)}',
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               // Property Details
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       property.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       property.location,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(child: _buildFeatureChip(Icons.bed, '${property.bedrooms} Beds')),
//                         Flexible(child: _buildFeatureChip(Icons.bathtub_outlined, '${property.bathrooms} Baths')),
//                         Flexible(child: _buildFeatureChip(Icons.square_foot, '${property.area} sqft')),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPropertyCard(PropertyModel property) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: () {
//           // Navigate to property details
//         },
//         child: Container(
//           height: 210, // Fixed height to avoid overflow
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Property Image - Fixed height
//               Container(
//                 height: 120,
//                 width: double.infinity,
//                 child: CachedNetworkImage(
//                   imageUrl: property.imageUrl,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Container(color: Colors.white),
//                   ),
//                   errorWidget: (context, url, error) => Container(
//                     color: Colors.grey[300],
//                     child: Icon(Icons.error, color: Colors.red),
//                   ),
//                 ),
//               ),
//
//               // Property Details - Use Expanded to take remaining space
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         property.title,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         property.location,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                       Spacer(),
//                       // Feature chips
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Expanded(child: _buildFeatureChip(Icons.bed, '${property.bedrooms}')),
//                           Expanded(child: _buildFeatureChip(Icons.bathtub_outlined, '${property.bathrooms}')),
//                           Expanded(child: _buildFeatureChip(Icons.square_foot, '${property.area}')),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeatureChip(IconData icon, String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[700]),
//           SizedBox(width: 4),
//           Flexible(
//             child: Text(
//               text,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//test commit
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());
    return Scaffold(
      extendBody: true,
      drawer: NesticoPeDrawer(),
      bottomNavigationBar: const SafeArea(child: NesticoPeNavigationBar()),
      body: Obx(() {
        if (navigationController.currentIndex.value == 0) {
          return const HomeScreen();
        } else if (navigationController.currentIndex.value == 1) {
          return const Center(child: NesticoPeDeleteDialog());
        } else if (navigationController.currentIndex.value == 2) {
          return SellerListingView();
        } else if (navigationController.currentIndex.value == 3) {
          return const Center(child: Text("No Update"));
        } else if (navigationController.currentIndex.value == 4) {
          return const SavedPropertyScreen();
        } else if (navigationController.currentIndex.value == 5) {
          return const SavedPropertyScreen();
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
