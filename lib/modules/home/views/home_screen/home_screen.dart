import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/cards/banner_card_with_text.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/contractor/model/contractot_service_model/contractor_service_category_model.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/data/network/trending_area/model/trending_area_model.dart';
import 'package:nesticope_app/modules/builder/controller/builder_form_controller.dart';
import 'package:nesticope_app/modules/builder/view/all_project_list_screen.dart';
import 'package:nesticope_app/modules/contractor/controller/top_contractor_service_category_controller.dart';
import 'package:nesticope_app/modules/contractor/view/all_contractors_list_screen.dart';
import 'package:nesticope_app/modules/hire_contractor/controller/hire_contractor_filter_controller.dart';
import 'package:nesticope_app/modules/hire_contractor/view/widget/hire_contractor_profilelist.dart';
import 'package:nesticope_app/modules/home/controllers/top_builder_all_controller.dart';
import 'package:nesticope_app/modules/home/controllers/top_builder_controller.dart';
import 'package:nesticope_app/modules/home/widgets/contractor_profile_card.dart';
import 'package:nesticope_app/modules/home/widgets/home_header.dart';
import 'package:nesticope_app/modules/home/widgets/scroll_listiner_provider.dart';
import 'package:nesticope_app/modules/news/controllers/news_controller.dart';
import 'package:nesticope_app/modules/platform_service/controllers/platform_service_controller.dart';
import 'package:nesticope_app/modules/propert_detail/view/property_details.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/property/controllers/recommended_property_controller.dart';
import 'package:nesticope_app/modules/saved_property/controllers/property_favorite_controller.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';
import 'package:nesticope_app/modules/seller/view/widget/builder_list_top.dart';
import 'package:nesticope_app/modules/seller/view/widget/seller_list.dart';
import 'package:nesticope_app/utils/global.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nesticope_app/app/utils/helper_function/contact_helper.dart';
import 'package:nesticope_app/modules/home/controllers/contact_controller.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../app/manager/compare_manager.dart' show CompareManager;
import '../../../../app/widgets/mic_search/search_mic.dart';
import '../../../../app/widgets/shimmer/shimmer_widget.dart';
import '../../../../widgets/input/city_selection_widget.dart';
import '../../../history/controller/search_history_controller.dart';
import '../../../profile/controllers/buyer_profiledata.dart';
import '../../../property/controllers/share_property_controller.dart';
import '../../../search_property/controller/search_controller.dart';
import '../../../search_property/model/search_model.dart';
import '../../controllers/contractor_profile_controller/contractor_profile_controller.dart';
import '../../widgets/all_categories_section.dart';
import '../../widgets/all_news_&_articles_screen.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/display/card.dart';

// import '../../widgets/success_srory_detail_screen.dart';
import '../../widgets/partner_success_stories_detail_screen.dart';
import '../../widgets/top_categories_section.dart';
import '../../widgets/unified_comparison_floating_button.dart';
import '../../../../data/network/builder/model/builder_model.dart';
import '../../../../data/network/news/news_model.dart';
import '../../../../data/network/platform_review/model/platform_review_model.dart';
import '../../../builder/view/builder_property_listing.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import '../../views/all_builders_screen.dart';
import '../../../builder/view/project_detail/project_detail.dart';
import '../../../filter_property/controller/property_filter_controller.dart';
import '../../../news/view/news_detail_screen.dart';
import '../../../other/trending_city/controllers/trending_city_controller.dart';
import '../../../platform_service/views/widgets/platform_service_card.dart';
import '../../../property/views/widgets/city_filter.dart';
import '../../../property/views/widgets/top_property_card.dart';
import '../../../property/views/widgets/property_card.dart';
import '../../../top_seller/controller/top_seller_controller.dart';
import '../../controllers/home_controller/platform_review-controller.dart';
import 'package:nesticope_app/widgets/drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, String>> propertyTypes;

  const HomeScreen({
    super.key,
    this.propertyTypes = const [
      {"title": "Apartment", "image": IMGRes.apartment},
      {"title": "Villa", "image": IMGRes.villa},
      {"title": "Plot", "image": IMGRes.plot},
      {"title": "Office", "image": IMGRes.office},
      {"title": "Retail Shop", "image": IMGRes.retail},
      {"title": "Showroom", "image": IMGRes.showroom},
      {"title": "Warehouse", "image": IMGRes.warehouse},
    ],
  });

  // Static data
  static final List<String> images = [
    IMGRes.home1,
    IMGRes.home2,
    IMGRes.home3,
    IMGRes.home4,
  ];

  static final List<String> banners = [
    IMGRes.project_1,
    IMGRes.project_2,
    IMGRes.project_3,
    IMGRes.project_4,
    IMGRes.project_5,
    IMGRes.project_6,
    IMGRes.project_1,
  ];

  static final List<Map<String, dynamic>> shops = [
    {
      "image": IMGRes.shop1,
      "name": "Retail Space",
      "opacity": Color(0xFFFDF6E4),
    },
    {
      "image": IMGRes.shop2,
      "name": "Office Space",
      "opacity": Color(0xFFE4F4FD),
    },
    {"image": IMGRes.shop3, "name": "Land", "opacity": Color(0xFFE7FDE4)},
    {"image": IMGRes.shop4, "name": "Warehouses", "opacity": Color(0xFFEAE4FD)},
    {
      "image": IMGRes.shop1,
      "name": "Commercial Space",
      "opacity": Color(0xFFFDE4E4),
    },
  ];

  static final List<Map<String, dynamic>> furnishedType = [
    {"image": IMGRes.furnished, "name": "Fully Furnished"},
    {"image": IMGRes.semiFurnished, "name": "Semi Furnished"},
    {"image": IMGRes.unFurnished, "name": "Unfurnished"},
  ];

  static final List<Color> softColors = [
    Color(0xFFFDE4E4),
    Color(0xFFFDF6E4),
    Color(0xFFE4F4FD),
    Color(0xFFE7FDE4),
    Color(0xFFEAE4FD),
  ];

  static final List<String> plots = [IMGRes.plot1, IMGRes.plot2, IMGRes.plot3];

  static final List<Map<String, String>> bhk = [
    {"image": IMGRes.bhk1, "title": "1 BHK"},
    {"image": IMGRes.bhk2, "title": "2 BHK"},
    {"image": IMGRes.bhk3, "title": "3 BHK"},
    {"image": IMGRes.home1, "title": "4 BHK"},
    {"image": IMGRes.home2, "title": "5+ BHK"},
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers - Lazy initialization with Get.put and proper dependency management
  late final PropertyController propertyController;
  late final PropertyFavoriteController favoriteController;
  late final NewsController newsController;
  late final TrendingCityController trendingCityController;
  late final MicController micController;
  late final GoogleMapSearchController googleMapController;
  late final BuyerProfileDataController profileController;
  late final SharePropertyController propertyShareController;
  late final RecommendedPropertyController recommendedPropertyController;
  late final PropertyFilterControllerForFilter propertyFilterController;
  late final PlatformServicesController platformServicesController;
  late final TopContractorsController contractorServiceController;
  late final ProjectWizardController projectController;
  late final PlatformReviewController reviewController;
  late final TopSellerController topSellerController;
  late final TopBuilderController topBuilderController;
  late final CompareManager compareManager;
  late final HireContractorFilterProfileController ctrl;
  late final ContactController contactController;

  late final TopCategoryController topCategoryController;
  final searchHistoryController = Get.put(SearchHistoryController());
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  final ScrollController _scrollController = ScrollController();
  bool _showPinnedSearch = false;

  // final PinnedSearchNotifier _pinnedSearchNotifier = PinnedSearchNotifier();
  // Threshold to show pinned search (expandedHeight - collapsedHeight)
  static const double _headerCollapseOffset = 110.0;

  int selectedIndex = -1;

  // ✅ Store home-specific filter state locally
  String? _homePropertyTypeFilter;
  String? _homeListingTypeFilter;

  // ✅ Cache original data to avoid re-filtering from shared controller
  List<dynamic> _cachedNewlyAddedProperties = [];
  List<dynamic> _cachedTopProperties = [];
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupCityChangeListener();
    _getCity();
    _attachScroll(); // ✅ THIS

    // _scrollController.addListener(() {
    //   _pinnedSearchNotifier.update(
    //     _scrollController.offset >= _headerCollapseOffset,
    //   );
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initial = await SecureStorage.getHomeCategory();
      final selectedCategory = initial ?? 'Buy';
      final norm = selectedCategory.toLowerCase();
      setState(() {
        _homePropertyTypeFilter = null;
        _homeListingTypeFilter = null;
        if (norm.startsWith('buy')) {
          _homeListingTypeFilter = 'buy';
        } else if (norm.startsWith('rent')) {
          _homeListingTypeFilter = 'rent';
        } else if (norm.startsWith('pg')) {
          _homeListingTypeFilter = 'pg';
        } 
        else if (norm.startsWith('commercial')) {
          _homePropertyTypeFilter = 'commercial';
        } else if (norm.startsWith('plots')) {
          _homePropertyTypeFilter = 'plot';
        }
      });
      try {
        // Map UI selection to API listingType values
        String? listingType;
        final Map<String, String> f = {};
        if (norm.startsWith('buy'))
          listingType = 'Sell';
        else if (norm.startsWith('rent'))
          listingType = 'Rent';
        else if (norm.startsWith('pg'))
          listingType = 'PG';

        if (listingType != null) {
          propertyController.applyFilter('listingType', listingType);
          // propertyController.loadTopProperties();

          propertyController.loadTopProperties();
        } 
        // else {
        //   propertyController.clearFilter('listingType');
        // }

        if (norm.startsWith('commercial')) {
          // projectController.applyFilter('projectType', 'commercial');
          propertyController.applyFilter('type', 'commercial');
          // propertyController.loadTopProperties();

          propertyController.loadTopProperties();
    
        }
      } catch (_) {}

      if (selectedIndex == -1 && widget.propertyTypes.isNotEmpty) {
        _onPropertyTypeSelected(0, widget.propertyTypes[0]);
      }
      _loadInitialData();
    });
  }

  Future<void> _getCity() async {
    final city = await SecureStorage.getSelectedCity();

    if (city != null && propertyController.selectedCity.value.isEmpty) {
      propertyController.selectedCity.value = city;
      topBuilderController.selectedCity.value = city;
      projectController.selectedCity.value = city;

      selectedCity = city;
    }
  }

  bool lastPinned = false;

  void _attachScroll() {
    _scrollController.addListener(() {
      final pinned = _scrollController.offset >= _headerCollapseOffset;

      if (pinned != lastPinned) {
        lastPinned = pinned;
        context.read<PinnedSearchNotifier>().update(pinned);
      }
    });
  }

  void _initializeControllers() {
    // Initialize all controllers
    propertyController = Get.put(PropertyController());
    Get.lazyPut(() => PropertyFavoriteController());
    favoriteController = Get.find<PropertyFavoriteController>();
    newsController = Get.put(NewsController());
    trendingCityController = Get.put(TrendingCityController());
    micController = Get.put(MicController());
    googleMapController = Get.put(GoogleMapSearchController(), tag: 'city');
    profileController = Get.put(BuyerProfileDataController());
    propertyShareController = Get.put(SharePropertyController());
    recommendedPropertyController = Get.put(RecommendedPropertyController());
    propertyFilterController = Get.put(PropertyFilterControllerForFilter());
    platformServicesController = Get.put(PlatformServicesController());
    contractorServiceController = Get.put(TopContractorsController());
    projectController = Get.put(ProjectWizardController(isBuilderView: false));
    ctrl =
        Get.isRegistered<HireContractorFilterProfileController>()
            ? Get.find<HireContractorFilterProfileController>()
            : Get.put(HireContractorFilterProfileController());

    reviewController = Get.put(
      PlatformReviewController(type: ['site'], filters: {}),
    );
    topSellerController = Get.put(TopSellerController());
    topBuilderController = Get.put(TopBuilderController());
    compareManager = Get.put(CompareManager(), permanent: true);
    topCategoryController = Get.put(TopCategoryController());
    contactController = Get.put(ContactController());
  }

  void _setupCityChangeListener() {
    ever(propertyController.selectedCity, (city) {
      if (!mounted) return;
      setState(() {
        //    selectedCity = city; // ✅ sync local copy
        // selectedIndex = -1;
        selectedCity = city;
        selectedIndex = 0;
        _homePropertyTypeFilter = null;
        _homeListingTypeFilter = null;
        _cachedNewlyAddedProperties = [];
        _cachedTopProperties = [];
      });

      debugPrint("🔄 City synced to HomeScreen: $city");
      

      //=================================For ===================================

      if (widget.propertyTypes.isNotEmpty) {
        _onPropertyTypeSelected(0, widget.propertyTypes[0]);
      }

      //=====================================================================

      // 🔄 Refresh Top Categories for selected city
      try {
        topCategoryController.fetchTopCategories();
      } catch (_) {}
      // 🔄 Refresh Top Rated Contractors for selected city
      try {
        contractorServiceController.applyFilter('city', city ?? '');
      } catch (_) {}
      // 🔄 Refresh Top Builders for selected city
      try {
        topBuilderController.selectedCity.value = city ?? '';
        topBuilderController.refreshList();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // SliverAppBar(
                //   pinned: true,
                //   snap: false,
                //   floating: false,
                //   expandedHeight: 110.0,

                //   titleSpacing: 0,
                //   backgroundColor:
                //       _showPinnedSearch ? ColorRes.primary : Colors.transparent,
                //   surfaceTintColor:
                //       _showPinnedSearch ? ColorRes.primary : Colors.transparent,
                //   shadowColor: Colors.black26,
                //   elevation: 2,
                //   forceElevated: true,
                //   clipBehavior: Clip.none,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.vertical(
                //       bottom: Radius.circular(20),
                //     ),
                //   ),
                //   automaticallyImplyLeading: false,
                //   flexibleSpace: FlexibleSpaceBar(
                //     collapseMode: CollapseMode.pin,
                //     background:
                //         _showPinnedSearch
                //             ? null
                //             : ColoredBox(
                //               color: Colors.transparent,
                //               child: _showPinnedSearch ? null : _buildHeader(),
                //             ),
                //   ),
                //   bottom:
                //       _showPinnedSearch
                //           ? PreferredSize(
                //             preferredSize: const Size.fromHeight(30),
                //             child: Container(
                //               height: 70,

                //               decoration: BoxDecoration(
                //                 color: ColorRes.primary,
                //                 borderRadius: BorderRadius.only(
                //                   bottomLeft: Radius.circular(24),
                //                   bottomRight: Radius.circular(24),
                //                 ),
                //               ),
                //               padding: const EdgeInsets.only(
                //                 left: 12,
                //                 right: 12,
                //                 top: 8,
                //                 bottom:
                //                     10, // ✅ more bottom padding = more blue visible
                //               ),
                //               child: SizedBox(
                //                 height: 48,
                //                 child: Obx(
                //                   () => buildPositionedTextField(
                //                     propertyController,
                //                     context,
                //                     () async {
                //                       final filter = await Get.to(
                //                         () => CommonSearchField(
                //                           isNavigate: true,

                //                           onTap: (city) {
                //                             final filters = {
                //                               "city": city.split(",").first,
                //                             };
                //                             propertyController.fetchTradingArea(
                //                               filters['city'] ?? '',
                //                             );
                //                             Get.back(result: filters);
                //                           },
                //                         ),
                //                       );
                //                       if (filter != null &&
                //                           filter is Map &&
                //                           filter['city'] != null) {
                //                         final String city = filter['city'];

                //                         // Apply city filter to home (Yes case)
                //                         await SecureStorage.saveSelectedCity(
                //                           city,
                //                         );
                //                         propertyController.fetchTradingArea(
                //                           city,
                //                         );
                //                         topBuilderController.applyFilter(
                //                           'city',
                //                           city,
                //                         );

                //                         propertyController.applyFilter(
                //                           'city',
                //                           city,
                //                         );
                //                         projectController.applyFilter(
                //                           'city',
                //                           city,
                //                         );
                //                         // Reload top properties for the new city
                //                         await propertyController
                //                             .loadTopProperties();
                //                         await projectController
                //                             .loadTopProject();
                //                         await topBuilderController
                //                             .loadInitial();

                //                         // Navigate to PropertyDetail in both cases (Yes and No)
                //                       }
                //                     },
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )
                //           : null,
                Selector<PinnedSearchNotifier, bool>(
                  selector: (_, notifier) => notifier.show,
                  builder: (context, show, _) {
                    return SliverAppBar(
                      pinned: true,
                      snap: false,
                      floating: false,
                      expandedHeight: 110.0,

                      titleSpacing: 0,
                      backgroundColor:
                          show ? ColorRes.primary : Colors.transparent,
                      surfaceTintColor:
                          show ? ColorRes.primary : Colors.transparent,
                      shadowColor: Colors.black26,
                      elevation: 2,
                      forceElevated: true,
                      clipBehavior: Clip.none,
                      automaticallyImplyLeading: false,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        // ✅ _buildHeader() only called when show == false
                        background:
                            show
                                ? null
                                : ColoredBox(
                                  color: Colors.transparent,
                                  child: _buildHeader(),
                                ),
                      ),
                      bottom:
                          show
                              ? PreferredSize(
                                preferredSize: const Size.fromHeight(30),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: ColorRes.primary,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24),
                                    ),
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: 8,
                                    bottom: 10,
                                  ),
                                  child: SizedBox(
                                    height: 48,
                                    child: Obx(
                                      () => buildPositionedTextField(
                                        propertyController,
                                        context,
                                        () async {
                                          final filter = await Get.to(
                                            () => CommonSearchField(
                                              isNavigate: true,
                                              onTap: (city) {
                                                final filters = {
                                                  "city": city.split(",").first,
                                                };
                                                propertyController
                                                    .fetchTradingArea(
                                                      filters['city'] ?? '',
                                                    );
                                                Get.back(result: filters);
                                              },
                                            ),
                                          );
                                          if (filter != null &&
                                              filter is Map &&
                                              filter['city'] != null) {
                                            final String city = filter['city'];
                                            await SecureStorage.saveSelectedCity(
                                              city,
                                            );
                                            propertyController.fetchTradingArea(
                                              city,
                                            );
                                            topBuilderController.applyFilter(
                                              'city',
                                              city,
                                            );
                                            propertyController.applyFilter(
                                              'city',
                                              city,
                                            );
                                            projectController.applyFilter(
                                              'city',
                                              city,
                                            );
                                            await propertyController
                                                .loadTopProperties();
                                            await projectController
                                                .loadTopProject();
                                            await topBuilderController
                                                .loadInitial();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : null,
                    );
                  },
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // const SizedBox(height: 12),
                      _buildContent(),
                      _buildFindPropertyButton(),
                    ],
                  ),
                ),
              ],
            ),
            const UnifiedComparisonFloatingButton(bottom: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _loadInitialData() async {
    try {
      final user = await SecureStorage.getUserData();
      debugPrint("User Data: ${user?.toJson()}");

      if (user?.user?.id != null) {
        await Future.wait([
          favoriteController.getFavorite(user?.user?.id ?? ''),
          propertyController.getRecommendedPropertyByUserId(
            user?.user?.id ?? '',
          ),
          profileController.getUserProfile(),
        ]);
      }

      log("home city ${propertyController.selectedCity.value}");
      propertyController.fetchTradingArea(
        propertyController.selectedCity.value,
      );
      topBuilderController.selectedCity.value;
      projectController.cityAssign(propertyController.selectedCity.value);
      // ✅ Load top categories for the initial city
      topCategoryController.fetchTopCategories();
      // ✅ Load top contractors for the initial city
      if ((propertyController.selectedCity.value).isNotEmpty) {
        contractorServiceController.applyFilter(
          'city',
          propertyController.selectedCity.value,
        );
      }

      // ✅ Cache the unfiltered data when first loaded
      _cacheOriginalData();
    } catch (e) {
      debugPrint("Error loading initial data: $e");
    }
  }

  // ✅ Cache original unfiltered data
  void _cacheOriginalData() {
    if (_cachedNewlyAddedProperties.isEmpty &&
        propertyController.items.isNotEmpty) {
      _cachedNewlyAddedProperties = List.from(propertyController.items.value);
    }
    if (_cachedTopProperties.isEmpty &&
        propertyController.topProperties.isNotEmpty) {
      _cachedTopProperties = List.from(propertyController.topProperties);
    }
  }

  // ✅ Get filtered data based on home-specific filters only
  List<dynamic> _getFilteredProperties(RxList<Items> baseList) {
    if (_homePropertyTypeFilter == null && _homeListingTypeFilter == null) {
      return baseList;
    }

    final filtered =
        baseList.where((property) {
          bool matchesPropertyType = true;
          bool matchesListingType = true;

          if (_homePropertyTypeFilter != null) {
            final propertyType = property.propertyType
                ?.toString()
                .toLowerCase()
                .replaceAll(" ", "_");
            matchesPropertyType = propertyType == _homePropertyTypeFilter;
          }

          if (_homeListingTypeFilter != null) {
            final listingType = property.listingType
                ?.toString()
                .toLowerCase()
                .replaceAll(" ", "_");
            matchesListingType = listingType == _homeListingTypeFilter;
          }

          return matchesPropertyType && matchesListingType;
        }).toList();

    // Fallback: if filters yield empty, show unfiltered list
    return filtered.isNotEmpty ? filtered : baseList;
  }

  Widget _buildHeader() {
    return Obx(
      () => HomeHeader(
        image: profileController.userProfile.value?.profilePic ?? '',
        onCityChanged: (city) {
          selectedCity = city;
        },
        onCategoryChanged: (category, {bool fromUser = false}) {
          final norm = category.toLowerCase();
          setState(() {
            _homePropertyTypeFilter = null;
            _homeListingTypeFilter = null;
            if (norm.startsWith('buy')) {
              _homeListingTypeFilter = 'buy';
            } else if (norm.startsWith('rent')) {
              _homeListingTypeFilter = 'rent';
            } else if (norm.startsWith('pg')) {
              _homeListingTypeFilter = 'pg';
            } else if (norm.startsWith('commercial')) {
              _homePropertyTypeFilter = 'commercial';
            // } else if (norm.startsWith('plots')) {
            //   _homePropertyTypeFilter = 'plot';
            // }
            }
          });
          try {
            // Map UI selection to API listingType values
            String? listingType;
            final Map<String, String> f = {};
            if (norm.startsWith('buy'))
              listingType = 'Sell';
            else if (norm.startsWith('rent'))
              listingType = 'Rent';
            else if (norm.startsWith('pg'))
              listingType = 'PG';

            if (listingType != null) {
              propertyController.applyFilter('listingType', listingType);
              // propertyController.loadTopProperties();
              if (fromUser) {
                propertyController.loadTopProperties();
              }
            // } else {
            //   propertyController.clearFilter('listingType');
            // }
            }

            if (norm.startsWith('commercial')) {
              // projectController.applyFilter('projectType', 'commercial');
              propertyController.applyFilter('type', 'commercial');
              // propertyController.loadTopProperties();
              if (fromUser) {
                propertyController.loadTopProperties();
              }
            // } else if (norm.startsWith('plots')) {
            //   propertyController.applyFilter('propertyType', 'plot');
            //   // propertyController.loadTopProperties();
            //   if (fromUser) {
            //     propertyController.loadTopProperties();
            //   }
            //   // projectController.applyFilter('projectType', '');
            // } else {
            //   propertyController.clearFilter('propertyType');
            //   // projectController.applyFilter('projectType', '');
            // }
            }
          } catch (_) {}
        },
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: 10),
        _buildPropertyTypeSelector(),
        const SizedBox(height: 15),

        // Divider(

        //   thickness: 0.5,
        //   color: ColorRes.divider,
        // ),
        _buildNewlyAddedProperties(),

        _buildRecommendedProperties(),
        _buildCitySection(),
        _buildExploreProjects(),

        // const SizedBox(height: 15),
        _buildFurnishingTypeSection(),
        // const SizedBox(height: 5),
        _buildTopProperties(),
        _buildTopProjectsInCity(),
        // _buildRecommendedSellers(),
        _buildRecommendedBuilders(),
        _buildTopContractors(),
        _buildTopCategories(),
        _buildLimitedOfferCard(),

        _buildPlatformServices(),
        _buildNewsAndArticles(),
        _resellerSuccessStories(),
        // const SizedBox(height: 15),
        // _buildWhyChooseUs(),
        // _buildReviewsAndTestimonials(),
        // _buildHomeProcessSteps(),
        // const SizedBox(height: 12),
      ],
    );
  }

  Widget _resellerSuccessStories() {
    return Obx(() {
      if (searchHistoryController.isLoading.value &&
          searchHistoryController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 15),
            const TitleWithViewAll(
              title: "Our Partners' Achievements",
              showViewAll: false,
            ),
            const SizedBox(height: 6),
            const ContractorCardShimmer(),
          ],
        );
      }

      if (searchHistoryController.items.isEmpty) {
        //ncj njdbsndkn
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        // margin: EdgeInsets.symmetric(vertical: 20),
        color: Color.fromARGB(255, 253, 247, 240),
        child: Column(
          children: [
            TitleWithViewAll(
              title: "Our Partners' Achievements",
              showViewAll: false,
              showIcon: true,
              icon: Icons.star_border,
              iconColor: ColorRes.orangeColor,
              iconBgColor: ColorRes.orangeColor.withOpacity(0.3),
              subTitle: "Our Partners' Success Stories",

              // subTitleColor: ColorRes.,
              // subTitleFontSize: AppFontSizes.bodyMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                scrollDirection: Axis.horizontal,
                itemCount: searchHistoryController.items.length,
                itemBuilder: (context, index) {
                  final data = searchHistoryController.items[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ResellerSuccessDetailScreen(successStory: data),
                      );
                      /*  Get.defaultDialog(
                        title: "",
                        contentPadding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        radius: 16,
                        content: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height *
                                0.75, // max 75% of screen height
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Optional: Image at top
                                if (data.image != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      data.image!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (data.image != null)
                                  const SizedBox(height: 16),
        
                                // Title
                                Text(
                                  data.title ?? "No Title",
                                  style: TextStyle(
                                    fontSize: AppFontSizes.body,
                                    fontWeight: AppFontWeights.semiBold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
        
                                // Achievement with background
                                if (data.achievement != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      // Light background color
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      data.achievement!,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.bodySmall,
                                        fontWeight: AppFontWeights.medium,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
        
                                // Description with background
                                if (data.description != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      // Light grey background
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      data.description!,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.bodySmall,
                                        fontWeight: AppFontWeights.medium,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
        
                                // Additional info
                                if (data.createdAt != null)
                                  Text(
                                    "Created at: ${Formatter.formatDate(data.createdAt!.toIso8601String())}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorRes.leadGreyColor.shade600,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorRes.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                "Close",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );*/
                    },
                    child: Container(
                      width: 240,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 2,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🖼 Small image + title row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  data.image ?? '',
                                  height: 38,
                                  width: 38,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Container(
                                        height: 38,
                                        width: 38,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.person,
                                          size: 20,
                                        ),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  data.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // 📄 Description
                          Text(
                            '${data.description}' ?? '',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // 🏷 Achievement tag
                          /*         Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${data.achievement}' ?? 'Achievement',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),*/
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data.totalDeals ?? 0}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "TOTAL DEALS",
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: ColorRes.leadGreyColor.shade600,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${Formatter.formatPrice(num.tryParse(data.totalValue ?? '0') ?? 0)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "TOTAL VALUE",
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: ColorRes.leadGreyColor.shade600,
                                      fontWeight: AppFontWeights.medium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // ⭐ Rating
                          Row(
                            children: [
                              ...List.generate(
                                5,
                                (star) => Icon(
                                  Icons.star,
                                  size: 14,
                                  color:
                                      star < (data.rating ?? 0)
                                          ? Colors.blueAccent
                                          : Colors.grey.shade300,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                data.updatedAt != null
                                    ? "Updated: ${DateFormat('yyyy-MM-dd').format(data.updatedAt!)}"
                                    : '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildPropertyTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.propertyTypes.length,
          (index) => _buildPropertyTypeItem(index),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeItem(int index) {
    final type = widget.propertyTypes[index];
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onPropertyTypeSelected(index, type),
      child: Container(
        margin: EdgeInsets.only(
          left: index == 0 ? 16 : 8,
          right: index == widget.propertyTypes.length - 1 ? 16 : 0,
        ),
        child: _buildPropertyTypeLabel(type, isSelected),
      ),
    );
  }

  Widget _buildPropertyTypeIcon(Map<String, String> type, bool isSelected) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ClipOval(
          child: Image.asset(type['image'] ?? '', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeLabel(Map<String, String> type, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? ColorRes.primary : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? ColorRes.primary : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: ColorRes.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: Text(
        type['title'] ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? AppFontWeights.semiBold : FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey.shade700,
        ),
      ),
    );
  }

  // ✅ Updated to apply filters locally only
  void _onPropertyTypeSelected(int index, Map<String, String> type) {
    final filterValue = type['title']!.toLowerCase().replaceAll(" ", "_");
    // final filterKey = (filterValue == "pg") ? "listingType" : "propertyTypes";
    final filterKey = "propertyType";
    // ✅ Only apply filters to home screen state, not to shared controller
    setState(() {
      selectedIndex = index;

      // if (filterKey == "listingType") {
      //   _homeListingTypeFilter = filterValue;

      //   _homePropertyTypeFilter = null;
      // } else {
      //   _homePropertyTypeFilter = filterValue;
      //   _homeListingTypeFilter = null;
      // }
    });

    // ✅ Pass normalized selection as subProperty in API query (distinct from header logic)
    try {
      propertyController.subPropertyType.value = filterValue;
      propertyController.applyFilter('propertyType', filterValue);
    } catch (_) {}

    debugPrint("Selected: ${type['title']} (Home filter only)");
  }

  // Widget _buildNewlyAddedProperties() {
  //   return Obx(() {

  //     log("Newly added properties: ${propertyController.items.value.map((e) => e.city).toList()}");
  //     // ✅ Cache data when it loads
  //     if (propertyController.items.isNotEmpty &&
  //         _cachedNewlyAddedProperties.isEmpty) {
  //       _cachedNewlyAddedProperties = List.from(propertyController.items.value);
  //     }

  //     if (propertyController.isLoading.value &&
  //         _cachedNewlyAddedProperties.isEmpty) {
  //       return Column(
  //         children: [
  //           const SizedBox(height: 12),
  //           TitleWithViewAll(
  //             title: "Newly added properties",
  //             showViewAll: false,
  //           ),
  //           const SizedBox(height: 12),
  //           const HorizontalPropertyListShimmer(),
  //         ],
  //       );
  //     }

  //     // ✅ Use cached data and apply home-specific filters
  //     final activeProperties =
  //         _getFilteredProperties(
  //           _cachedNewlyAddedProperties,
  //         ).where((e) => e.approvalStatus == "approved").toList();

  //     if (propertyController.isRefreshing.value) {
  //       return const HorizontalPropertyListShimmer();
  //     }

  //     if (activeProperties.isEmpty) {
  //       return const SizedBox.shrink();
  //     }

  //     return Column(
  //       children: [
  //         TitleWithViewAll(
  //           title: "Newly added properties",
  //           showViewAll: true,
  //           onViewAll: () {
  //             if (selectedCity == null) {
  //               Get.to(() => PropertyDetail());
  //             } else {
  //               Get.to(
  //                 () => PropertyDetail(
  //                   filters: [
  //                     {'city': selectedCity!},
  //                   ],
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //         const SizedBox(height: 12),

  //         _buildHorizontalPropertyList(activeProperties),
  //       ],
  //     );
  //   });
  // }
  Widget _buildNewlyAddedProperties() {
    return Obx(() {
      log(
        "Newly added properties: ${propertyController.items.map((e) => e.toJson()).toList()}",
      );

      // 🔄 Loading state
      if (propertyController.isLoading.value &&
          propertyController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: "Newly added properties",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const HorizontalPropertyListShimmer(),
          ],
        );
      }

      // 🔄 Refreshing state
      if (propertyController.isRefreshing.value) {
        return const HorizontalPropertyListShimmer();
      }

      // ✅ Direct controller data (NO cache, NO approved filter)
      final activeProperties = _getFilteredProperties(propertyController.items);

      // ❌ Empty state
      if (activeProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        // margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color.fromARGB(255, 77, 77, 77).withOpacity(0.05),
        // height: 64,
        child: Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: "Newly added properties",
              showViewAll: true,
              onViewAll: () {
                if (selectedCity == null) {
                  Get.to(() => PropertyDetail());
                } else {
                  Get.to(
                    () => PropertyDetail(
                      filters: [
                        {'city': selectedCity!},
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),

            _buildHorizontalPropertyList(activeProperties),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildRecommendedProperties() {
    return Obx(() {
      if (propertyController.apiLoading.value &&
          propertyController.recommendedProperties.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const TitleWithViewAll(title: "Recommended Properties"),
            const SizedBox(height: 10),
            const HorizontalPropertyListShimmer(),
          ],
        );
      }

      if (propertyController.recommendedProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: const Color.fromARGB(255, 77, 77, 77).withOpacity(0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const TitleWithViewAll(title: "Recommended Properties"),
            const SizedBox(height: 12),
            _buildHorizontalPropertyList(
              propertyController.recommendedProperties,
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _buildHorizontalPropertyList(List<dynamic> properties) {
    print("_buildHorizontalPropertyList called ${properties.length}");
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SizedBox(
        height: 310,

        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge && metrics.pixels != 0) {
              propertyController.loadMore();
            }
            return false;
          },
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,

            // padding: const EdgeInsets.,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final data = properties[index];
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: PropertyCard(property: data),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCitySection() {
    return Obx(() {
      if (trendingCityController.isLoading.value &&
          trendingCityController.allTrendingCities.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 15),
            TitleWithViewAll(
              title: "Top Cities to Explore",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const CityFilterListShimmer(),
          ],
        );
      }

      if (trendingCityController.allTrendingCities.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        // margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: ColorRes.primary.withOpacity(0.1),

        // height: 64,
        child: Column(
          children: [
            const SizedBox(height: 15),
            TitleWithViewAll(
              title: "Top Cities to Explore",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const CityFilterList(),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _buildExploreProjects() {
    return Obx(() {
      if (projectController.isLoading.value &&
          projectController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title:
                  "Builder Projects in ${projectController.selectedCity ?? ''}",

              showViewAll: false,
              subTitle: 'Discover new projects in your city!',
            ),
            const SizedBox(height: 12),
            const ProjectListShimmer(),
          ],
        );
      } //HDYJSB jduwj jdbb    bch

      final activeProjects =
          projectController.items
              .where(
                (element) =>
                    element.approvalStatus == "approved" &&
                    element.isVerified.toString() == "true",
              )
              .toList();

      if (activeProjects.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        // margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: ColorRes.homeYellow.withOpacity(0.05),

        // height: 64,
        child: Column(
          children: [
            const SizedBox(height: 12),

            TitleWithViewAll(
              title:
                  "Builder Projects in ${projectController.selectedCity ?? ''}",
              showViewAll: true,
              isSubTitle: true,
              subTitle: 'Discover new projects in your city',
              onViewAll: () {
                if (projectController.selectedCity == null) {
                  Get.to(() => AllProjectListScreen());
                } else {
                  Get.to(
                    () => AllProjectListScreen(
                      // filters: [
                      //   {'city': selectedCity!},
                      // ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            _buildProjectList(activeProjects),
            const SizedBox(height: 15),
          ],
        ),
      );
    });
  }

  Widget _buildProjectList(List<ProjectItem> projects) {
    return SizedBox(
      height: 290,

      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final data = projects[index];
          return GestureDetector(
            onTap: () => Get.to(() => ProjectDetailsScreen(projectItem: data)),
            child: BuilderProjectCard(
              forHome: true,
              project: data,
              width: MediaQuery.of(context).size.width * 0.85,

              height: 150,
              developersName: data.projectContactInfo?.name ?? 'Unknown',
              imageUrl:
                  (data.mediaGallery?.images?.isNotEmpty ?? false)
                      ? data.mediaGallery!.images.first
                      : IMGRes.home3,
              projectName:
                  data.projectName.isNotEmpty ? data.projectName : 'N/A',
              location:
                  data.address.isNotEmpty ? data.address : 'Not specified',
              price: data.getPriceRange(),
              propertySize: data.projectSize?.totalBuildings?.toString() ?? '—',
            ),
          );
        },
      ),
    );
  }

  Widget _buildFurnishingTypeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: ColorRes.primary.withOpacity(0.06),
      child: Column(
        children: [
          SizedBox(height: 15),
          const TitleWithViewAll(title: "Explore by furnishing type"),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: List.generate(
                  HomeScreen.furnishedType.length,
                  (index) => _buildFurnishingTypeCard(index),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildFurnishingTypeCard(int index) {
    final furnished = HomeScreen.furnishedType[index];
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => _onFurnishingTypeSelected(furnished),
        child: NesticoPeCardWithText(
          height: 120,
          width: 200,

          imageUrl: furnished["image"]!,
          title: furnished["name"]!,
          opacity: ColorRes.black,
        ),
      ),
    );
  }

  void _onFurnishingTypeSelected(Map<String, dynamic> furnished) {
    setState(() {
      if (furnished['name'] == 'Fully Furnished') {
        propertyFilterController.rentFurnishing.value = 'fully-furnished';
      } else if (furnished['name'] == 'Semi Furnished') {
        propertyFilterController.rentFurnishing.value = 'semi-furnished';
      } else if (furnished['name'] == "Unfurnished") {
        propertyFilterController.rentFurnishing.value = 'unfurnished';
      }

      Get.to(
        () => PropertyDetail(
          filters: [
            {'furnish_type': propertyFilterController.rentFurnishing.value},
          ],
        ),
      );
    });
  }

  // Widget _buildTopProperties() {
  //   return Obx(() {
  //     // ✅ Cache data when it loads
  //     if (propertyController.topProperties.isNotEmpty &&
  //         _cachedTopProperties.isEmpty) {
  //       _cachedTopProperties = List.from(propertyController.topProperties);
  //     }

  //     if (propertyController.isLoading.value && _cachedTopProperties.isEmpty) {
  //       return Column(
  //         children: [
  //           const SizedBox(height: 12),
  //           TitleWithViewAll(
  //             title:
  //                 "Top Properties in ${propertyController.selectedCity.value}",
  //             showViewAll: false,
  //           ),
  //           const SizedBox(height: 12),
  //           const HorizontalPropertyListShimmer(),
  //         ],
  //       );
  //     }
  //     //ndhjcjunjsijwbkdihj hkdiehnnknndn jdi
  //     // ✅ Use cached data and apply home-specific filters
  //     final activeTopProperties =
  //         _getFilteredProperties(
  //           _cachedTopProperties,
  //         ).where((element) => element.approvalStatus == "approved").toList();

  //     if (activeTopProperties.isEmpty) {
  //       return const SizedBox.shrink();
  //     }

  //     return Column(
  //       children: [
  //         const SizedBox(height: 12),
  //         TitleWithViewAll(
  //           title: "Top Properties in ${propertyController.selectedCity.value}",
  //           showViewAll: true,
  //           onViewAll: () => Get.to(() => PropertyDetail()),
  //         ),
  //         const SizedBox(height: 12),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12),
  //           child: SizedBox(
  //             height: 310,
  //             child: ListView.separated(
  //               scrollDirection: Axis.horizontal,
  //               itemCount: activeTopProperties.length,
  //               separatorBuilder: (_, __) => const SizedBox(width: 12),
  //               itemBuilder: (context, index) {
  //                 final data = activeTopProperties[index];
  //                 return MediaQuery(
  //                   data: MediaQuery.of(
  //                     context,
  //                   ).copyWith(textScaler: const TextScaler.linear(1.0)),
  //                   child: TopPropertyCard(property: data),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     );
  //   });
  // }
  Widget _buildTopProperties() {
    return Obx(() {
      // 🔄 Loading state
      if (propertyController.isLoading.value &&
          propertyController.topProperties.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title:
                  "Top Properties in ${propertyController.selectedCity.value}",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const HorizontalPropertyListShimmer(),
          ],
        );
      }

      // ✅ Direct controller data (NO cache, NO approved filter)
      final activeTopProperties = _getFilteredProperties(
        propertyController.topProperties,
      );

      // ❌ Empty state
      if (activeTopProperties.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        // margin: EdgeInsets.symmetric(vertical: 20),
        color: Color.fromARGB(255, 252, 245, 237),

        child: Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title:
                  "Top Properties in ${propertyController.selectedCity.value}",
              showViewAll: true,
              onViewAll: () => Get.to(() => PropertyDetail()),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 310,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: activeTopProperties.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final data = activeTopProperties[index];
                    return MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: TopPropertyCard(property: data),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildTopProjectsInCity() {
    return Obx(() {
      if (projectController.isLoading.value &&
          projectController.topProjects.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: "Top Project in ${projectController.selectedCity.value}",
              showViewAll: false,
            ),
            const SizedBox(height: 12),
            const ProjectListShimmer(),
          ],
        );
      }

      final activeTopProjects =
          projectController.topProjects
              .where((element) => element.approvalStatus == "approved")
              .toList();

      if (activeTopProjects.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        // margin: EdgeInsets.symmetric(vertical: 20),
        color: Color.fromARGB(255, 251, 253, 240),

        child: Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: "Top Project in ${projectController.selectedCity.value}",
              showViewAll: true,
              onViewAll:
                  () => Get.to(
                    () => AllProjectListScreen(
                      isFromSeeAll: true,
                      isbuilder: false,
                      filters: [
                        {'city': projectController.selectedCity.value},
                      ],
                    ),
                  ),
            ),
            const SizedBox(height: 12),
            _buildProjectList(activeTopProjects),
          ],
        ),
      );
    });
  }

  Widget _buildRecommendedSellers() {
    return Obx(() {
      if (topSellerController.isLoading.value &&
          topSellerController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 15),
            const TitleWithViewAll(title: "Recommended Sellers"),
            const SizedBox(height: 12),
            const BuilderListShimmer(),
          ],
        );
      }

      if (topSellerController.items.isEmpty) {
        return const SizedBox.shrink();
      }
      print(
        "[TopSeller] topSeller : ${topSellerController.items.map((e) => e.toJson())}",
      );
      return Column(
        children: [
          const SizedBox(height: 15),
          const TitleWithViewAll(title: "Recommended Sellers"),
          const SizedBox(height: 12),
          SellerListWidget(topSeller: topSellerController.items),
        ],
      );
    });
  }

  Widget _buildRecommendedBuilders() {
    return Obx(() {
      if (topBuilderController.isLoading.value &&
          topBuilderController.items.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Color(0xffFAF9F8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              TitleWithViewAll(
                title:
                    "Top Developer in ${projectController.selectedCity.value}",
                showViewAll: false,
                subTitle: 'Connect with top developers',
                isSubTitle: true,
                icon: Icons.person_outline_outlined,
                iconColor: ColorRes.homeYellow,
                iconBgColor: ColorRes.homeYellow.withOpacity(0.1),
                showIcon: true,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 310,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return const SizedBox(
                      width: 250,
                      child: BuilderCardShimmer(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }

      if (topBuilderController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      final builders = topBuilderController.items.take(3).toList();

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Color(0xffFAF9F8),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: "Top Developer in ${projectController.selectedCity.value}",
              showViewAll: true,
              subTitle: 'Connect with top developers',
              isSubTitle: true,
              icon: Icons.person_outline_outlined,
              iconColor: ColorRes.builderGridLightYellow,
              iconBgColor: ColorRes.builderGridLightYellow.withOpacity(0.1),
              showIcon: true,
              onViewAll: () => Get.to(() => AllBuildersScreen()),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 310,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: builders.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final builder = builders[index];
                  return SizedBox(
                    width: 250,
                    child: BuilderCard(builder: builder),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildTopContractors() {
    return Obx(() {
      if (contractorServiceController.isLoading.value &&
          contractorServiceController.items.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: Color(0xffF0F3FF),
          child: Column(
            children: [
              const SizedBox(height: 12),

              TitleWithViewAll(
                title: "Top Rated Contractors",
                showViewAll: true,
                onViewAll: () => Get.to(() => const AllContractorsListScreen()),
              ),
              const SizedBox(height: 6),
              const ContractorCardShimmer(),
            ],
          ),
        );
      }

      if (contractorServiceController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Color(0xffF0F3FF),
        child: Column(
          children: [
            const SizedBox(height: 12),
            TitleWithViewAll(
              title: "Top Rated Contractors",
              subTitle: 'Connect with top contractors',
              isSubTitle: true,
              icon: Icons.home_repair_service_outlined,
              iconColor: ColorRes.lightPurpleColor,
              iconBgColor: ColorRes.lightPurpleColor.withOpacity(0.1),
              showIcon: true,
              showViewAll: true,
              onViewAll: () => Get.to(() => const AllContractorsListScreen()),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 338,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                scrollDirection: Axis.horizontal,
                itemCount: contractorServiceController.items.length,
                itemBuilder: (context, index) {
                  final data = contractorServiceController.items[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ContractorCard(contractor: data),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildTopCategories() {
    return Obx(() {
      if (topCategoryController.isLoading.value &&
          topCategoryController.categories.isEmpty) {
        return Column(
          children: [
            SizedBox(height: 15),

            TitleWithViewAll(
              title: "NesticoPe Verified Services",
              showViewAll: true,
            ),
            SizedBox(height: 8),

            TopCategoriesShimmer(),
          ],
        );
      }

      if (topCategoryController.categories.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),

        // margin:  EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: ColorRes.success.withOpacity(0.05),

          // borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SizedBox(height: 15),

            TitleWithViewAll(
              title: "NesticoPe Verified Services",
              showViewAll: true,
              icon: Icons.verified_user_outlined,
              iconColor: ColorRes.success,
              iconBgColor: ColorRes.success.withOpacity(0.1),
              showIcon: true,
              subTitle: 'View all verified services',
              isSubTitle: true,
              onViewAll:
                  () => Get.to(
                    () => AllCategoriesSection(
                      categories: topCategoryController.categories ?? [],
                    ),
                  ),
            ),

            TopCategoriesSection(categories: topCategoryController.categories),
            SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildLimitedOfferCard() {
    return Obx(() {
      String norm(String s) => s
          .trim()
          .toLowerCase()
          .replaceAll('&', 'and')
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
      final isLoading = topCategoryController.isLoading.value;
      final categories = topCategoryController.categories ?? const [];
      if (isLoading && categories.isEmpty) {
        return const SizedBox.shrink();
      }
      if (categories.isEmpty) {
        return const SizedBox.shrink();
      }

      IconData iconFor(TopCategoryItem c) {
        final n = norm(c.name ?? '');
        switch (n) {
          case 'building_material_supply':
          case 'material_supply':
            return Icons.local_shipping_rounded;
          case 'home_construction':
          case 'construction':
            return Icons.construction_rounded;
          case 'painting':
            return Icons.format_paint_rounded;
          case 'plumbing':
            return Icons.plumbing_rounded;
          case 'electrical':
            return Icons.electric_bolt_rounded;
          case 'cleaning':
            return Icons.cleaning_services_rounded;
          case 'interior_design':
            return Icons.chair_alt_rounded;
          case 'packers_and_movers':
          case 'packers_movers':
            return Icons.electric_moped_outlined;
          case 'home_services':
            return Icons.home_repair_service_rounded;
          case 'legal_services':
            return Icons.gavel_outlined;
          default:
            return Icons.home_repair_service_rounded;
        }
      }

      String getChipText(String name) {
        final n = name
            .toLowerCase()
            .replaceAll('&', 'and')
            .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

        switch (n) {
          case 'painting':
            return 'Hire Painter';

          case 'plumbing':
            return 'Book Plumber';

          case 'electrical':
            return 'Hire Electrician';

          case 'cleaning':
            return 'Book Cleaning';

          case 'interior_design':
            return 'Get Interior Designer';

          case 'home_construction':
          case 'construction':
            return 'Start Construction';

          case 'building_material_supply':
          case 'material_supply':
            return 'Order Materials';

          case 'packers_and_movers':
          case 'packers_movers':
            return 'Book Movers';

          case 'legal_services':
            return 'Get Legal Help';

          case 'home_services':
            return 'Book Service';

          default:
            return 'Hire ${name.split(' ').first}';
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          height: 280,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final TopCategoryItem item = categories[index];
              final String title =
                  (item.name ?? '')
                      .toString()
                      .replaceAll('_', ' ')
                      .capitalize ??
                  'Service';
              final List<String> features =
                  (item.description)
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .take(4)
                      .toList();
              final chipText = getChipText(item.name ?? '');

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: NesticoPeCard(
                  width: double.infinity,
                  color: ColorRes.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],

                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Opacity(
                            opacity: 0.15,
                            child: Icon(
                              iconFor(item),
                              size: 120,
                              color: ColorRes.primary,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  chipText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFontSizes.caption,
                                    fontWeight: AppFontWeights.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: AppFontSizes.large,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  features
                                      .map(
                                        (f) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                size: 15,
                                                color: ColorRes.primary,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  f,
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppFontSizes.caption,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                    color:
                                                        ColorRes
                                                            .leadGreyColor
                                                            .shade700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: NesticoPeButton(
                                    title: 'Book Now',
                                    onTap: () {
                                      try {
                                        final ctrl = Get.put(
                                          HireContractorFilterProfileController(),
                                        );
                                        final String categoryId =
                                            (item.id ?? '').toString();
                                        final String categoryName =
                                            (item.name ?? 'Service').toString();
                                        ctrl.selectedCategoryId.value =
                                            categoryId;
                                        ctrl.selectedCategoryName.value =
                                            categoryName;
                                        ctrl.selectedServiceNames.clear();
                                        ctrl.selectedWorkItems.clear();
                                        ctrl.workItemOptions.clear();
                                        ctrl.applyFilters(<String, String>{});
                                        Get.to(
                                          () =>
                                              const HireContractorProfileList(),
                                        );
                                      } catch (_) {
                                        Get.to(
                                          () => AllCategoriesSection(
                                            categories:
                                                topCategoryController
                                                    .categories ??
                                                const [],
                                          ),
                                        );
                                      }
                                    },
                                    height: 40,
                                    titleTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.semiBold,
                                    ),
                                    backgroundColor: ColorRes.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 44,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: ColorRes.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: ColorRes.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      final cc =
                                          Get.isRegistered<ContactController>()
                                              ? Get.find<ContactController>()
                                              : Get.put(ContactController());
                                      if (cc.primaryPhone.value.isEmpty) {
                                        await cc.loadContacts(reset: true);
                                      }
                                      final number = cc.primaryPhone.value;
                                      if (number.isNotEmpty) {
                                        await ContactHelper.openDialer(number);
                                      }
                                    },
                                    icon: const Icon(Icons.call, size: 20),
                                    color: ColorRes.primary,
                                    tooltip: 'Call',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 44,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: ColorRes.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: ColorRes.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      final cc =
                                          Get.isRegistered<ContactController>()
                                              ? Get.find<ContactController>()
                                              : Get.put(ContactController());
                                      if (cc.primaryPhone.value.isEmpty) {
                                        await cc.loadContacts(reset: true);
                                      }
                                      final number = cc.primaryPhone.value;
                                      if (number.isNotEmpty) {
                                        await ContactHelper.openWhatsApp(
                                          number,
                                        );
                                      }
                                    },
                                    icon: Image.asset(
                                      'assets/images/whatsapp.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    tooltip: 'WhatsApp',
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
        ),
      );
    });
  }

  Widget _buildPlatformServices() {
    return Obx(() {
      if (platformServicesController.isLoading.value &&
          platformServicesController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 10),
            const TitleWithViewAll(
              title: "Why Choose NesticoPe",

              isSubTitle: true,
              subTitle: "Simple, Secure & Transparent Property Services.",

              showViewAll: false,
            ),
            const SizedBox(height: 10),
            const PlatformServiceShimmer(),
          ],
        );
      }

      if (platformServicesController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),

        // margin: EdgeInsets.symmetric(vertical: 20),
        color: Color(0xffFAF9F8),

        child: Column(
          children: [
            const SizedBox(height: 10),

            const TitleWithViewAll(
              title: "Why Choose NesticoPe",
              isSubTitle: true,
              subTitle: "Simple, Secure & Transparent Property Services.",

              showViewAll: false,
            ),

            const SizedBox(height: 5),
            PlatformServiceHorizontalList(
              services: platformServicesController.items,
              cardWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildNewsAndArticles() {
    return Obx(() {
      if (newsController.isLoading.value && newsController.items.isEmpty) {
        return Column(
          children: [
            const SizedBox(height: 5),
            const TitleWithViewAll(
              title: "Latest News & Articles",
              showViewAll: false,
            ),
            const SizedBox(height: 8),
            const NewsArticlesShimmer(),
            const SizedBox(height: 20),
          ],
        );
      }

      if (newsController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12),

        // margin: EdgeInsets.symmetric(vertical: 20),
        color: Color.fromARGB(255, 252, 245, 237),

        child: Column(
          children: [
            const SizedBox(height: 5),
            TitleWithViewAll(
              title: "Latest News & Articles",
              showViewAll: true,
              onViewAll: () {
                Get.to(
                  () => AllNewsArticleScreen(articles: newsController.items),
                );
              },
            ),
            const SizedBox(height: 10),
            NewsAndArticles(articles: newsController.items),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }

  Widget _buildWhyChooseUs() {
    return Column(
      children: [
        // const SizedBox(height: 5),
        TitleWithViewAll(
          title: "Why Choose NesticoPe",
          showViewAll: false,
          onViewAll: () {},
        ),
        const SizedBox(height: 12),
        WhyChooseUsSection(),
      ],
    );
  }

  Widget _buildReviewsAndTestimonials() {
    return Obx(() {
      if (reviewController.isLoading.value &&
          reviewController.allReviews.isEmpty) {
        return const ReviewsTestimonialsShimmer();
      }

      if (reviewController.allReviews.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const TitleWithViewAll(
            title: "What Our Customers Say",
            showViewAll: false,
          ),
          const SizedBox(height: 12),
          ReviewsAndTestimonials(),
          SizedBox(height: AppSpacing.medium),
        ],
      );
    });
  }

  Widget _buildHomeProcessSteps() {
    final steps = [
      {
        'icon': Icons.search,
        'title': 'Searches',
        'subtitle': 'Only Verified Suggestion',
        'color': ColorRes.blueColor,
      },
      {
        'icon': Icons.task_alt_outlined,
        'title': 'Finalizing',
        'subtitle': 'NesticoPe Help You find best property and best price',
        'color': ColorRes.leadTealColor,
      },
      {
        'icon': Icons.article_outlined,
        'title': 'Legal',
        'subtitle': 'We will Help you on all paperwork.',
        'color': ColorRes.purpleColor,
      },
      {
        'icon': Icons.emoji_events_outlined,
        'title': 'Congratulations',
        'subtitle': 'Celebrate your new home with us!',
        'color': ColorRes.orangeColor,
      },
      {
        'icon': Icons.home_repair_service_outlined,
        'title': 'Construction & Services',
        'subtitle': 'Vastu, Interior & Home Services',
        'color': ColorRes.success,
      },
    ];

    return Column(
      children: [
        const SizedBox(height: 15),
        const TitleWithViewAll(
          title: "Support at Every Step",
          showViewAll: false,
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(steps.length * 2 - 1, (i) {
                  if (i.isOdd) {
                    return Container(
                      margin: const EdgeInsets.only(top: 28),
                      width: 40,
                      height: 2,
                      decoration: BoxDecoration(
                        color: ColorRes.leadGreyColor.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  } else {
                    final stepIndex = i ~/ 2;
                    final s = steps[stepIndex];
                    return _buildMinimalStepWithText(
                      index: stepIndex + 1,
                      icon: s['icon'] as IconData,
                      ringColor: s['color'] as Color,
                      title: s['title'] as String,
                      subtitle: s['subtitle'] as String,
                    );
                  }
                }),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMinimalStep({
    required int index,
    required IconData icon,
    required Color ringColor,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ringColor.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: Icon(icon, color: ringColor, size: 24)),
        ),
        Positioned(
          // top: -8,
          left: -4,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: ColorRes.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                '$index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.extraSmall,
                  fontWeight: AppFontWeights.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalStepWithText({
    required int index,
    required IconData icon,
    required Color ringColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMinimalStep(index: index, icon: icon, ringColor: ringColor),
          const SizedBox(height: 10),
          SizedBox(
            width: 140,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    // fontFamily: FontRes.poppins,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.leadGreyColor.shade600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildFindPropertyButton() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     child: ElevatedButton.icon(
  //       icon: const Icon(Icons.search, size: 22),
  //       onPressed:
  //           () => showFindPropertyDialog(
  //             propertyController,
  //             googleMapController,
  //             context,
  //           ),
  //       style: ElevatedButton.styleFrom(
  //         minimumSize: const Size(double.infinity, 48),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //       label: const Text("Find Your Property"),
  //     ),
  //   );
  // }
  Widget _buildFindPropertyButton() {
    return Container(
      color: Color.fromARGB(255, 253, 247, 240),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              () => showFindPropertyDialog(
                propertyController,
                googleMapController,
                context,
              ),
          child: Container(
            width: double.infinity,
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: ColorRes.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorRes.primary.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.search, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "Find Your Property",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // ✅ Clear cached data on dispose
    // _pinnedSearchNotifier.dispose();
    _scrollController.dispose();
    _cachedNewlyAddedProperties.clear();
    _cachedTopProperties.clear();
    super.dispose();
  }
}

// Helper widget for field labels
Widget _buildFieldLabel(String label) {
  return Text(
    label,
    style: const TextStyle(
      fontSize: AppFontSizes.medium,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textPrimary,
    ),
  );
}

// Find Property Dialog
Future<void> showFindPropertyDialog(
  PropertyController controller,
  GoogleMapSearchController googleMapController,
  BuildContext context,
) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Get.dialog(
    Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(),
              _buildDialogContent(controller, googleMapController, context),
              _buildDialogFooter(controller, formKey),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

Widget _buildDialogHeader() {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: const BoxDecoration(
      color: ColorRes.primary,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            "Find Your Dream Property",

            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.white,
            ),
          ),
        ),
        InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(50),
          child: const Icon(
            Icons.close_rounded,
            color: ColorRes.white,
            size: 20,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDialogContent(
  PropertyController controller,
  GoogleMapSearchController googleMapController,
  BuildContext context,
) {
  return Flexible(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CitySelectionWidget(
            isEditing: true,
            isRequired: true,
            controller: controller.selectedCityZ,
            color: ColorRes.primary,
            fillColor: ColorRes.white,
            onCitySelected: (selectedCity) {
              debugPrint("✅ Selected city: ${selectedCity.description}");
              controller.selectedCityZ.text = selectedCity.description ?? '';
            },
          ),
          const SizedBox(height: 16),
          _buildListingTypeDropdown(controller),
          const SizedBox(height: 12),
          _buildBHKDropdown(controller),
          const SizedBox(height: 12),
          _buildBudgetRange(controller),
        ],
      ),
    ),
  );
}

Widget _buildListingTypeDropdown(PropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildFieldLabel('Listing Type'),
      const SizedBox(height: 8),
      Obx(
        () => DropdownButtonFormField<String>(
          value:
              controller.listingTypes.contains(
                    controller.selectedListingType.value,
                  )
                  ? controller.selectedListingType.value
                  : null,
          isDense: true,
          isExpanded: true,
          decoration: _getDropdownDecoration('Select', Icons.category_outlined),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorRes.primary,
          ),
          items:
              controller.listingTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: (val) => controller.selectedListingType.value = val,
        ),
      ),
    ],
  );
}

Widget _buildBHKDropdown(PropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildFieldLabel('BHK'),
      const SizedBox(height: 8),
      Obx(
        () => DropdownButtonFormField<String>(
          value:
              controller.bhkList.contains(controller.selectedBhk.value)
                  ? controller.selectedBhk.value
                  : null,
          isDense: true,
          isExpanded: true,
          decoration: _getDropdownDecoration('Select', Icons.home_outlined),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorRes.primary,
          ),
          items:
              controller.bhkList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
          onChanged: (val) => controller.selectedBhk.value = val,
        ),
      ),
    ],
  );
}

Widget _buildBudgetRange(PropertyController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildFieldLabel('Budget Range'),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.minBudget,
              keyboardType: TextInputType.number,
              decoration: _getTextFieldDecoration('Min'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'to',
              style: TextStyle(fontWeight: AppFontWeights.medium),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.maxBudget,
              keyboardType: TextInputType.number,
              decoration: _getTextFieldDecoration('Max'),
            ),
          ),
        ],
      ),
    ],
  );
}

InputDecoration _getDropdownDecoration(String hint, IconData icon) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Get.theme.colorScheme.onSurface.withAlpha(128),
      fontSize: AppFontSizes.bodyMedium,
    ),
    prefixIcon: Icon(icon, color: ColorRes.primary, size: 20),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorRes.primary, width: 1.2),
    ),
    filled: true,
    fillColor: ColorRes.white,
  );
}

InputDecoration _getTextFieldDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Get.theme.colorScheme.onSurface.withAlpha(128),
      fontSize: AppFontSizes.bodyMedium,
    ),
    prefixIcon: const Icon(
      Icons.currency_rupee,
      color: ColorRes.primary,
      size: 18,
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorRes.primary, width: 1.2),
    ),
    filled: true,
    fillColor: ColorRes.white,
  );
}

Widget _buildDialogFooter(
  PropertyController controller,
  GlobalKey<FormState> formKey,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: ColorRes.white,
      border: Border(top: BorderSide(color: ColorRes.grey.withOpacity(0.2))),
    ),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => controller.resetTheForm(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: ColorRes.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorRes.primary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                controller.findProperties();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 20),
                SizedBox(width: 8),
                Text('Find Properties'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class CityDropdown extends StatefulWidget {
  const CityDropdown({super.key});

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  final List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Pune',
  ];

  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorRes.white,
        ),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            // Remove borders
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          value: selectedCity,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorRes.leadGreyColor,
          ),
          // Custom arrow icon
          items:
              cities.map((String city) {
                return DropdownMenuItem<String>(value: city, child: Text(city));
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedCity = newValue!;
            });
          },
        ),
      ),
    );
  }
}

class ReviewsAndTestimonials extends StatelessWidget {
  const ReviewsAndTestimonials({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.find<PlatformReviewController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          // Show loading indicator
          if (reviewController.isLoading.value &&
              reviewController.siteReviewWithUsers.isEmpty) {
            return SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(color: ColorRes.homeGreenFade),
              ),
            );
          }

          // Show empty state
          if (reviewController.allReviews.isEmpty) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: ColorRes.leadGreyColor.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews available',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        color: ColorRes.leadGreyColor.shade600,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show reviews list
          return SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reviewController.allReviews.length,
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 12),
              separatorBuilder:
                  (_, __) => const SizedBox(width: AppSpacing.medium),
              itemBuilder: (context, index) {
                // UserItem userData=reviewController.listOfUser.map((element) => element.toMap(),).toString();
                return _buildReviewCard(
                  context,
                  reviewController.allReviews[index],
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewCard(BuildContext context, ReviewItem review) {
    final rating = review.rating ?? 0.0;
    final isVerified = review.isVerified ?? false;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
          // border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,

              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header with avatar and rating
              Row(
                children: [
                  /// Avatar (placeholder since we don't have reviewer details)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          ColorRes.homeGreenFade.withOpacity(0.08),
                          ColorRes.homeGreenDarkFade.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Color(0xFF2E7D63).withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (() {
                        final user = review?.entityUser;

                        if (user == null) return '?';
                        final username = user.username?.trim() ?? '';

                        if (username.isNotEmpty) {
                          return username[0]
                              .toUpperCase(); // fallback to username
                        } else {
                          return '?'; // fallback if all empty
                        }
                      })(),
                      style: TextStyle(
                        fontSize: AppFontSizes.large,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.homeGreenDarkFade,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Reviewer ID and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${review.entityUser?.username}',
                                      maxLines: 1,

                                      style: TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.semiBold,
                                        color: ColorRes.homeBlackFade,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _formatDate(review.createdAt),
                                    style: TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: ColorRes.leadGreyColor.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: ColorRes.homeGreenDarkFade,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: ColorRes.white,
                                  size: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${review.entityType}',
                          maxLines: 1,

                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.regular,
                            color: ColorRes.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(5, (starIndex) {
                              if (starIndex < rating.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else if (starIndex < rating) {
                                return const Icon(
                                  Icons.star_half,
                                  color: ColorRes.homeYellow,
                                  size: 16,
                                );
                              } else {
                                return Icon(
                                  Icons.star_outline,
                                  color: ColorRes.leadGreyColor.shade300,
                                  size: 16,
                                );
                              }
                            }),
                            const SizedBox(width: 8),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.homeBlackFade,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (review.title != null && review.title!.isNotEmpty) ...[
                SizedBox(
                  width: 280,
                  child: Text(
                    review.title!,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.homeBlackFade,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: 280,
                child: Text(
                  '"${review.content ?? 'No review content'}"',
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade700,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get status color

  /// Helper method to get status icon

  /// Helper method to format date
  String _formatDate(String? dateString) {
    if (dateString == null) return 'Recently';

    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  /// Show review details in a bottom sheet
}

class NewsAndArticles extends StatelessWidget {
  final List<NewsItem> articles;

  const NewsAndArticles({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    bool isNewArticle(String? publishDate) {
      if (publishDate == null) return false;
      final published = DateTime.tryParse(publishDate);
      if (published == null) return false;
      return DateTime.now().difference(published).inDays <= 7;
    }

    return SizedBox(
      height: 280,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        clipBehavior: Clip.none,
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          final isNew = isNewArticle(article.publishDate);
          print("Image ------------------> ${article.coverImage}");
          return GestureDetector(
            onTap: () {
              Get.to(() => NewsDetailScreen(newsItem: article));
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
                // border: Border.all(
                //   color: ColorRes.leadGreyColor.withOpacity(0.3),
                //   width: 1,
                // ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,

                    offset: const Offset(0, 3),
                  ),
                ],
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
                  Expanded(
                    child: Padding(
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
                            article.summary ?? '',
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
                              ClipOval(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: ColorRes.primary,
                                  ),
                                  child: Text(
                                    (article.title?.isNotEmpty ?? false)
                                        ? article.title![0].toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Author name and date
                              SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            article.author ?? '',
                                            maxLines: 1,

                                            style: TextStyle(
                                              fontSize: AppFontSizes.small,
                                              color: ColorRes.textPrimary,
                                              fontWeight:
                                                  AppFontWeights.semiBold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                ColorRes.leadGreyColor.shade200,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            _formatDate(article.publishDate),
                                            style: TextStyle(
                                              fontSize: AppFontSizes.caption,
                                              color:
                                                  ColorRes
                                                      .leadGreyColor
                                                      .shade700,
                                              fontWeight: AppFontWeights.medium,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            article.authorDesignation
                                                    ?.replaceAll("-", " ")
                                                    .capitalize ??
                                                '',

                                            maxLines: 2,
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

class ExploreLocalities extends StatelessWidget {
  final List<TrendingArea> trendingArea;

  const ExploreLocalities({super.key, required this.trendingArea});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80, // height for one row of cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.medium),
        itemCount: trendingArea.length,
        itemBuilder: (context, index) {
          final locality = trendingArea[index];

          // Calculate trend based on inquiries
          final bool isUp = locality.totalInquiries > 0;

          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.small),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                // Handle locality tap - navigate to properties in this area
                // You can pass locality.area and locality.city to the next screen
              },
              child: Container(
                width: 180, // fixed card width for horizontal list
                padding: const EdgeInsets.all(AppSpacing.small),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ColorRes.leadGreyColor.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Locality name
                    Text(
                      locality.area,
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    /// Property Count
                    Text(
                      '${locality.propertyCount} ${locality.propertyCount == 1 ? 'Property' : 'Properties'}',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.leadGreyColor.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Inquiries + Trend Arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${locality.totalInquiries} ${locality.totalInquiries == 1 ? 'inquiry' : 'inquiries'}',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color:
                                  isUp
                                      ? ColorRes.green.shade600
                                      : ColorRes.leadGreyColor.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (locality.totalInquiries > 0)
                          Icon(
                            Icons.trending_up_rounded,
                            size: 16,
                            color: ColorRes.green.shade600,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrendingInsights extends StatelessWidget {
  TrendingInsights({super.key});

  final trendingInsights = [
    {
      "title": "Price Trends",
      "subtitle": "Find property rates & price trends of top locations",
      "image": IMGRes.news_1,
      "tag": "Trending",
      "isHot": true,
    },
    {
      "title": "City Insights",
      "subtitle": "Get to know about top cities before you invest",
      "image": IMGRes.news_2,
      "tag": "Hot Topic",
      "isHot": false,
    },
    {
      "title": "NesticoPe Research",
      "subtitle": "Find reports on Indian residential market",
      "image": IMGRes.news_3,
      "tag": "Eco Trend",
      "isHot": true,
    },
    {
      "title": "Reviews",
      "subtitle": "Read authentic reviews from property buyers and renters",
      "image": IMGRes.news_1,
      "tag": "Tech",
      "isHot": false,
    },
  ];

  final List<IconData> icons = [
    Icons.trending_up,
    Icons.apartment,
    Icons.eco,
    Icons.rate_review,
  ];

  final List<Color> iconColors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trendingInsights.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final insight = trendingInsights[index];

          return SizedBox(
            width: 200,
            child: CompactInsightCard(
              tag: insight["tag"]?.toString() ?? "",
              title: insight["title"]?.toString() ?? "No Title",
              value: insight["subtitle"]?.toString() ?? "",
              icon: icons[index],
              // color: iconColors[index],
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

class CompactInsightCard extends StatelessWidget {
  final IconData icon;
  final String tag;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const CompactInsightCard({
    super.key,
    required this.tag,
    required this.title,
    required this.value,
    this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Row(
              children: [
                Container(child: Icon(icon, size: 16, color: ColorRes.primary)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.primary,
                      // color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 6),
              ],
            ),

            const SizedBox(height: 8),

            /// Value / detail
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                color: ColorRes.leadGreyColor.shade600,
                fontWeight: AppFontWeights.medium,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class WhyChooseUsSection extends StatelessWidget {
  final items = [
    {
      "title": "Over 8 Properties",
      "subtitle":
          "A wide range of residential and commercial properties updated daily.",
      "icon": Icons.home_outlined,
    },
    {
      "title": "Verified by Experts",
      "subtitle":
          "Photos, videos and property details are verified on-site by our team.",
      "icon": Icons.verified_outlined,
    },
    {
      "title": "Direct Connections",
      "subtitle":
          "Connect directly with trusted builders and owners without middlemen.",
      "icon": Icons.group_outlined,
    },
    {
      "title": "Smart Alerts",
      "subtitle":
          "Get real-time notifications for price drops and new property matches.",
      "icon": Icons.notifications_active_outlined,
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            width: 220,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ColorRes.leadGreyColor.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  item["icon"] as IconData,
                  size: 28,
                  color: ColorRes.primary,
                ),

                const SizedBox(height: 8),

                Text(
                  "${item['title']}",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                Text(
                  "${item['subtitle']}",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade600,
                    fontWeight: AppFontWeights.medium,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RecommendedInsights extends StatelessWidget {
  const RecommendedInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final insights = [
      {
        "title": "Real Estate Market Trends 2025",
        "description":
            "An in-depth analysis of the current real estate market trends.",
        "imageUrl":
            "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?cs=srgb&dl=pexels-pixabay-106399.jpg&fm=jpg",
      },
      {
        "title": "Top 10 Cities for Property Investment",
        "description":
            "Discover the best cities to invest in real estate in 2025.",
        "imageUrl":
            "https://images.pexels.com/photos/221457/pexels-photo-221457.jpeg?cs=srgb&dl=pexels-pixabay-221457.jpg&fm=jpg",
      },
      {
        "title": "Tips for First-Time Home Buyers",
        "description":
            "Essential tips and advice for those buying their first home.",
        "imageUrl":
            "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?cs=srgb&dl=pexels-pixabay-259588.jpg&fm=jpg",
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: insights.length,
        padding: EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = insights[index];
          return InsightsCard(
            title: item["title"]!,
            description: item["description"]!,
            imageUrl: item["imageUrl"]!,
            onReadMore: () {
              // Handle read more
            },
          );
        },
      ),
    );
  }
}

class InsightsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onReadMore;

  const InsightsCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: double.infinity,
                  color: ColorRes.leadGreyColor.shade300,
                  child: const Icon(Icons.broken_image, color: ColorRes.white),
                );
              },
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: child,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.leadGreyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: onReadMore,
                    child: Text(
                      "Read More",
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: Theme.of(context).primaryColor,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> propertyPercentage = [
  "9.6",
  "10.2",
  "7.8",
  "15.4",
  "12.0",
  "8.9",
  "11.5",
  "14.3",
  "9.0",
  "16.8",
];

class ReferralCard extends StatelessWidget {
  final String referralCode;

  const ReferralCard({Key? key, required this.referralCode}) : super(key: key);

  void _shareReferral(BuildContext context) {
    final String shareText =
        "Hey! Use my referral code 👉 $referralCode to sign up and enjoy benefits! \n\nDownload the app here: https://example.com/app";

    Share.share(shareText, subject: "Join with my referral code");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: ColorRes.primary.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Refer Friends",
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: const Text(
                  "Share app and help your friends discover great real estate options!",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.normal,
                    color: ColorRes.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _shareReferral(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.share),
                label: const Text(
                  "Share Code",
                  style: TextStyle(color: ColorRes.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerSupport extends StatelessWidget {
  final String phoneNumber;

  const CustomerSupport({Key? key, required this.phoneNumber})
    : super(key: key);

  Future<void> _callSupport() async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(
      launchUri,
      mode: LaunchMode.externalNonBrowserApplication, // 👈 important
    )) {
      throw "Could not launch dialer for $phoneNumber";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 6,
        color: ColorRes.homeYellowDark.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Support",
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: const Text(
                  "Need help? Call our support team for assistance anytime.",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: FontWeight.normal,
                    color: ColorRes.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _callSupport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.white,
                  foregroundColor: ColorRes.homeYellowDark.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: Icon(Icons.call, color: ColorRes.homeYellowDark.shade900),
                label: Text(
                  "Call Support",
                  style: TextStyle(color: ColorRes.homeYellowDark.shade900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackComponent extends StatefulWidget {
  final Function(int rating, String feedback) onSubmit;

  const FeedbackComponent({super.key, required this.onSubmit});

  @override
  State<FeedbackComponent> createState() => _FeedbackComponentState();
}

class _FeedbackComponentState extends State<FeedbackComponent> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: ColorRes.leadGreyColor.shade400, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rate Our App",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: AppFontWeights.bold,
                color: ColorRes.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Rating ($_rating/5)",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                // fontSize: ,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    size: 32,
                    color:
                        index < _rating
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor.shade400,
                  ),
                );
              }),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write your feedback...",
                hintStyle: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.leadGreyColor,
                ),
                filled: true,
                fillColor: ColorRes.leadGreyColor[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: ColorRes.leadGreyColor),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorRes.leadGreyColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorRes.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_rating != 0 ||
                      _feedbackController.text.trim().isNotEmpty) {
                    widget.onSubmit(_rating, _feedbackController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feedback Submitted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please add rating & feedback'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorRes.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    color: ColorRes.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyHorizontalCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String location;
  final String price;

  // ✅ Font Weights
  final FontWeight priceFontWeight;
  final FontWeight locationWeight;
  final FontWeight titleFontWeight;

  // ✅ Layout
  final int maxLineTitle;
  final int maxLineSubtitle;
  final int maxLine;

  // ✅ Styling properties
  final Color borderColor;
  final Color textColor;
  final Color accentColor;
  final Color titleColor;
  final Color dividerColor;
  final Color locationColor;

  // ✅ Layout properties
  final double width;
  final double imageHeight;
  final double imageWidth;

  // ✅ Font sizes
  final double titleFontSize;
  final double locationFontSize;
  final double priceFontSize;

  // ✅ Rating
  final double? rating;
  final IconData ratingIcon;
  final Color ratingColor;

  // ✅ Button Row
  final String buttonText;
  final Color buttonTextColor;
  final double buttonFontSize;
  final FontWeight buttonFontWeight;
  final Color priceColor;
  final double ratingFont;
  final FontWeight ratingFontWeight;
  final IconData actionIcon;
  final Color iconColor;

  final bool showRowLayout;

  final VoidCallback? onTap;

  const PropertyHorizontalCard({
    super.key,
    required this.title,
    this.ratingFont = AppFontSizes.caption,
    this.ratingFontWeight = AppFontWeights.semiBold,
    this.locationColor = ColorRes.textSecondary,
    required this.imagePath,
    required this.location,
    this.price = '2020',
    this.priceColor = ColorRes.textPrimary,
    this.priceFontWeight = AppFontWeights.bold,
    this.locationWeight = AppFontWeights.regular,
    this.titleFontWeight = AppFontWeights.semiBold,
    this.maxLine = 2,
    this.maxLineTitle = 1,
    this.maxLineSubtitle = 1,

    // styling
    this.borderColor = ColorRes.leadGreyColor,
    this.textColor = ColorRes.black,
    this.accentColor = ColorRes.blueColor,
    this.titleColor = ColorRes.black,
    this.dividerColor = ColorRes.leadGreyColor,

    // layout (smaller container)
    this.width = 250,
    this.imageHeight = 60,
    this.imageWidth = 70,

    // font sizes (slightly smaller)
    this.titleFontSize = AppFontSizes.small,
    this.locationFontSize = AppFontSizes.mini,
    this.priceFontSize = AppFontSizes.small,

    // rating
    this.rating,
    this.ratingIcon = Icons.star,
    this.ratingColor = ColorRes.homeAmber,

    // button row
    this.buttonText = "View",
    this.buttonTextColor = ColorRes.leadIndigoColor,
    this.buttonFontSize = AppFontSizes.caption,
    this.buttonFontWeight = AppFontWeights.medium,
    this.actionIcon = Icons.arrow_forward_ios,
    this.iconColor = ColorRes.leadIndigoColor,

    this.showRowLayout = true,

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor.withOpacity(0.3), width: 0.8),
          color: ColorRes.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imagePath,
                height: imageHeight,
                width: imageWidth,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommonText(
                    title,
                    titleFontSize,
                    titleFontWeight,
                    textColor,
                    maxLineTitle,
                  ),
                  const SizedBox(height: 2),
                  buildCommonText(
                    location,
                    locationFontSize,
                    locationWeight,
                    locationColor,
                    maxLineSubtitle,
                  ),
                  const SizedBox(height: 4),
                  if (showRowLayout) ...[
                    Row(
                      children: [
                        buildCommonText(
                          Formatter.formatPrice(
                            double.tryParse(
                                  price.replaceAll(RegExp(r'[^\d.]'), ''),
                                )?.toInt() ??
                                0,
                          ),
                          priceFontSize,
                          priceFontWeight,
                          priceColor,
                          1,
                        ),
                        const Spacer(),
                        if (rating != null) ...[
                          Icon(ratingIcon, color: ratingColor, size: 14),
                          const SizedBox(width: 3),
                          buildCommonText(
                            rating.toString(),
                            ratingFont,
                            ratingFontWeight,
                            titleColor,
                            maxLine,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Divider(
                      color: dividerColor.withOpacity(0.35),
                      thickness: 0.5,
                      height: 6,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCommonText(
                          buttonText,
                          buttonFontSize,
                          buttonFontWeight,
                          buttonTextColor,
                          1,
                        ),
                        const SizedBox(width: 3),
                        Icon(actionIcon, color: iconColor, size: 12),
                      ],
                    ),
                  ] else ...[
                    buildCommonText(
                      Formatter.formatPrice(
                        double.tryParse(
                              price.replaceAll(RegExp(r'[^\d.]'), ''),
                            )?.toInt() ??
                            0,
                      ),
                      priceFontSize,
                      priceFontWeight,
                      priceColor,
                      1,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewHighlights extends StatefulWidget {
  final List<String> goodThings;
  final List<String> improvements;

  const ReviewHighlights({
    super.key,
    required this.goodThings,
    required this.improvements,
  });

  @override
  State<ReviewHighlights> createState() => _ReviewHighlightsState();
}

class _ReviewHighlightsState extends State<ReviewHighlights> {
  bool showAllGood = false;
  bool showAllImprovements = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.goodThings.isNotEmpty)
            _buildTagSection(
              "Good Things",
              widget.goodThings,
              showAllGood,
              (value) => setState(() => showAllGood = value),
            ),
          if (widget.goodThings.isNotEmpty && widget.improvements.isNotEmpty)
            const SizedBox(height: 16),
          if (widget.improvements.isNotEmpty)
            _buildTagSection(
              "Need to Improve",
              widget.improvements,
              showAllImprovements,
              (value) => setState(() => showAllImprovements = value),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTagSection(
    String title,
    List<String> items,
    bool expanded,
    Function(bool) toggleExpand,
  ) {
    // show first 4 items unless expanded
    final displayItems = expanded ? items : items.take(3).toList();
    final remainingCount = items.length - displayItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: AppFontWeights.semiBold,
            fontSize: AppFontSizes.small,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...displayItems.map(
              (e) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.grey.withOpacity(0.090),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.grey,
                  ),
                ),
              ),
            ),
            if (!expanded && remainingCount > 0)
              GestureDetector(
                onTap: () => toggleExpand(true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "+$remainingCount more",
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget buildHeading(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppFontSizes.body,
        fontWeight: AppFontWeights.extraBold,
      ),
    );
  }
}

class StateSelectionWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;
  final bool isRequired;
  final Color? color;
  final Color? iconColor;
  final Color? fillColor;
  final TextStyle? style;
  final bool isRequiredTitle;
  final Function(Prediction)? onCitySelected; // ✅ callback for selected city

  const StateSelectionWidget({
    super.key,
    required this.controller,
    this.isRequired = false,
    this.onCitySelected,
    this.isEditing = true,
    this.iconColor = ColorRes.primary,
    this.style = const TextStyle(
      fontSize: AppFontSizes.medium,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textPrimary,
    ),
    this.isRequiredTitle = true,
    this.color,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final googleMapController = Get.put(GoogleMapSearchController());
    return Column(
      children: [
        // 🔹 Custom TextField
        // TextFormField(
        //   controller: controller,
        //   enabled: isEditing,
        //   style: TextStyle(
        //     fontSize: AppFontSizes.small,
        //     color: ColorRes.homeBlackFade,
        //   ),
        //   decoration: InputDecoration(
        //     labelText: "Select State",
        //     labelStyle: TextStyle(
        //       fontSize: AppFontSizes.small,
        //       color: ColorRes.leadGreyColor[500],
        //     ),
        //     prefixIcon: Icon(
        //       Icons.location_city_outlined,
        //       size: 20,
        //       color: ColorRes.leadGreyColor[600],
        //     ),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: BorderSide(
        //         color: ColorRes.leadGreyColor.withOpacity(0.3),
        //       ),
        //     ),
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: BorderSide(
        //         color: ColorRes.leadGreyColor.withOpacity(0.3),
        //       ),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: const BorderSide(
        //         color: ColorRes.blueColor,
        //         width: 1.5,
        //       ),
        //     ),
        //     disabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: BorderSide(
        //         color: ColorRes.leadGreyColor.withOpacity(0.2),
        //       ),
        //     ),
        //     errorBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: const BorderSide(color: ColorRes.error, width: 1),
        //     ),
        //     focusedErrorBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: const BorderSide(color: ColorRes.error, width: 1.5),
        //     ),
        //     filled: true,
        //     fillColor: ColorRes.leadGreyColor[50],
        //     contentPadding: const EdgeInsets.symmetric(
        //       horizontal: 16,
        //       vertical: 14,
        //     ),
        //   ),
        //   onChanged: (value) async {
        //     if (value.isNotEmpty) {
        //       await googleMapController.fetchGooglePlaces(value);
        //       log("City input: $value");
        //     } else {
        //       googleMapController.predictions.clear();
        //     }
        //   },
        // ),
        if (isRequiredTitle) ...[
          NesticoPeTextField(
            hintText: 'Select State',
            title: "State",
            controller: controller,
            iconColor: iconColor,
            style: style ?? TextStyle(),
            enabled: isEditing,
            isRequired: isRequired,
            prefixIcon: Icons.map_outlined,

            autovalidateMode: AutovalidateMode.onUserInteraction,

            onChanged: (value) async {
              if (value.isNotEmpty) {
                await googleMapController.fetchGooglePlaces(value);
                log("State input: $value");
              } else {
                googleMapController.predictions.clear();
                googleMapController.cityStateList.clear();
              }
            },

            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Please select a state';
              }
              return null;
            },
          ),
        ] else ...[
          NesticoPeTextField(
            hintText: 'Select State',
            controller: controller,
            iconColor: iconColor,
            enabled: isEditing,
            prefixIcon: Icons.map_outlined,

            autovalidateMode: AutovalidateMode.onUserInteraction,

            onChanged: (value) async {
              if (value.isNotEmpty) {
                await googleMapController.fetchGooglePlaces(value);
              } else {
                googleMapController.predictions.clear();
                googleMapController.cityStateList.clear();
              }
            },
          ),
        ],

        const SizedBox(height: 8),

        // 🔹 City Suggestions (Obx listens for updates)
        Obx(() {
          final predictions = googleMapController.predictions;
          final parsedCities = googleMapController.cityStateList;

          // choose which list to show
          final hasParsed = parsedCities.isNotEmpty;
          final items = hasParsed ? parsedCities : predictions;

          if (items.isEmpty) return const SizedBox();

          return Container(
            constraints: const BoxConstraints(maxHeight: 250),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length > 3 ? 3 : items.length,
              itemBuilder: (context, index) {
                if (hasParsed) {
                  // ✅ Cast item to Map<String, String?>
                  final cityData = items[index] as Map<String, String?>;

                  log("djhfudfhg ${cityData}");

                  return ListTile(
                    leading: const Icon(
                      Icons.location_city_outlined,
                      size: 20,
                      color: ColorRes.primary,
                    ),
                    title: Text(
                      cityData['city'] ?? '',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.homeBlackFade,
                      ),
                    ),
                    subtitle: Text(
                      '${cityData['state'] ?? ''}, ${cityData['country'] ?? ''}',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.leadGreyColor[700],
                      ),
                    ),
                    onTap: () {
                      controller.text = cityData['city'] ?? '';
                      googleMapController.predictions.clear();
                      googleMapController.cityStateList.clear();
                      FocusScope.of(context).unfocus();

                      if (onCitySelected != null) {
                        onCitySelected!(
                          Prediction(description: cityData['state']),
                        );
                      }
                    },
                  );
                } else {
                  final city = items[index] as Prediction;
                  return ListTile(
                    leading: const Icon(
                      Icons.location_city_outlined,
                      size: 20,
                      color: ColorRes.primary,
                    ),
                    title: Text(
                      city.description ?? '',
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.homeBlackFade,
                      ),
                    ),
                    onTap: () {
                      controller.text = city.description ?? '';
                      googleMapController.predictions.clear();
                      FocusScope.of(context).unfocus();

                      if (onCitySelected != null) onCitySelected!(city);
                    },
                  );
                }
              },
            ),
          );
        }),
      ],
    );
  }
}

// ========================================
// SHIMMER COMPONENTS FOR HOME SCREEN
// ========================================

/// Shimmer for Property Type Selector
class PropertyTypeSelectorShimmer extends StatelessWidget {
  const PropertyTypeSelectorShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(
          8,
          (index) => Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 8 : 2,
              right: index == 7 ? 8 : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerWidget(width: 60, height: 60, shape: BoxShape.circle),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 76, height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for Horizontal Property List
class HorizontalPropertyListShimmer extends StatelessWidget {
  const HorizontalPropertyListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SizedBox(
        height: 310,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerShapes.rounded(
                    width: 280,
                    height: 180,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 12),
                  ShimmerShapes.text(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  ShimmerShapes.text(width: 200, height: 14),
                  const SizedBox(height: 8),
                  ShimmerShapes.text(width: 200, height: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Shimmer for Project List
class ProjectListShimmer extends StatelessWidget {
  const ProjectListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerShapes.rounded(
                  width: 250,
                  height: 150,
                  borderRadius: 12,
                ),
                const SizedBox(height: 12),
                ShimmerShapes.text(width: double.infinity, height: 16),
                const SizedBox(height: 6),
                ShimmerShapes.text(width: 180, height: 14),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ShimmerShapes.text(width: 80, height: 14),
                    const Spacer(),
                    ShimmerShapes.text(width: 60, height: 14),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for City Filter List
class CityFilterListShimmer extends StatelessWidget {
  const CityFilterListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: Column(
              children: [
                ShimmerShapes.rounded(width: 160, height: 80, borderRadius: 12),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 120, height: 14),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Seller List
class SellerListShimmer extends StatelessWidget {
  const SellerListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 120,
            child: Column(
              children: [
                ShimmerShapes.circle(size: 80),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 100, height: 14),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 80, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BuilderListShimmer extends StatelessWidget {
  const BuilderListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 120,
            child: Column(
              children: [
                ShimmerShapes.circle(size: 80),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 100, height: 14),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 80, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ContractorCardShimmer extends StatelessWidget {
  const ContractorCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: 3,
        itemBuilder: (_, __) {
          return SizedBox(
            width: 300,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TOP ROW
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerShapes.circle(size: 52),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Name + compare
                            Row(
                              children: [
                                Expanded(
                                  child: ShimmerShapes.text(
                                    width: double.infinity,
                                    height: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ShimmerShapes.rounded(
                                  width: 32,
                                  height: 32,
                                  borderRadius: 8,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// Experience
                            ShimmerShapes.text(width: 120, height: 12),

                            const SizedBox(height: 8),

                            /// Rating row
                            Row(
                              children: [
                                ShimmerShapes.circle(size: 12),
                                const SizedBox(width: 6),
                                ShimmerShapes.text(width: 30, height: 12),
                                const SizedBox(width: 6),
                                ShimmerShapes.text(width: 60, height: 10),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// Tags (Premium + Type)
                            Row(
                              children: [
                                ShimmerShapes.rounded(
                                  width: 70,
                                  height: 18,
                                  borderRadius: 6,
                                ),
                                const SizedBox(width: 8),
                                ShimmerShapes.rounded(
                                  width: 80,
                                  height: 18,
                                  borderRadius: 6,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 🔹 SERVICES TEXT
                  ShimmerShapes.text(width: double.infinity, height: 12),
                  const SizedBox(height: 6),
                  ShimmerShapes.text(width: 220, height: 12),

                  const SizedBox(height: 16),

                  /// 🔹 STATS ROW
                  Row(
                    children: [
                      Expanded(child: _statBox()),
                      const SizedBox(width: 8),
                      Expanded(child: _statBox()),
                      const SizedBox(width: 8),
                      Expanded(child: _statBox()),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 BUTTON
                  ShimmerShapes.rounded(
                    width: double.infinity,
                    height: 44,
                    borderRadius: 30,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statBox() {
    return Column(
      children: [
        ShimmerShapes.text(width: 40, height: 12),
        const SizedBox(height: 6),
        ShimmerShapes.text(width: 30, height: 14),
      ],
    );
  }
}

/// Shimmer for Top Categories
class TopCategoriesShimmer extends StatelessWidget {
  const TopCategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ShimmerShapes.circle(size: 60),
            const SizedBox(height: 8),
            ShimmerShapes.text(width: 80, height: 12),
          ],
        );
      },
    );
  }
}

/// Shimmer for Platform Services
class PlatformServiceShimmer extends StatelessWidget {
  const PlatformServiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 140,
            child: Column(
              children: [
                ShimmerShapes.rounded(width: 140, height: 80, borderRadius: 12),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: 120, height: 14),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for News and Articles
class NewsArticlesShimmer extends StatelessWidget {
  const NewsArticlesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: ShimmerShapes.rectangle(
                      width: double.infinity,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerShapes.text(width: double.infinity, height: 16),
                        const SizedBox(height: 8),
                        ShimmerShapes.text(width: double.infinity, height: 14),
                        const SizedBox(height: 6),
                        ShimmerShapes.text(width: 180, height: 14),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ShimmerShapes.circle(size: 35),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerShapes.text(
                                    width: double.infinity,
                                    height: 12,
                                  ),
                                  const SizedBox(height: 4),
                                  ShimmerShapes.text(width: 100, height: 10),
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
}

/// Shimmer for Reviews and Testimonials
class ReviewsTestimonialsShimmer extends StatelessWidget {
  const ReviewsTestimonialsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerShapes.circle(size: 50),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerShapes.text(
                            width: double.infinity,
                            height: 14,
                          ),
                          const SizedBox(height: 6),
                          ShimmerShapes.text(width: 100, height: 12),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: ShimmerWidget(
                                  width: 16,
                                  height: 16,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ShimmerShapes.text(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                ShimmerShapes.text(width: 200, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Furnishing Type Cards
class FurnishingTypeShimmer extends StatelessWidget {
  const FurnishingTypeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ShimmerShapes.rounded(
                width: 200,
                height: 120,
                borderRadius: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer for Explore Localities
class ExploreLocalitiesShimmer extends StatelessWidget {
  const ExploreLocalitiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerShapes.text(width: 140, height: 14),
                const Spacer(),
                ShimmerShapes.text(width: 100, height: 12),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 120, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shimmer for Trending Insights
class TrendingInsightsShimmer extends StatelessWidget {
  const TrendingInsightsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerShapes.circle(size: 16),
                    const SizedBox(width: 6),
                    ShimmerShapes.text(width: 120, height: 14),
                  ],
                ),
                const SizedBox(height: 8),
                ShimmerShapes.text(width: double.infinity, height: 12),
                const SizedBox(height: 4),
                ShimmerShapes.text(width: 150, height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
