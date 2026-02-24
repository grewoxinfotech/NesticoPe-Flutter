/// Lead Filter Helper
/// 
/// Converts filter UI format to API format for all lead screens

class LeadFilterHelper {
  /// Convert filter format from "Stage:New Lead" to {"stage": "new_lead"}
  /// 
  /// Example:
  /// ```dart
  /// final filters = ["Stage:New Lead", "Status:Contacted"];
  /// final apiFilters = LeadFilterHelper.convertFiltersToAPIFormat(filters);
  /// // Result: {"stage": "new_lead", "status": "contacted"}
  /// ```
  static Map<String, String> convertFiltersToAPIFormat(List<String> filters) {
    final filterMap = <String, String>{};
    
    for (var filter in filters) {
      final parts = filter.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim(); // "stage" or "status"
        final value = parts[1]
            .trim()
            .toLowerCase()
            .replaceAll(' ', '_'); // "new_lead"
        filterMap[key] = value;
      }
    }
    
    return filterMap;
  }
  
  /// Convert multiple filter maps into a single map
  /// Used when filters come from multiple sources
  static Map<String, String> mergeFilterMaps(
    List<Map<String, String>> filterMaps,
  ) {
    final mergedFilters = <String, String>{};
    for (var filterMap in filterMaps) {
      mergedFilters.addAll(filterMap);
    }
    return mergedFilters;
  }
}
