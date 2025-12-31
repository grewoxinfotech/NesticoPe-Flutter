// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
// import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
// import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
//     hide ColorRes;
// import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
// import 'package:intl/intl.dart';
//
// // Import your models
// import '../../../../app/manager/property/property_pricemanager.dart';
// import '../../../../data/network/property/models/property_model.dart';
// import '../../../../data/network/location_price_matrix/model/location_price_matrix_model.dart';
// import '../../../location_price_matrix/controllers/location_price_matrix_controller.dart';
// import '../../controllers/insights_property_controller.dart';
//
// class _ChartPoint {
//   final int year;
//   final num price;
//   final bool isPast;
//
//   _ChartPoint(this.year, this.price, this.isPast);
// }
//
// class ComparisonProperty {
//   final String id;
//   final String title;
//   final List<_ChartPoint> chartData;
//   final num avgPrice;
//   final String propertyType;
//
//   ComparisonProperty({
//     required this.id,
//     required this.title,
//     required this.chartData,
//     required this.avgPrice,
//     required this.propertyType,
//   });
// }
//
// class InvestmentInsightChart extends StatefulWidget {
//   final Items currentProperty;
//
//   const InvestmentInsightChart({super.key, required this.currentProperty});
//
//   @override
//   State<InvestmentInsightChart> createState() => _InvestmentInsightChartState();
// }
//
// class _InvestmentInsightChartState extends State<InvestmentInsightChart> {
//   // --- FIX START: Use late and find by tag ---
//   late final LocationPriceMatrixController _matrixController;
//
//   String _comparisonType = 'locality'; // 'locality' or 'property'
//   String? _selectedLocation;
//   String? _selectedPropertyType;
//   final List<ComparisonProperty> _selectedProperties = [];
//   final int _maxSelection = 2;
//
//   final List<Color> _comparisonColors = [
//     ColorRes.error, // Red
//     ColorRes.leadTealColor, // Teal
//     ColorRes.homeYellow, // Yellow
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Find the specific controller instance for this property ID
//     _matrixController = Get.find<LocationPriceMatrixController>(
//       tag: 'matrix_${widget.currentProperty.id}',
//     );
//
//     _initializeDefaults();
//   }
//
//   // --- FIX END ---
//
//   void _initializeDefaults() {
//     _selectedLocation = widget.currentProperty.location;
//     _selectedPropertyType = widget.currentProperty.propertyType;
//   }
//
//   String _formatCurrency(num value) {
//     return NumberFormat.compactCurrency(
//       symbol: '₹',
//       decimalDigits: 1,
//     ).format(value);
//   }
//
//   String _formatCurrencyFull(num value) {
//     return NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     ).format(value);
//   }
//
//   List<_ChartPoint> _generateChartData({
//     required List<PropertyPriceYear> past,
//     required List<PropertyPriceYear> future,
//   }) {
//     final List<_ChartPoint> data = [];
//
//     // Sort and add past data
//     final sortedPast = List<PropertyPriceYear>.from(past)
//       ..sort((a, b) => a.year.compareTo(b.year));
//
//     for (final p in sortedPast) {
//       data.add(_ChartPoint(p.year, p.pricePerSqft, true));
//     }
//
//     // Sort and add future data
//     final sortedFuture = List<PropertyPriceYear>.from(future)
//       ..sort((a, b) => a.year.compareTo(b.year));
//
//     for (final f in sortedFuture) {
//       data.add(_ChartPoint(f.year, f.pricePerSqft, false));
//     }
//
//     return data;
//   }
//
//   PropertyTypeData? _getPropertyTypeData() {
//     if (_selectedLocation == null || _selectedPropertyType == null) return null;
//
//     final buyData = _matrixController.buyData;
//     if (buyData == null) return null;
//
//     // Search through all states and cities
//     for (var stateData in buyData.values) {
//       for (var cityLocations in stateData.values) {
//         for (var locationData in cityLocations) {
//           // Match location (case-insensitive, partial match)
//           if (locationData.location.toLowerCase().contains(
//                 _selectedLocation!.toLowerCase(),
//               ) ||
//               _selectedLocation!.toLowerCase().contains(
//                 locationData.location.toLowerCase(),
//               )) {
//             // Return property type data if exists
//             final propTypeData =
//                 locationData.propertyTypes[_selectedPropertyType];
//             if (propTypeData != null) {
//               return propTypeData;
//             }
//           }
//         }
//       }
//     }
//
//     return null;
//   }
//
//   /// Get locality chart data - shows average by city for the current locality
//   List<_ChartPoint> _getLocalityChartData() {
//     final cityAvgPriceTrend = _matrixController.getAvgPriceTrendByCity();
//     if (cityAvgPriceTrend == null || cityAvgPriceTrend.isEmpty) return [];
//
//     return cityAvgPriceTrend
//         .map(
//           (trend) => _ChartPoint(
//             trend.year,
//             trend.avgPricePerSqFt,
//             trend.year <= DateTime.now().year,
//           ),
//         )
//         .toList()
//       ..sort((a, b) => a.year.compareTo(b.year));
//   }
//
//   /// Get property type chart data - shows average by property type in the state
//   List<_ChartPoint> _getPropertyTypeChartData() {
//     final propertyTypeData = _matrixController.getAvgPriceTrendByPropertyType();
//     if (propertyTypeData == null || propertyTypeData.isEmpty) return [];
//
//     return propertyTypeData
//         .map(
//           (trend) => _ChartPoint(
//             trend.year,
//             trend.avgPricePerSqFt,
//             trend.year <= DateTime.now().year,
//           ),
//         )
//         .toList()
//       ..sort((a, b) => a.year.compareTo(b.year));
//   }
//
//   double _calculateOptimalInterval(double range) {
//     if (range <= 0) return 100000;
//     final magnitude = pow(10, (log(range / 4) / log(10)).floor());
//     final candidates = [
//       magnitude,
//       magnitude * 2,
//       magnitude * 5,
//       magnitude * 10,
//     ];
//     for (final c in candidates) {
//       final ticks = range / c;
//       if (ticks >= 3 && ticks <= 6) return c.toDouble();
//     }
//     return candidates.last.toDouble();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final financialInfo = widget.currentProperty.propertyDetails?.financialInfo;
//
//     if (financialInfo == null ||
//         financialInfo.pricePast.isEmpty ||
//         financialInfo.priceFuture.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(24.0),
//           child: Text('No investment insight data available'),
//         ),
//       );
//     }
//
//     return Obx(() {
//       // Trigger rebuild when controller data changes
//       _matrixController.marketInsight.value;
//
//       final myPropertyData = _generateChartData(
//         past: financialInfo.pricePast,
//         future: financialInfo.priceFuture,
//       );
//
//       // Validate main property data
//       if (myPropertyData.isEmpty) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.all(24.0),
//             child: Text('Invalid property data'),
//           ),
//         );
//       }
//
//       // Collect all prices for axis calculation
//       List<num> allPrices = myPropertyData.map((e) => e.price).toList();
//
//       if (_comparisonType == 'locality') {
//         final localityData = _getLocalityChartData();
//         if (localityData.isNotEmpty) {
//           allPrices.addAll(localityData.map((e) => e.price));
//         }
//       } else if (_comparisonType == 'property') {
//         // Add property type average to prices
//         final propertyTypeData = _getPropertyTypeChartData();
//         if (propertyTypeData.isNotEmpty) {
//           allPrices.addAll(propertyTypeData.map((e) => e.price));
//         }
//
//         // Add selected properties prices
//         for (var prop in _selectedProperties) {
//           if (prop.chartData.isNotEmpty) {
//             allPrices.addAll(prop.chartData.map((e) => e.price));
//           }
//         }
//       }
//
//       // Ensure we have valid price data
//       if (allPrices.isEmpty) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.all(24.0),
//             child: Text('No price data available'),
//           ),
//         );
//       }
//
//       final minPrice = allPrices.reduce(min);
//       final maxPrice = allPrices.reduce(max);
//       final range = maxPrice - minPrice;
//
//       // Avoid division by zero
//       if (range <= 0) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.all(24.0),
//             child: Text('Invalid price range'),
//           ),
//         );
//       }
//
//       final yInterval = _calculateOptimalInterval(range.toDouble());
//       final minY =
//           ((minPrice - range * 0.05) ~/ yInterval * yInterval).toDouble();
//       final maxY =
//           ((maxPrice + range * 0.05) ~/ yInterval * yInterval + yInterval)
//               .toDouble();
//
//       // Calculate metrics with null safety
//       final pastStart = financialInfo.pricePast.first.pricePerSqft;
//       final pastEnd = financialInfo.pricePast.last.pricePerSqft;
//       final futureEnd = financialInfo.priceFuture.last.pricePerSqft;
//
//       final pastGrowth =
//           pastStart > 0 ? ((pastEnd - pastStart) / pastStart) * 100 : 0.0;
//       final futureROI =
//           pastEnd > 0 ? ((futureEnd - pastEnd) / pastEnd) * 100 : 0.0;
//
//       return _buildChartUI(
//         context,
//         myPropertyData,
//         minY,
//         maxY,
//         yInterval,
//         pastGrowth,
//         futureROI,
//       );
//     });
//   }
//
//   Widget _buildChartUI(
//     BuildContext context,
//     List<_ChartPoint> myPropertyData,
//     double minY,
//     double maxY,
//     double yInterval,
//     double pastGrowth,
//     double futureROI,
//   ) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Text(
//             'Compare price trends and forecast future returns',
//             style: TextStyle(fontSize: 12, color: ColorRes.leadGreyColor),
//           ),
//           const SizedBox(height: 24),
//
//           // Comparison Type Toggle
//           Row(
//             children: [
//               Expanded(
//                 child: _comparisonTypeButton(
//                   label: 'with Locality',
//                   icon: Icons.location_on,
//                   isSelected: _comparisonType == 'locality',
//                   onTap: () => setState(() => _comparisonType = 'locality'),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _comparisonTypeButton(
//                   label: 'with Properties',
//                   icon: Icons.home,
//                   isSelected: _comparisonType == 'property',
//                   onTap: () => setState(() => _comparisonType = 'property'),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//
//           Row(
//             children: [
//               if (widget
//                       .currentProperty
//                       .investmentInsightModel
//                       ?.priceTrend
//                       ?.growthPercentage5yr !=
//                   null)
//                 Expanded(
//                   child: _metricCard(
//                     title: '5 Year Growth',
//                     value:
//                         '${widget.currentProperty.investmentInsightModel!.priceTrend!.growthPercentage5yr!.toStringAsFixed(1)}%',
//                     icon: Icons.arrow_drop_up,
//                     color: ColorRes.green,
//                   ),
//                 ),
//               const SizedBox(width: 12),
//               if (widget
//                       .currentProperty
//                       .investmentInsightModel
//                       ?.priceTrend
//                       ?.cagrPercentage !=
//                   null)
//                 Expanded(
//                   child: _metricCard(
//                     title: 'CAGR',
//                     value:
//                         '${widget.currentProperty.investmentInsightModel!.priceTrend!.cagrPercentage!.toStringAsFixed(1)}%',
//                     // icon: Icons.show_chart,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//             ],
//           ),
//           SizedBox(height: 12),
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//           //     ),
//           //     SizedBox(width: 12),
//           //     Expanded(
//           //       child: Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//           //     ),
//           //   ],
//           // ),
//           // SizedBox(height: 12),
//           Row(
//             children: [
//               if (widget
//                       .currentProperty
//                       .investmentInsightModel
//                       ?.futureProjection
//                       ?.projectedPrice5yr !=
//                   null)
//                 Expanded(
//                   child: _metricCard(
//                     title: 'Projected Price',
//                     value:
//                         '${Formatter.formatPrice(widget.currentProperty.investmentInsightModel!.futureProjection!.projectedPrice5yr!)}',
//                     // icon: Icons.trending_up,
//                     color: Color(0xFF1073B9),
//                   ),
//                 ),
//               const SizedBox(width: 12),
//               if (widget
//                       .currentProperty
//                       .investmentInsightModel
//                       ?.futureProjection
//                       ?.roiPercentage5yr !=
//                   null)
//                 Expanded(
//                   child: _metricCard(
//                     title: 'Expected ROI',
//                     value:
//                         '${widget.currentProperty.investmentInsightModel!.futureProjection!.roiPercentage5yr}%',
//                     icon: Icons.arrow_drop_up,
//                     color: Color(0xFF5500FF),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 24),
//
//           // Filters
//           if (_comparisonType == 'locality') _buildLocalityFilters(),
//           if (_comparisonType == 'property')
//             _buildPropertyComparisonButton(
//               widget.currentProperty.id ?? '',
//               widget.currentProperty.city ?? '',
//             ),
//
//           const SizedBox(height: 24),
//
//           // Chart
//           Container(
//             height: 280,
//
//             child: LineChart(
//               LineChartData(
//                 minX: 0,
//                 maxX: (myPropertyData.length - 1).toDouble(),
//                 minY: minY,
//                 maxY: maxY,
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: false,
//                   horizontalInterval: yInterval,
//                   getDrawingHorizontalLine:
//                       (v) =>
//                           FlLine(color: Colors.grey.shade200, strokeWidth: 1),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 titlesData: _buildTitles(myPropertyData),
//                 lineTouchData: _buildTouch(myPropertyData),
//                 lineBarsData: _buildChartLines(myPropertyData),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Legend
//           _buildLegend(),
//
//           // Property Price Summary
//           _buildPriceSummary(),
//         ],
//       ),
//     );
//   }
//
//   // Widget _buildPriceSummary() {
//   //   final insight = widget.currentProperty.investmentInsightModel;
//   //   final cityName = widget.currentProperty.city ?? "";
//   //
//   //   return Container(
//   //     margin: const EdgeInsets.only(top: 24),
//   //     child: Column(
//   //       children: [
//   //         // --- Table Header ---
//   //         Padding(
//   //           padding: const EdgeInsets.only(bottom: 12.0),
//   //           child: Row(
//   //             children: [
//   //               _headerItem('With Locality'),
//   //               _headerItem('Current Price'),
//   //               _headerItem('Last 1 year'),
//   //               _headerItem('Last 5 years'),
//   //             ],
//   //           ),
//   //         ),
//   //         const Divider(height: 1),
//   //
//   //         // --- Row 1: My Property ---
//   //         _buildSummaryRow(
//   //           indicatorColor: ColorRes.primary,
//   //           currentPrice: insight?.priceTrend?.currentPrice,
//   //           growth1yr: null,
//   //           growth5yr: insight?.priceTrend?.growthPercentage5yr,
//   //         ),
//   //         const Divider(height: 1),
//   //
//   //         // --- Row 2: Average in City ---
//   //         // _buildSummaryRow(
//   //         //   title: 'Avg. in $cityName',
//   //         //   indicatorColor: ColorRes.green,
//   //         //   currentPrice: _matrixController.avgPriceInCity,
//   //         //   growth1yr: _matrixController.cityGrowth1yr,
//   //         //
//   //         //   growth5yr: _matrixController.cityGrowth5yr,
//   //         // ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   Widget _buildPriceSummary() {
//     /// My property summary
//     final myChart = _generateChartData(
//       past: widget.currentProperty.propertyDetails!.financialInfo!.pricePast,
//       future:
//           widget.currentProperty.propertyDetails!.financialInfo!.priceFuture,
//     );
//     final mySummary = _summaryFromChart(myChart);
//
//     /// Locality summary
//     final localitySummary =
//         _comparisonType == 'locality'
//             ? _summaryFromChart(_getLocalityChartData())
//             : null;
//
//     /// Property-type average summary
//     final propertyTypeSummary =
//         _comparisonType == 'property'
//             ? _summaryFromChart(_getPropertyTypeChartData())
//             : null;
//
//     return Container(
//       margin: const EdgeInsets.only(top: 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           // ───── Header ─────
//           SizedBox(height: 10),
//           Row(
//             children: [
//               _headerItem('', flex: 1),
//               _headerItem('Current Price', flex: 2),
//               _headerItem('Last 1 year', flex: 2),
//               _headerItem('Last 5 years', flex: 2),
//             ],
//           ),
//           SizedBox(height: 10),
//
//           Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//
//           // ───── My Property ─────
//           _buildSummaryRow(
//             indicatorColor: ColorRes.primary,
//             currentPrice: mySummary.current,
//             growth1yr: mySummary.oneYear,
//             growth5yr: mySummary.fiveYear,
//           ),
//
//           // ───── Locality Avg ─────
//           if (localitySummary != null) ...[
//             Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//             _buildSummaryRow(
//               indicatorColor: _comparisonColors[0],
//               currentPrice: localitySummary.current,
//               growth1yr: localitySummary.oneYear,
//               growth5yr: localitySummary.fiveYear,
//             ),
//           ],
//
//           // ───── Property Type Avg ─────
//           if (propertyTypeSummary != null) ...[
//             Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//
//             _buildSummaryRow(
//               indicatorColor: _comparisonColors[0],
//               currentPrice: propertyTypeSummary.current,
//               growth1yr: propertyTypeSummary.oneYear,
//               growth5yr: propertyTypeSummary.fiveYear,
//             ),
//           ],
//
//           // ───── Selected Properties ─────
//           if (_comparisonType == 'property' && _selectedProperties.isNotEmpty)
//             ..._selectedProperties.asMap().entries.map((entry) {
//               final index = entry.key;
//               final prop = entry.value;
//               final summary = _summaryFromChart(prop.chartData);
//
//               return Column(
//                 children: [
//                   Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
//                   _buildSummaryRow(
//                     indicatorColor:
//                         _comparisonColors[(index + 1) %
//                             _comparisonColors.length],
//                     currentPrice: summary.current,
//                     growth1yr: summary.oneYear,
//                     growth5yr: summary.fiveYear,
//                   ),
//                 ],
//               );
//             }),
//         ],
//       ),
//     );
//   }
//
//   /// Reusable Row Component
//   Widget _buildSummaryRow({
//     required Color indicatorColor,
//     num? currentPrice,
//     double? growth1yr,
//     double? growth5yr,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         children: [
//           // Title Column with Legend Dot
//           Expanded(
//             flex: 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Container(
//                   width: 10,
//                   height: 10,
//                   margin: EdgeInsets.only(left: 10),
//                   decoration: BoxDecoration(
//                     color: indicatorColor,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Current Price Column
//           Expanded(
//             flex: 2,
//             child: Text(
//               currentPrice != null ? '₹$currentPrice' : '--',
//               style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
//             ),
//           ),
//
//           // Growth Columns
//           Expanded(flex: 2, child: _growthValue(growth1yr)),
//           Expanded(flex: 2, child: _growthValue(growth5yr)),
//         ],
//       ),
//     );
//   }
//
//   /// Helper for Header Text
//   Widget _headerItem(String label, {int flex = 2}) {
//     return Expanded(
//       flex: flex,
//       child: Text(
//         label,
//         style: TextStyle(
//           color: ColorRes.leadGreyColor.shade800,
//           fontSize: 11,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   /// Helper for Growth Formatting (Icon + Text)
//   Widget _growthValue(double? value) {
//     if (value == null || value == 0) {
//       return const Text(
//         "--",
//         style: TextStyle(color: Colors.grey, fontSize: 13),
//         textAlign: TextAlign.center,
//       );
//     }
//     final bool isPositive = value >= 0;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//           size: 20,
//           color: isPositive ? ColorRes.green : ColorRes.error,
//         ),
//         Text(
//           '${value.abs().toStringAsFixed(1)}%',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: isPositive ? ColorRes.green : ColorRes.error,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _comparisonTypeButton({
//     required String label,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? ColorRes.primary : Colors.grey[100],
//           borderRadius: BorderRadius.circular(12),
//           boxShadow:
//               isSelected
//                   ? [
//                     BoxShadow(
//                       color: ColorRes.primary.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                   : null,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 20,
//               color: isSelected ? Colors.white : Colors.grey[700],
//             ),
//             const SizedBox(width: 8),
//             Flexible(
//               child: Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: isSelected ? Colors.white : Colors.grey[700],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _metricCard({
//     required String title,
//     required String value,
//     IconData? icon,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: color,
//                 ),
//               ),
//               if (icon != null) ...[Icon(icon, color: color, size: 24)],
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocalityFilters() {
//     return Obx(() {
//       if (_matrixController.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       }
//
//       final buyData = _matrixController.buyData;
//       if (buyData == null || buyData.isEmpty) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.orange.shade50,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             'No locality data available for comparison',
//             style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
//           ),
//         );
//       }
//
//       // Get available locations
//       final locations = <String>[];
//       for (var stateData in buyData.values) {
//         for (var cityLocations in stateData.values) {
//           for (var loc in cityLocations) {
//             if (!locations.contains(loc.location)) {
//               locations.add(loc.location);
//             }
//           }
//         }
//       }
//
//       // Get available property types for selected location
//       final propertyTypes = <String>[];
//       if (_selectedLocation != null) {
//         final propTypeData = _getPropertyTypeData();
//         if (propTypeData != null) {
//           propertyTypes.addAll(
//             _matrixController.buyData!.values
//                 .expand((state) => state.values)
//                 .expand((city) => city)
//                 .where((loc) => loc.location == _selectedLocation)
//                 .expand((loc) => loc.propertyTypes.keys),
//           );
//         }
//       }
//       return SizedBox.shrink();
//     });
//   }
//
//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF6B7280),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               items:
//                   items
//                       .map(
//                         (item) => DropdownMenuItem(
//                           value: item,
//                           child: Text(
//                             item,
//                             style: const TextStyle(fontSize: 14),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       )
//                       .toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPropertyComparisonButton(String propertyId, String city) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () => _showPropertySelectionSheet(propertyId, city),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: ColorRes.primary,
//             foregroundColor: Colors.white,
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: Text(
//             _selectedProperties.isEmpty
//                 ? 'Select Properties to Compare'
//                 : 'Comparing with ${_selectedProperties.length} ${_selectedProperties.length == 1 ? 'property' : 'properties'}',
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//           ),
//         ),
//         // if (_selectedProperties.length >= _maxSelection)
//         //   Padding(
//         //     padding: const EdgeInsets.only(top: 8),
//         //     child: Text(
//         //       'Maximum $_maxSelection properties can be compared',
//         //       style: const TextStyle(fontSize: 12, color: Color(0xFFFF9800)),
//         //     ),
//         //   ),
//       ],
//     );
//   }
//
//   List<LineChartBarData> _buildChartLines(List<_ChartPoint> myPropertyData) {
//     final lines = <LineChartBarData>[];
//
//     // Main property line (always shown)
//     lines.add(_buildMainPropertyLine(myPropertyData));
//
//     if (_comparisonType == 'locality') {
//       // Add locality comparison line - shows city average
//       final localityData = _getLocalityChartData();
//       if (localityData.isNotEmpty) {
//         lines.add(
//           _buildComparisonLine(
//             localityData,
//             _comparisonColors[0],
//             isDashed: true,
//           ),
//         );
//       }
//     } else if (_comparisonType == 'property') {
//       // Check if we have property type data - shows average by property type
//       final propertyTypeData = _getPropertyTypeChartData();
//       if (propertyTypeData.isNotEmpty) {
//         lines.add(
//           _buildComparisonLine(
//             propertyTypeData,
//             _comparisonColors[0],
//             isDashed: true,
//           ),
//         );
//       }
//
//       // Add all selected property lines with null safety
//       for (int i = 0; i < _selectedProperties.length; i++) {
//         final chartData = _selectedProperties[i].chartData;
//         if (chartData.isNotEmpty) {
//           lines.add(
//             _buildComparisonLine(
//               chartData,
//               _comparisonColors[(i + 1) % _comparisonColors.length],
//               isDashed: false,
//             ),
//           );
//         }
//       }
//     }
//
//     return lines;
//   }
//
//   LineChartBarData _buildMainPropertyLine(List<_ChartPoint> data) {
//     return LineChartBarData(
//       isCurved: true,
//       curveSmoothness: 0.35,
//       barWidth: 3,
//       color: const Color(0xFF3B82F6),
//       belowBarData: BarAreaData(
//         show: true,
//         color: const Color(0xFF3B82F6).withOpacity(0.1),
//       ),
//       dotData: const FlDotData(show: false),
//       spots: [
//         for (int i = 0; i < data.length; i++)
//           FlSpot(i.toDouble(), data[i].price.toDouble()),
//       ],
//     );
//   }
//
//   LineChartBarData _buildComparisonLine(
//     List<_ChartPoint> data,
//     Color color, {
//     bool isDashed = false,
//   }) {
//     return LineChartBarData(
//       isCurved: true,
//       curveSmoothness: 0.35,
//       barWidth: 2.5,
//       color: color,
//       dashArray: isDashed ? [5, 5] : null,
//       belowBarData: BarAreaData(show: false),
//       dotData: const FlDotData(show: false),
//       spots: [
//         for (int i = 0; i < data.length; i++)
//           FlSpot(i.toDouble(), data[i].price.toDouble()),
//       ],
//     );
//   }
//
//   FlTitlesData _buildTitles(List<_ChartPoint> data) {
//     return FlTitlesData(
//       show: true,
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 45,
//           getTitlesWidget: (value, meta) {
//             return Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: Text(
//                 _formatCurrency(value),
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           reservedSize: 28,
//           getTitlesWidget: (value, meta) {
//             final index = value.round();
//             if (index < 0 || index >= data.length) {
//               return const SizedBox.shrink();
//             }
//             final point = data[index];
//             return Padding(
//               padding: const EdgeInsets.only(top: 8),
//               child: Text(
//                 point.year.toString(),
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                   color: point.isPast ? Colors.grey[700] : Colors.grey[500],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//     );
//   }
//
//   LineTouchData _buildTouch(List<_ChartPoint> data) {
//     return LineTouchData(
//       touchTooltipData: LineTouchTooltipData(
//         getTooltipItems: (spots) {
//           return spots.map((s) {
//             final lineIndex = s.barIndex;
//             String label = 'My Property';
//             Color color = const Color(0xFF3B82F6);
//
//             if (_comparisonType == 'locality' && lineIndex == 1) {
//               label = '${_matrixController.city} Avg';
//               color = _comparisonColors[0];
//             } else if (_comparisonType == 'property') {
//               if (lineIndex == 1) {
//                 // First comparison line is property type average
//                 label = '${_matrixController.propertyType} Avg';
//                 color = _comparisonColors[0];
//               } else if (lineIndex > 1 &&
//                   lineIndex - 2 < _selectedProperties.length) {
//                 // Other lines are selected properties
//                 final propIndex = lineIndex - 2;
//                 label = _selectedProperties[propIndex].title;
//                 color =
//                     _comparisonColors[(propIndex + 1) %
//                         _comparisonColors.length];
//               }
//             }
//
//             return LineTooltipItem(
//               '$label\n${_formatCurrencyFull(s.y)}',
//               const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             );
//           }).toList();
//         },
//       ),
//     );
//   }
//
//   Widget _buildLegend() {
//     final items = <Widget>[
//       _legendItem(
//         label: 'My Property',
//         color: ColorRes.primary,
//         isPrimary: true,
//       ),
//     ];
//
//     if (_comparisonType == 'locality') {
//       items.add(
//         _legendItem(
//           label: '${_matrixController.city} Avg',
//           color: _comparisonColors[0],
//         ),
//       );
//     }
//
//     if (_comparisonType == 'property') {
//       items.add(
//         _legendItem(
//           label: '${_matrixController.propertyType} Avg',
//           color: _comparisonColors[0],
//         ),
//       );
//
//       items.addAll(
//         _selectedProperties.asMap().entries.map((entry) {
//           return _legendItem(
//             label: entry.value.title,
//             color:
//                 _comparisonColors[(entry.key + 1) % _comparisonColors.length],
//           );
//         }),
//       );
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Wrap(
//         spacing: 12,
//         runSpacing: 10,
//         alignment: WrapAlignment.start,
//         children: items,
//       ),
//     );
//   }
//
//   Widget _legendItem({
//     required String label,
//     required Color color,
//     bool isPrimary = false,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Color dot
//         Container(
//           width: isPrimary ? 10 : 8,
//           height: isPrimary ? 10 : 8,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 8),
//
//         // Label
//         Flexible(
//           child: Text(
//             label,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontSize: 12.5,
//               fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
//               color: Theme.of(Get.context!).textTheme.bodyMedium!.color,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showPropertySelectionSheet(String propertyId, String city) {
//     final controller = Get.put(
//       InsightsPropertyController(city: city),
//       tag: 'Matrix_$propertyId',
//     );
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.85,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             children: [
//               /// ───────── Header ─────────
//               Obx(() {
//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey.shade200),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       const Text(
//                         'Compare Properties',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       if (controller.selectedPropertyIds.isNotEmpty)
//                         TextButton(
//                           onPressed: () {
//                             // Clear controller selections
//                             controller.clearSelection();
//                             // Clear widget state and trigger rebuild
//                             setState(() {
//                               _selectedProperties.clear();
//                             });
//                             Get.back();
//                           },
//                           child: const Text('Clear All'),
//                         ),
//                       IconButton(
//                         onPressed: () => Get.back(),
//                         icon: const Icon(Icons.close),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//
//               // if (_selectedProperties.length >= _maxSelection)
//               Container(
//                 margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
//                 padding: const EdgeInsets.all(12),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
//                 ),
//                 child: Text(
//                   'Maximum $_maxSelection properties can be compared',
//                   style: TextStyle(fontSize: 12, color: ColorRes.primary),
//                 ),
//               ),
//
//               /// ───────── Property List ─────────
//               Expanded(
//                 child: Obx(() {
//                   /// Initial loading
//                   if (controller.isLoading.value && controller.items.isEmpty) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   /// Empty state
//                   if (controller.items.isEmpty) {
//                     return const Center(child: Text('No properties found'));
//                   }
//
//                   return NotificationListener<ScrollNotification>(
//                     onNotification: (scroll) {
//                       if (scroll.metrics.pixels >=
//                               scroll.metrics.maxScrollExtent - 200 &&
//                           controller.hasMore.value &&
//                           !controller.isPaging.value) {
//                         controller.loadMore();
//                       }
//                       return false;
//                     },
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(16),
//                       itemCount:
//                           controller.items.length +
//                           (controller.isPaging.value ? 1 : 0),
//                       itemBuilder: (_, index) {
//                         if (index >= controller.items.length) {
//                           return const Padding(
//                             padding: EdgeInsets.all(12),
//                             child: Center(child: CircularProgressIndicator()),
//                           );
//                         }
//
//                         final item = controller.items[index];
//
//                         if (item.id == propertyId) {
//                           return SizedBox.shrink();
//                         }
//
//                         return Obx(() {
//                           final isSelected = controller.selectedPropertyIds
//                               .contains(item.id);
//                           final canSelect =
//                               isSelected ||
//                               controller.selectedPropertyIds.length <
//                                   _maxSelection;
//
//                           final hasImage =
//                               item.propertyMedia?.images?.isNotEmpty ?? false;
//
//                           return Opacity(
//                             opacity: canSelect ? 1.0 : 0.5,
//                             child: Card(
//                               margin: const EdgeInsets.only(bottom: 12),
//                               child: ListTile(
//                                 leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: CustomImage(
//                                     type:
//                                         hasImage
//                                             ? CustomImageType.network
//                                             : CustomImageType.asset,
//                                     src:
//                                         hasImage
//                                             ? item.propertyMedia!.images!.first
//                                             : null,
//                                     height: 60,
//                                     width: 60,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 title: Text(
//                                   PropertyNameManager(item).displayName ?? '',
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(item.city ?? ''),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       PropertyPriceManager(
//                                         listingType: item.listingType!,
//                                         financialInfo:
//                                             item.propertyDetails?.financialInfo,
//                                       ).displayPrice,
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14,
//                                         color: ColorRes.primary,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Checkbox(
//                                   value: isSelected,
//                                   onChanged:
//                                       canSelect
//                                           ? (_) => controller.toggleSelection(
//                                             item.id ?? '',
//                                           )
//                                           : null,
//                                 ),
//                                 onTap:
//                                     canSelect
//                                         ? () => controller.toggleSelection(
//                                           item.id ?? '',
//                                         )
//                                         : null,
//                               ),
//                             ),
//                           );
//                         });
//                       },
//                     ),
//                   );
//                 }),
//               ),
//
//               /// ───────── Done Button ─────────
//               Obx(() {
//                 final count = controller.selectedPropertyIds.length;
//
//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, -5),
//                       ),
//                     ],
//                   ),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Convert selected property IDs to ComparisonProperty objects
//                       _selectedProperties.clear();
//
//                       try {
//                         for (var propertyId in controller.selectedPropertyIds) {
//                           final property = controller.items.firstWhereOrNull(
//                             (item) => item.id == propertyId,
//                           );
//
//                           if (property != null &&
//                               property.propertyDetails?.financialInfo != null) {
//                             final financialInfo =
//                                 property.propertyDetails!.financialInfo!;
//
//                             // Validate financial data
//                             if (financialInfo.pricePast.isEmpty ||
//                                 financialInfo.priceFuture.isEmpty) {
//                               continue; // Skip properties with incomplete data
//                             }
//
//                             // Generate chart data for this property
//                             final chartData = _generateChartData(
//                               past: financialInfo.pricePast,
//                               future: financialInfo.priceFuture,
//                             );
//
//                             // Validate chart data
//                             if (chartData.isEmpty) {
//                               continue; // Skip if chart data generation failed
//                             }
//
//                             // Calculate average price
//                             final avgPrice =
//                                 financialInfo.pricePast.isNotEmpty
//                                     ? financialInfo.pricePast.last.pricePerSqft
//                                     : 0;
//
//                             _selectedProperties.add(
//                               ComparisonProperty(
//                                 id: property.id ?? '',
//                                 title:
//                                     PropertyNameManager(property).displayName ??
//                                     'Property',
//                                 chartData: chartData,
//                                 avgPrice: avgPrice,
//                                 propertyType: property.propertyType ?? '',
//                               ),
//                             );
//                           }
//                         }
//                       } catch (e) {
//                         print('Error converting properties: $e');
//                         // Show error message to user
//                         Get.snackbar(
//                           'Error',
//                           'Failed to load some properties',
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       }
//
//                       setState(() {}); // Refresh the main chart
//                       Get.back();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3B82F6),
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: Text(
//                       count == 0 ? 'Done' : 'Show Comparison ($count)',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class PriceSummary {
//   final num? current;
//   final double? oneYear;
//   final double? fiveYear;
//
//   PriceSummary({this.current, this.oneYear, this.fiveYear});
// }
//
// PriceSummary _summaryFromChart(List<_ChartPoint> points) {
//   final past = points.where((e) => e.isPast).toList();
//   if (past.length < 2) return PriceSummary();
//
//   return PriceSummary(
//     current: past.last.price,
//     oneYear: _growth(past[past.length - 2].price, past.last.price),
//     fiveYear:
//         past.length >= 5 ? _growth(past.first.price, past.last.price) : null,
//   );
// }
//
// double? _growth(num? start, num? end) {
//   if (start == null || end == null || start == 0) return null;
//   return ((end - start) / start) * 100;
// }

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';
import 'package:housing_flutter_app/app/manager/property/property_name_manager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/app/widgets/image/custom_image.dart'
    hide ColorRes;
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:intl/intl.dart';

// Import your models
import '../../../../app/manager/property/property_pricemanager.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../data/network/location_price_matrix/model/location_price_matrix_model.dart';
import '../../../location_price_matrix/controllers/location_price_matrix_controller.dart';
import '../../controllers/insights_property_controller.dart';

class _ChartPoint {
  final int year;
  final num price;
  final bool isPast;

  _ChartPoint(this.year, this.price, this.isPast);
}

class ComparisonProperty {
  final String id;
  final String title;
  final List<_ChartPoint> chartData;
  final num avgPrice;
  final String propertyType;

  ComparisonProperty({
    required this.id,
    required this.title,
    required this.chartData,
    required this.avgPrice,
    required this.propertyType,
  });
}

class InvestmentInsightChart extends StatefulWidget {
  final Items currentProperty;

  const InvestmentInsightChart({super.key, required this.currentProperty});

  @override
  State<InvestmentInsightChart> createState() => _InvestmentInsightChartState();
}

class _InvestmentInsightChartState extends State<InvestmentInsightChart> {
  // --- FIX START: Use late and find by tag ---
  late final LocationPriceMatrixController _matrixController;

  String _comparisonType = 'locality'; // 'locality' or 'property'
  String? _selectedLocation;
  String? _selectedPropertyType;
  final List<ComparisonProperty> _selectedProperties = [];
  final int _maxSelection = 2;

  final List<Color> _comparisonColors = [
    ColorRes.error, // Red
    ColorRes.leadTealColor, // Teal
    ColorRes.homeYellow, // Yellow
  ];

  @override
  void initState() {
    super.initState();

    // Find the specific controller instance for this property ID
    _matrixController = Get.find<LocationPriceMatrixController>(
      tag: 'matrix_${widget.currentProperty.id}',
    );

    _initializeDefaults();
  }

  // --- FIX END ---

  void _initializeDefaults() {
    _selectedLocation = widget.currentProperty.location;
    _selectedPropertyType = widget.currentProperty.propertyType;
  }

  String _formatCurrency(num value) {
    return NumberFormat.compactCurrency(
      symbol: '₹',
      decimalDigits: 1,
    ).format(value);
  }

  String _formatCurrencyFull(num value) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(value);
  }

  List<_ChartPoint> _generateChartData({
    required List<PropertyPriceYear> past,
    required List<PropertyPriceYear> future,
    required PropertyPriceYear current,
  }) {
    final List<_ChartPoint> data = [];

    // Sort and add past data
    final sortedPast = List<PropertyPriceYear>.from(past)
      ..sort((a, b) => a.year.compareTo(b.year));

    for (final p in sortedPast) {
      data.add(_ChartPoint(p.year, p.pricePerSqft, true));
    }

    data.add(_ChartPoint(current.year, current.pricePerSqft, true));

    // Sort and add future data
    final sortedFuture = List<PropertyPriceYear>.from(future)
      ..sort((a, b) => a.year.compareTo(b.year));

    for (final f in sortedFuture) {
      data.add(_ChartPoint(f.year, f.pricePerSqft, false));
    }

    return data;
  }

  PropertyTypeData? _getPropertyTypeData() {
    if (_selectedLocation == null || _selectedPropertyType == null) return null;

    final buyData = _matrixController.buyData;
    if (buyData == null) return null;

    // Search through all states and cities
    for (var stateData in buyData.values) {
      for (var cityLocations in stateData.values) {
        for (var locationData in cityLocations) {
          // Match location (case-insensitive, partial match)
          if (locationData.location.toLowerCase().contains(
                _selectedLocation!.toLowerCase(),
              ) ||
              _selectedLocation!.toLowerCase().contains(
                locationData.location.toLowerCase(),
              )) {
            // Return property type data if exists
            final propTypeData =
                locationData.propertyTypes[_selectedPropertyType];
            if (propTypeData != null) {
              return propTypeData;
            }
          }
        }
      }
    }

    return null;
  }

  /// Get locality chart data - shows average by city for the current locality
  List<_ChartPoint> _getLocalityChartData() {
    final cityAvgPriceTrend = _matrixController.getAvgPriceTrendByCity();
    if (cityAvgPriceTrend == null || cityAvgPriceTrend.isEmpty) return [];

    return cityAvgPriceTrend
        .map(
          (trend) => _ChartPoint(
            trend.year,
            trend.avgPricePerSqFt,
            trend.year <= DateTime.now().year,
          ),
        )
        .toList()
      ..sort((a, b) => a.year.compareTo(b.year));
  }

  /// Get property type chart data - shows average by property type in the state
  List<_ChartPoint> _getPropertyTypeChartData() {
    final propertyTypeData = _matrixController.getAvgPriceTrendByPropertyType();
    if (propertyTypeData == null || propertyTypeData.isEmpty) return [];

    return propertyTypeData
        .map(
          (trend) => _ChartPoint(
            trend.year,
            trend.avgPricePerSqFt,
            trend.year <= DateTime.now().year,
          ),
        )
        .toList()
      ..sort((a, b) => a.year.compareTo(b.year));
  }

  double _calculateOptimalInterval(double range) {
    if (range <= 0) return 100000;
    final magnitude = pow(10, (log(range / 4) / log(10)).floor());
    final candidates = [
      magnitude,
      magnitude * 2,
      magnitude * 5,
      magnitude * 10,
    ];
    for (final c in candidates) {
      final ticks = range / c;
      if (ticks >= 3 && ticks <= 6) return c.toDouble();
    }
    return candidates.last.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final financialInfo = widget.currentProperty.propertyDetails?.financialInfo;

    if (financialInfo == null ||
        financialInfo.pricePast.isEmpty ||
        financialInfo.priceFuture.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No investment insight data available'),
        ),
      );
    }

    return Obx(() {
      // Trigger rebuild when controller data changes
      _matrixController.marketInsight.value;

      final myPropertyData = _generateChartData(
        past: financialInfo.pricePast,
        future: financialInfo.priceFuture,
        current: PropertyPriceYear(
          year: DateTime.parse(widget.currentProperty.createdAt!).year,
          price: widget.currentProperty.propertyDetails!.financialInfo!.price,
          pricePerSqft:
              widget
                  .currentProperty
                  .propertyDetails!
                  .financialInfo!
                  .pricePerSqft,
        ),
      );

      // Validate main property data
      if (myPropertyData.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Invalid property data'),
          ),
        );
      }

      // Collect all prices for axis calculation
      List<num> allPrices = myPropertyData.map((e) => e.price).toList();

      if (_comparisonType == 'locality') {
        final localityData = _getLocalityChartData();
        if (localityData.isNotEmpty) {
          allPrices.addAll(localityData.map((e) => e.price));
        }
      } else if (_comparisonType == 'property') {
        // Add property type average to prices
        final propertyTypeData = _getPropertyTypeChartData();
        if (propertyTypeData.isNotEmpty) {
          allPrices.addAll(propertyTypeData.map((e) => e.price));
        }

        // Add selected properties prices
        for (var prop in _selectedProperties) {
          if (prop.chartData.isNotEmpty) {
            allPrices.addAll(prop.chartData.map((e) => e.price));
          }
        }
      }

      // Ensure we have valid price data
      if (allPrices.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No price data available'),
          ),
        );
      }

      final minPrice = allPrices.reduce(min);
      final maxPrice = allPrices.reduce(max);
      final range = maxPrice - minPrice;

      // Avoid division by zero
      if (range <= 0) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Invalid price range'),
          ),
        );
      }

      final yInterval = _calculateOptimalInterval(range.toDouble());
      final minY =
          ((minPrice - range * 0.05) ~/ yInterval * yInterval).toDouble();
      final maxY =
          ((maxPrice + range * 0.05) ~/ yInterval * yInterval + yInterval)
              .toDouble();

      // Calculate metrics with null safety
      final pastStart = financialInfo.pricePast.first.pricePerSqft;
      final pastEnd = financialInfo.pricePast.last.pricePerSqft;
      final futureEnd = financialInfo.priceFuture.last.pricePerSqft;

      final pastGrowth =
          pastStart > 0 ? ((pastEnd - pastStart) / pastStart) * 100 : 0.0;
      final futureROI =
          pastEnd > 0 ? ((futureEnd - pastEnd) / pastEnd) * 100 : 0.0;

      return _buildChartUI(
        context,
        myPropertyData,
        minY,
        maxY,
        yInterval,
        pastGrowth,
        futureROI,
      );
    });
  }

  Widget _buildChartUI(
    BuildContext context,
    List<_ChartPoint> myPropertyData,
    double minY,
    double maxY,
    double yInterval,
    double pastGrowth,
    double futureROI,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Compare price trends and forecast future returns',
            style: TextStyle(fontSize: 12, color: ColorRes.leadGreyColor),
          ),
          const SizedBox(height: 24),

          // Comparison Type Toggle
          Row(
            children: [
              Expanded(
                child: _comparisonTypeButton(
                  label: 'with Locality',
                  icon: Icons.location_on,
                  isSelected: _comparisonType == 'locality',
                  onTap: () => setState(() => _comparisonType = 'locality'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _comparisonTypeButton(
                  label: 'with Properties',
                  icon: Icons.home,
                  isSelected: _comparisonType == 'property',
                  onTap: () => setState(() => _comparisonType = 'property'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              if (widget
                      .currentProperty
                      .investmentInsightModel
                      ?.priceTrend
                      ?.growthPercentage5yr !=
                  null)
                Expanded(
                  child: _metricCard(
                    title: '5 Year Growth',
                    value:
                        '${widget.currentProperty.investmentInsightModel!.priceTrend!.growthPercentage5yr!.toStringAsFixed(1)}%',
                    icon: Icons.arrow_drop_up,
                    color: ColorRes.green,
                  ),
                ),
              const SizedBox(width: 12),
              if (widget
                      .currentProperty
                      .investmentInsightModel
                      ?.priceTrend
                      ?.cagrPercentage !=
                  null)
                Expanded(
                  child: _metricCard(
                    title: 'CAGR',
                    value:
                        '${widget.currentProperty.investmentInsightModel!.priceTrend!.cagrPercentage!.toStringAsFixed(1)}%',
                    // icon: Icons.show_chart,
                    color: ColorRes.primary,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
          //     ),
          //     SizedBox(width: 12),
          //     Expanded(
          //       child: Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 12),
          Row(
            children: [
              if (widget
                      .currentProperty
                      .investmentInsightModel
                      ?.futureProjection
                      ?.projectedPrice5yr !=
                  null)
                Expanded(
                  child: _metricCard(
                    title: 'Projected Price',
                    value:
                        '${Formatter.formatPrice(widget.currentProperty.investmentInsightModel!.futureProjection!.projectedPrice5yr!)}',
                    // icon: Icons.trending_up,
                    color: Color(0xFF1073B9),
                  ),
                ),
              const SizedBox(width: 12),
              if (widget
                      .currentProperty
                      .investmentInsightModel
                      ?.futureProjection
                      ?.roiPercentage5yr !=
                  null)
                Expanded(
                  child: _metricCard(
                    title: 'Expected ROI',
                    value:
                        '${widget.currentProperty.investmentInsightModel!.futureProjection!.roiPercentage5yr}%',
                    icon: Icons.arrow_drop_up,
                    color: Color(0xFF5500FF),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Filters
          if (_comparisonType == 'locality') _buildLocalityFilters(),
          if (_comparisonType == 'property')
            _buildPropertyComparisonButton(
              widget.currentProperty.id ?? '',
              widget.currentProperty.location ?? '',
            ),

          const SizedBox(height: 24),

          // Chart
          Container(
            height: 280,

            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (myPropertyData.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: yInterval,
                  getDrawingHorizontalLine:
                      (v) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: _buildTitles(myPropertyData),
                lineTouchData: _buildTouch(myPropertyData),
                lineBarsData: _buildChartLines(myPropertyData),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          _buildLegend(),

          // Property Price Summary
          _buildPriceSummary(),
        ],
      ),
    );
  }

  // Widget _buildPriceSummary() {
  //   final insight = widget.currentProperty.investmentInsightModel;
  //   final cityName = widget.currentProperty.city ?? "";
  //
  //   return Container(
  //     margin: const EdgeInsets.only(top: 24),
  //     child: Column(
  //       children: [
  //         // --- Table Header ---
  //         Padding(
  //           padding: const EdgeInsets.only(bottom: 12.0),
  //           child: Row(
  //             children: [
  //               _headerItem('With Locality'),
  //               _headerItem('Current Price'),
  //               _headerItem('Last 1 year'),
  //               _headerItem('Last 5 years'),
  //             ],
  //           ),
  //         ),
  //         const Divider(height: 1),
  //
  //         // --- Row 1: My Property ---
  //         _buildSummaryRow(
  //           indicatorColor: ColorRes.primary,
  //           currentPrice: insight?.priceTrend?.currentPrice,
  //           growth1yr: null,
  //           growth5yr: insight?.priceTrend?.growthPercentage5yr,
  //         ),
  //         const Divider(height: 1),
  //
  //         // --- Row 2: Average in City ---
  //         // _buildSummaryRow(
  //         //   title: 'Avg. in $cityName',
  //         //   indicatorColor: ColorRes.green,
  //         //   currentPrice: _matrixController.avgPriceInCity,
  //         //   growth1yr: _matrixController.cityGrowth1yr,
  //         //
  //         //   growth5yr: _matrixController.cityGrowth5yr,
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPriceSummary() {
    /// My property summary
    final myChart = _generateChartData(
      past: widget.currentProperty.propertyDetails!.financialInfo!.pricePast,
      future:
          widget.currentProperty.propertyDetails!.financialInfo!.priceFuture,
      current: PropertyPriceYear(
        year: DateTime.parse(widget.currentProperty.createdAt!).year,
        price: widget.currentProperty.propertyDetails!.financialInfo!.price,
        pricePerSqft:
            widget.currentProperty.propertyDetails!.financialInfo!.pricePerSqft,
      ),
    );
    final mySummary = _summaryFromChart(myChart);

    /// Locality summary
    final localitySummary =
        _comparisonType == 'locality'
            ? _summaryFromChart(_getLocalityChartData())
            : null;

    /// Property-type average summary
    final propertyTypeSummary =
        _comparisonType == 'property'
            ? _summaryFromChart(_getPropertyTypeChartData())
            : null;

    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // ───── Header ─────
          SizedBox(height: 10),
          Row(
            children: [
              _headerItem('', flex: 1),
              _headerItem('Current Price', flex: 2),
              _headerItem('Last 1 year', flex: 2),
              _headerItem('Last 5 years', flex: 2),
            ],
          ),
          SizedBox(height: 10),

          Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),

          // ───── My Property ─────
          _buildSummaryRow(
            indicatorColor: ColorRes.primary,
            currentPrice: mySummary.current,
            growth1yr: widget.currentProperty.oneYearGrowth,
            growth5yr: widget.currentProperty.fiveYearGrowth,
          ),

          // ───── Locality Avg ─────
          if (localitySummary != null) ...[
            Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
            _buildSummaryRow(
              indicatorColor: _comparisonColors[0],
              currentPrice: localitySummary.current,
              growth1yr: _matrixController.buyDataByCity?.first.oneYearGrowth,
              growth5yr: _matrixController.buyDataByCity?.first.fiveYearGrowth,
            ),
          ],

          // ───── Property Type Avg ─────
          if (propertyTypeSummary != null) ...[
            Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),

            _buildSummaryRow(
              indicatorColor: _comparisonColors[0],
              currentPrice: propertyTypeSummary.current,
              growth1yr: propertyTypeSummary.oneYear,
              growth5yr: propertyTypeSummary.fiveYear,
            ),
          ],

          // ───── Selected Properties ─────
          if (_comparisonType == 'property' && _selectedProperties.isNotEmpty)
            ..._selectedProperties.asMap().entries.map((entry) {
              final index = entry.key;
              final prop = entry.value;
              final summary = _summaryFromChart(prop.chartData);

              return Column(
                children: [
                  Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
                  _buildSummaryRow(
                    indicatorColor:
                        _comparisonColors[(index + 1) %
                            _comparisonColors.length],
                    currentPrice: summary.current,
                    growth1yr: summary.oneYear,
                    growth5yr: summary.fiveYear,
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }

  /// Reusable Row Component
  Widget _buildSummaryRow({
    required Color indicatorColor,
    num? currentPrice,
    double? growth1yr,
    double? growth5yr,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          // Title Column with Legend Dot
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

          // Current Price Column
          Expanded(
            flex: 2,
            child: Text(
              currentPrice != null ? '₹$currentPrice' : '--',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),

          // Growth Columns
          Expanded(flex: 2, child: _growthValue(growth1yr)),
          Expanded(flex: 2, child: _growthValue(growth5yr)),
        ],
      ),
    );
  }

  /// Helper for Header Text
  Widget _headerItem(String label, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          color: ColorRes.leadGreyColor.shade800,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Helper for Growth Formatting (Icon + Text)
  Widget _growthValue(double? value) {
    if (value == null) {
      return const Text(
        "--",
        style: TextStyle(color: Colors.grey, fontSize: 13),
        textAlign: TextAlign.center,
      );
    }
    final bool isPositive = value >= 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          size: 20,
          color: isPositive ? ColorRes.green : ColorRes.error,
        ),
        Text(
          '${value.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isPositive ? ColorRes.green : ColorRes.error,
          ),
        ),
      ],
    );
  }

  Widget _comparisonTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? ColorRes.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: ColorRes.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    IconData? icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              if (icon != null) ...[Icon(icon, color: color, size: 24)],
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildLocalityFilters() {
    return Obx(() {
      if (_matrixController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final buyData = _matrixController.buyData;
      if (buyData == null || buyData.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'No locality data available for comparison',
            style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
          ),
        );
      }

      // Get available locations
      final locations = <String>[];
      for (var stateData in buyData.values) {
        for (var cityLocations in stateData.values) {
          for (var loc in cityLocations) {
            if (!locations.contains(loc.location)) {
              locations.add(loc.location);
            }
          }
        }
      }

      // Get available property types for selected location
      final propertyTypes = <String>[];
      if (_selectedLocation != null) {
        final propTypeData = _getPropertyTypeData();
        if (propTypeData != null) {
          propertyTypes.addAll(
            _matrixController.buyData!.values
                .expand((state) => state.values)
                .expand((city) => city)
                .where((loc) => loc.location == _selectedLocation)
                .expand((loc) => loc.propertyTypes.keys),
          );
        }
      }
      return SizedBox.shrink();
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items:
                  items
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyComparisonButton(String propertyId, String location) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showPropertySelectionSheet(propertyId, location),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorRes.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _selectedProperties.isEmpty
                ? 'Select Properties to Compare'
                : 'Comparing with ${_selectedProperties.length} ${_selectedProperties.length == 1 ? 'property' : 'properties'}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        // if (_selectedProperties.length >= _maxSelection)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8),
        //     child: Text(
        //       'Maximum $_maxSelection properties can be compared',
        //       style: const TextStyle(fontSize: 12, color: Color(0xFFFF9800)),
        //     ),
        //   ),
      ],
    );
  }

  List<LineChartBarData> _buildChartLines(List<_ChartPoint> myPropertyData) {
    final lines = <LineChartBarData>[];

    // Main property line (always shown)
    lines.add(_buildMainPropertyLine(myPropertyData));

    if (_comparisonType == 'locality') {
      // Add locality comparison line - shows city average
      final localityData = _getLocalityChartData();
      if (localityData.isNotEmpty) {
        lines.add(
          _buildComparisonLine(
            localityData,
            _comparisonColors[0],
            isDashed: true,
          ),
        );
      }
    } else if (_comparisonType == 'property') {
      // Check if we have property type data - shows average by property type
      final propertyTypeData = _getPropertyTypeChartData();
      if (propertyTypeData.isNotEmpty) {
        lines.add(
          _buildComparisonLine(
            propertyTypeData,
            _comparisonColors[0],
            isDashed: true,
          ),
        );
      }

      // Add all selected property lines with null safety
      for (int i = 0; i < _selectedProperties.length; i++) {
        final chartData = _selectedProperties[i].chartData;
        if (chartData.isNotEmpty) {
          lines.add(
            _buildComparisonLine(
              chartData,
              _comparisonColors[(i + 1) % _comparisonColors.length],
              isDashed: false,
            ),
          );
        }
      }
    }

    return lines;
  }

  LineChartBarData _buildMainPropertyLine(List<_ChartPoint> data) {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.35,
      barWidth: 3,
      color: const Color(0xFF3B82F6),
      belowBarData: BarAreaData(
        show: true,
        color: const Color(0xFF3B82F6).withOpacity(0.1),
      ),
      dotData: const FlDotData(show: false),
      spots: [
        for (int i = 0; i < data.length; i++)
          FlSpot(i.toDouble(), data[i].price.toDouble()),
      ],
    );
  }

  LineChartBarData _buildComparisonLine(
    List<_ChartPoint> data,
    Color color, {
    bool isDashed = false,
  }) {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.35,
      barWidth: 2.5,
      color: color,
      dashArray: isDashed ? [5, 5] : null,
      belowBarData: BarAreaData(show: false),
      dotData: const FlDotData(show: false),
      spots: [
        for (int i = 0; i < data.length; i++)
          FlSpot(i.toDouble(), data[i].price.toDouble()),
      ],
    );
  }

  FlTitlesData _buildTitles(List<_ChartPoint> data) {
    return FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _formatCurrency(value),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 28,
          getTitlesWidget: (value, meta) {
            final index = value.round();

            // bounds check
            if (index < 0 || index >= data.length) {
              return const SizedBox.shrink();
            }

            // ⛔ skip every second label (1, 3, 5...)
            if (index % 2 != 0) {
              return const SizedBox.shrink();
            }

            final point = data[index];

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                point.year.toString(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: point.isPast ? Colors.grey[700] : Colors.grey[500],
                ),
              ),
            );
          },
        ),
      ),

      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  LineTouchData _buildTouch(List<_ChartPoint> data) {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipItems: (spots) {
          return spots.map((s) {
            final lineIndex = s.barIndex;
            String label = 'My Property';
            Color color = const Color(0xFF3B82F6);

            if (_comparisonType == 'locality' && lineIndex == 1) {
              label = '${_matrixController.city} Avg';
              color = _comparisonColors[0];
            } else if (_comparisonType == 'property') {
              if (lineIndex == 1) {
                // First comparison line is property type average
                label = '${_matrixController.propertyType} Avg';
                color = _comparisonColors[0];
              } else if (lineIndex > 1 &&
                  lineIndex - 2 < _selectedProperties.length) {
                // Other lines are selected properties
                final propIndex = lineIndex - 2;
                label = _selectedProperties[propIndex].title;
                color =
                    _comparisonColors[(propIndex + 1) %
                        _comparisonColors.length];
              }
            }

            return LineTooltipItem(
              '$label\n${_formatCurrencyFull(s.y)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildLegend() {
    final items = <Widget>[
      _legendItem(
        label: 'My Property',
        color: ColorRes.primary,
        isPrimary: true,
      ),
    ];

    if (_comparisonType == 'locality') {
      items.add(
        _legendItem(
          label: '${_matrixController.city} Avg',
          color: _comparisonColors[0],
        ),
      );
    }

    if (_comparisonType == 'property') {
      items.add(
        _legendItem(
          label: '${_matrixController.propertyType} Avg',
          color: _comparisonColors[0],
        ),
      );

      items.addAll(
        _selectedProperties.asMap().entries.map((entry) {
          return _legendItem(
            label: entry.value.title,
            color:
                _comparisonColors[(entry.key + 1) % _comparisonColors.length],
          );
        }),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: items,
      ),
    );
  }

  Widget _legendItem({
    required String label,
    required Color color,
    bool isPrimary = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color dot
        Container(
          width: isPrimary ? 10 : 8,
          height: isPrimary ? 10 : 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),

        // Label
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
              color: Theme.of(Get.context!).textTheme.bodyMedium!.color,
            ),
          ),
        ),
      ],
    );
  }

  void _showPropertySelectionSheet(String propertyId, String location) {
    final controller = Get.put(
      InsightsPropertyController(location: location),
      tag: 'Matrix_$propertyId',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              /// ───────── Header ─────────
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Compare Properties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (controller.selectedPropertyIds.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            // Clear controller selections
                            controller.clearSelection();
                            // Clear widget state and trigger rebuild
                            setState(() {
                              _selectedProperties.clear();
                            });
                            Get.back();
                          },
                          child: const Text('Clear All'),
                        ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                );
              }),

              // if (_selectedProperties.length >= _maxSelection)
              Container(
                margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
                ),
                child: Text(
                  'Maximum $_maxSelection properties can be compared',
                  style: TextStyle(fontSize: 12, color: ColorRes.primary),
                ),
              ),

              /// ───────── Property List ─────────
              Expanded(
                child: Obx(() {
                  /// Initial loading
                  if (controller.isLoading.value && controller.items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  /// Empty state
                  if (controller.items.isEmpty) {
                    return const Center(child: Text('No properties found'));
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scroll) {
                      if (scroll.metrics.pixels >=
                              scroll.metrics.maxScrollExtent - 200 &&
                          controller.hasMore.value &&
                          !controller.isPaging.value) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          controller.items.length +
                          (controller.isPaging.value ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index >= controller.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = controller.items[index];

                        if (item.id == propertyId) {
                          return SizedBox.shrink();
                        }

                        return Obx(() {
                          final isSelected = controller.selectedPropertyIds
                              .contains(item.id);
                          final canSelect =
                              isSelected ||
                              controller.selectedPropertyIds.length <
                                  _maxSelection;

                          final hasImage =
                              item.propertyMedia?.images?.isNotEmpty ?? false;

                          return Opacity(
                            opacity: canSelect ? 1.0 : 0.5,
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomImage(
                                    type:
                                        hasImage
                                            ? CustomImageType.network
                                            : CustomImageType.asset,
                                    src:
                                        hasImage
                                            ? item.propertyMedia!.images!.first
                                            : null,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  PropertyNameManager(item).displayName ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.city ?? ''),
                                    SizedBox(height: 8),
                                    Text(
                                      PropertyPriceManager(
                                        listingType: item.listingType!,
                                        financialInfo:
                                            item.propertyDetails?.financialInfo,
                                      ).displayPrice,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: ColorRes.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Checkbox(
                                  value: isSelected,
                                  onChanged:
                                      canSelect
                                          ? (_) => controller.toggleSelection(
                                            item.id ?? '',
                                          )
                                          : null,
                                ),
                                onTap:
                                    canSelect
                                        ? () => controller.toggleSelection(
                                          item.id ?? '',
                                        )
                                        : null,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),

              /// ───────── Done Button ─────────
              Obx(() {
                final count = controller.selectedPropertyIds.length;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Convert selected property IDs to ComparisonProperty objects
                      _selectedProperties.clear();

                      try {
                        for (var propertyId in controller.selectedPropertyIds) {
                          final property = controller.items.firstWhereOrNull(
                            (item) => item.id == propertyId,
                          );

                          if (property != null &&
                              property.propertyDetails?.financialInfo != null) {
                            final financialInfo =
                                property.propertyDetails!.financialInfo!;

                            // Validate financial data
                            if (financialInfo.pricePast.isEmpty ||
                                financialInfo.priceFuture.isEmpty) {
                              continue; // Skip properties with incomplete data
                            }

                            // Generate chart data for this property
                            final chartData = _generateChartData(
                              past: financialInfo.pricePast,
                              future: financialInfo.priceFuture,
                              current: PropertyPriceYear(
                                year:
                                    DateTime.parse(
                                      widget.currentProperty.createdAt!,
                                    ).year,
                                price:
                                    property
                                        .propertyDetails!
                                        .financialInfo!
                                        .price,
                                pricePerSqft:
                                    property
                                        .propertyDetails!
                                        .financialInfo!
                                        .pricePerSqft,
                              ),
                            );

                            // Validate chart data
                            if (chartData.isEmpty) {
                              continue; // Skip if chart data generation failed
                            }

                            // Calculate average price
                            final avgPrice =
                                financialInfo.pricePast.isNotEmpty
                                    ? financialInfo.pricePast.last.pricePerSqft
                                    : 0;

                            _selectedProperties.add(
                              ComparisonProperty(
                                id: property.id ?? '',
                                title:
                                    PropertyNameManager(property).displayName ??
                                    'Property',
                                chartData: chartData,
                                avgPrice: avgPrice,
                                propertyType: property.propertyType ?? '',
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print('Error converting properties: $e');
                        // Show error message to user
                        Get.snackbar(
                          'Error',
                          'Failed to load some properties',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }

                      setState(() {}); // Refresh the main chart
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      count == 0 ? 'Done' : 'Show Comparison ($count)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class PriceSummary {
  final num? current;
  final double? oneYear;
  final double? fiveYear;

  PriceSummary({this.current, this.oneYear, this.fiveYear});
}

PriceSummary _summaryFromChart(List<_ChartPoint> points) {
  final past = points.where((e) => e.isPast).toList();
  if (past.length < 2) return PriceSummary();

  return PriceSummary(
    current: past.last.price,
    oneYear: _growth(past[past.length - 2].price, past.last.price),
    fiveYear:
        past.length >= 5 ? _growth(past.first.price, past.last.price) : null,
  );
}

double? _growth(num? start, num? end) {
  if (start == null || end == null || start == 0) return null;
  return ((end - start) / start) * 100;
}
