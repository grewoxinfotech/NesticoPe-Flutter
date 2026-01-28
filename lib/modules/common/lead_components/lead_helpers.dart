import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:intl/intl.dart';

import '../../reseller/model/dashboard/dashboard_model.dart';

/// Get status color based on lead status
Color getStatusColor(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_:
      return ColorRes.blueColor;
    case LeadStatus.contacted:
      return ColorRes.orangeColor;
    case LeadStatus.qualified:
      return ColorRes.purpleColor;
    case LeadStatus.negotiation:
      return ColorRes.leadIndigoColor;
    case LeadStatus.lost:
      return ColorRes.error;
    case LeadStatus.fake:
      return ColorRes.error;
    case LeadStatus.convert:
      return ColorRes.leadTealColor;

    default:
      return ColorRes.leadGreyColor;
  }
}


String formatDateForGlobal(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString).toLocal(); // Convert to local time
    final formattedDate = DateFormat('MMM dd yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    return ''; // return empty if parsing fails
  }
}

/// Convert string to LeadStatus enum
LeadStatus getLeadStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'new':
      return LeadStatus.new_;
    case 'contacted':
      return LeadStatus.contacted;
    case 'qualified':
      return LeadStatus.qualified;
    case 'negotiation':
      return LeadStatus.negotiation;
    case 'lost':
      return LeadStatus.lost;
    case 'converted':
      return LeadStatus.convert;
    case 'fake':
      return LeadStatus.fake;

    default:
      return LeadStatus.new_;
  }
}

/// Get status text from enum
String getStatusText(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_:
      return 'New';
    case LeadStatus.contacted:
      return 'Contacted';
    case LeadStatus.qualified:
      return 'Qualified';
    case LeadStatus.negotiation:
      return 'Negotiating';
    case LeadStatus.lost:
      return 'Lost';
    case LeadStatus.convert:
      return 'Converted';
    case LeadStatus.fake:
      return "Fake";
    default:
      return 'All';
  }
}

/// Get stage color based on lead stage
Color getStageColor(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead:
      return ColorRes.blueColor;
    case LeadStage.contacted:
      return ColorRes.orangeColor;
    case LeadStage.interested:
      return ColorRes.purpleColor;
    case LeadStage.siteVisit:
      return ColorRes.leadIndigoColor;
    case LeadStage.sell:
      return ColorRes.success;

    default:
      return ColorRes.leadGreyColor;
  }
}

Color getSourceColor(SourceType source) {
  switch (source) {
    case SourceType.app:
      return ColorRes.leadTealColor;
    case SourceType.website:
      return ColorRes.blueColor;
    case SourceType.referral:
      return ColorRes.purpleColor;
    case SourceType.socialMedia:
      return ColorRes.orangeColor;
    case SourceType.direct:
      return ColorRes.leadIndigoColor;
    case SourceType.other:
      return ColorRes.leadGreyColor;
    default:
      return ColorRes.leadGreyColor;
  }
}

SourceType getSourceFromString(String source) {
  switch (source.toLowerCase()) {
    case 'app':
      return SourceType.app;
    case 'website':
      return SourceType.website;
    case 'referral':
      return SourceType.referral;
    case 'social_media':
      return SourceType.socialMedia;
    case 'direct':
      return SourceType.direct;
    case 'other':
      return SourceType.other;
    default:
      return SourceType.other;
  }
}

String getSourceText(SourceType source) {
  switch (source) {
    case SourceType.app:
      return 'App';
    case SourceType.website:
      return 'Website';
    case SourceType.referral:
      return 'Referral';
    case SourceType.socialMedia:
      return 'Social Media';
    case SourceType.direct:
      return 'Direct';
    case SourceType.other:
      return 'Other';
    default:
      return 'Unknown';
  }
}

/// Convert string to LeadStage enum
LeadStage getLeadStageFromString(String? stage) {
  switch (stage?.toLowerCase()) {
    case 'newlead':
    case 'new_lead':
    case 'new lead':
      return LeadStage.newLead;
    case 'contacted':
      return LeadStage.contacted;
    case 'interested':
      return LeadStage.interested;
    case 'sitevisit':
    case 'site_visit':
    case 'site visit':
      return LeadStage.siteVisit;
    case 'sell':
      return LeadStage.sell;

    default:
      return LeadStage.newLead;
  }
}

/// Get stage text from enum
String getStageText(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead:
      return 'New Lead';
    case LeadStage.contacted:
      return 'Contacted';
    case LeadStage.interested:
      return 'Interested';
    case LeadStage.siteVisit:
      return 'Site Visit';
    case LeadStage.sell:
      return 'Sell';
    default:
      return 'All';
  }
}

/// Format time to relative time string (e.g., "2h ago", "3d ago")
String formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inMinutes}m ago';
  }
}

/// Get initials from name
String getInitials(String name) {
  if (name.trim().isEmpty) return '';
  final parts = name.trim().split(RegExp(r'\\s+'));
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  } else {
    final firstInitial = parts[0].isNotEmpty ? parts[0][0] : '';
    final secondInitial = parts[1].isNotEmpty ? parts[1][0] : '';
    return (firstInitial + secondInitial).toUpperCase();
  }
}

/// Build action button widget
Widget buildActionButton({
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
  required String tooltip,
  required bool isCompact,
}) {
  return Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Material(
          color: ColorRes.transparentColor,
          child: Icon(icon, size: isCompact ? 15 : 14, color: color),
        ),
      ),
    ),
  );
}

/// Get responsive padding based on screen size
double getResponsivePadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return 12.0;
  if (width < 900) return 16.0;
  return 20.0;
}

/// Get responsive spacing based on screen size
double getResponsiveSpacing(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width < 600 ? 12.0 : 16.0;
}
