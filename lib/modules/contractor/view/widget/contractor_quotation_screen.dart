import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_quotation_controller.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/contractor_inquiry_quotation_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as currencyFormat;

/// Screen for displaying quotation details with action buttons
class ContractorQuotationScreen extends StatefulWidget {
  final ContractorQuotation quotation;

  const ContractorQuotationScreen({super.key, required this.quotation});

  @override
  State<ContractorQuotationScreen> createState() =>
      _ContractorQuotationScreenState();
}

class _ContractorQuotationScreenState extends State<ContractorQuotationScreen> {
  String? _selectedStatus;
  String _currentStatus = '';

  final List<String> _statusOptions = ['Pending', 'Accepted', 'Rejected'];

  @override
  void initState() {
    super.initState();
    // Capitalize first letter to match dropdown items
    _currentStatus =
        widget.quotation.status.isNotEmpty
            ? capitalizeEachWord(widget.quotation.status)
            : 'Pending';
    _selectedStatus = _currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        elevation: 0,
        title: const Text(
          'Quotation Details',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge
              _buildStatusBadge(),

              const SizedBox(height: 16),

              // Customer Details Section
              _buildSectionCard(
                icon: Icons.person_outline,
                title: 'Customer Details',
                children: [
                  _buildInfoRow('Name:', widget.quotation.user.name),
                  const SizedBox(height: 12),
                  _buildInfoRow('Phone:', widget.quotation.user.phone),
                  const SizedBox(height: 12),
                  _buildInfoRow('Email:', widget.quotation.user.email),
                ],
              ),

              const SizedBox(height: 16),

              // Property Details Section
              _buildSectionCard(
                icon: Icons.home_outlined,
                title: 'Property Details',
                children: [
                  _buildInfoRow(
                    'Type:',
                    widget.quotation.meta.propertyDetails?.propertyType ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'City:',
                    widget.quotation.meta.propertyDetails?.city ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Location:',
                    widget.quotation.meta.propertyDetails?.location ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'State:',
                    widget.quotation.meta.propertyDetails?.state ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Carpet Area:',
                    '${widget.quotation.meta.propertyDetails?.carpetArea} sq.ft',
                  ),
                  const SizedBox(height: 12),
                  if (widget.quotation.meta.propertyDetails?.bhk != null)
                    _buildInfoRow(
                      'BHK:',
                      '${widget.quotation.meta.propertyDetails?.bhk}',
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Service Details Section
              _buildSectionCard(
                icon: Icons.build_outlined,
                title: 'Service Details',
                children: [
                  _buildInfoRow(
                    'Services:',
                    widget.quotation.meta.serviceNames ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Description:',
                    widget.quotation.meta.propertyDetails?.serviceDescription ??
                        '',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quotation Details Section
              _buildSectionCard(
                icon: Icons.receipt_outlined,
                title: 'Quotation Details',
                children: [
                  _buildInfoRow(
                    'Price:',
                    '${Formatter.formatPrice(num.tryParse(widget.quotation.price) ?? 0)}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Notes:', widget.quotation.meta.notes),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Created At:',
                    _formatDate(widget.quotation.createdAt),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Updated At:',
                    _formatDate(widget.quotation.updatedAt),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Converted:',
                    widget.quotation.isConverted ? 'Yes' : 'No',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Status Change Section
              if (!widget.quotation.isConverted) _buildStatusChangeSection(),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    IconData statusIcon;

    switch (_selectedStatus?.toLowerCase()) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 24),
          const SizedBox(width: 12),
          Text(
            'Status: ${capitalizeEachWord(_selectedStatus ?? '')}',
            style: TextStyle(
              fontSize: AppFontSizes.small,
              fontWeight: AppFontWeights.medium,
              color: statusColor,
            ),
          ),
          if (widget.quotation.isConverted) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Converted to Lead',
                style: TextStyle(
                  fontSize: AppFontSizes.extraSmall,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorRes.textSecondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.textSecondary,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value.isEmpty ? "Not mentioned" : value,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.textPrimary,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChangeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.swap_horiz,
                size: 20,
                color: ColorRes.textSecondary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Change Status',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorRes.background,
              prefixIcon: const Icon(
                Icons.schedule,
                color: ColorRes.primary,
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: ColorRes.border,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: ColorRes.border,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: ColorRes.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: ColorRes.textSecondary,
            ),
            style: const TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textPrimary,
            ),
            dropdownColor: ColorRes.white,
            items:
                _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedStatus = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _selectedStatus != capitalizeEachWord(widget.quotation.status)
                      ? _updateStatus
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                disabledBackgroundColor: ColorRes.border,
              ),
              child: const Text(
                'Update Status',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Edit Button
        Row(
          children: [
            if (!widget.quotation.isConverted)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _editQuotation,
                  icon: const Icon(Icons.edit_outlined, color: ColorRes.white),
                  label: const Text(
                    'Edit Quotation',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (!widget.quotation.isConverted) const SizedBox(width: 12),
            // Delete Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _deleteQuotation,
                icon: const Icon(Icons.delete_outline, color: ColorRes.error),
                label: const Text(
                  'Delete Quotation',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: ColorRes.error, width: 1.5),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        // Download PDF Button
        if (widget.quotation.isConverted)...[
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _downloadQuotationPDF,
                icon: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: ColorRes.primary,
                ),
                label: const Text(
                  'Share Document PDF ',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: ColorRes.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ]else...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _downloadQuotationPDF,
              icon: const Icon(Icons.picture_as_pdf_outlined, color: ColorRes.primary),
              label: const Text(
                'Share Document PDF ',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(
                  color: ColorRes.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],



        // Convert to Lead Button
        if (!widget.quotation.isConverted)
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _convertToLead,
                icon: const Icon(Icons.transform, color: ColorRes.white),
                label: const Text(
                  'Convert to Lead',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),

        // Delete Button
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     onPressed: _deleteQuotation,
        //     icon: const Icon(Icons.delete_outline, color: ColorRes.error),
        //     label: const Text(
        //       'Delete Quotation',
        //       style: TextStyle(
        //         fontSize: AppFontSizes.medium,
        //         fontWeight: AppFontWeights.semiBold,
        //         color: ColorRes.error,
        //       ),
        //     ),
        //     style: OutlinedButton.styleFrom(
        //       padding: const EdgeInsets.symmetric(vertical: 16),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       side: const BorderSide(
        //         color: ColorRes.error,
        //         width: 1.5,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _updateStatus() {
    if (_selectedStatus == null) return;

    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:  Text(
          'Confirm Status Change',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            fontSize: AppFontSizes.body,
            color: ColorRes.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to change the status to "$_selectedStatus"?',
          style: const TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: ColorRes.textSecondary,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              final controller = Get.find<ContractorQuotationController>();
              controller.updateQuotationStatus(
                widget.quotation.id,
                _selectedStatus!,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: ColorRes.white,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _convertToLead() {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Convert to Lead',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to convert this quotation to a lead? This action cannot be undone.',
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: ColorRes.textSecondary,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final controller = Get.find<ContractorQuotationController>();
              controller.convertIntoLead(widget.quotation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Convert',
              style: TextStyle(
                color: ColorRes.white,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteQuotation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Quotation',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.error,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this quotation? This action cannot be undone.',
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: ColorRes.textSecondary,
                fontWeight: AppFontWeights.medium,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              final controller = Get.find<ContractorQuotationController>();
              controller.deleteQuotation(widget.quotation.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: ColorRes.white,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editQuotation() {
    Get.to(
      () => ContractorInquiryQuotationScreen(
        quotation: widget.quotation,
        isEditMode: true,
      ),
    );
  }

  String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text
        .split('_')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<void> _downloadQuotationPDF() async {
    final user = await SecureStorage.getUserData();
    log("user : $user");
    try {
      // Show loading dialog
      Get.dialog(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: ColorRes.primary),
            SizedBox(height: 16),
            Text(
              "Generating PDF...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      final pdf = pw.Document();

      // Define colors matching the website
      final primaryColor = PdfColor.fromInt(0xFF2980B9); // Professional Blue
      final secondaryColor = PdfColors.black; // Gray
      final darkColor = PdfColor.fromInt(0xFF2C3E50); // Dark Navy

      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          build: (pw.Context context) {
            return [
              // Branding Strip (Top colored bar)
              pw.Container(
                width: double.infinity,
                height: 3,
                color: primaryColor,
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'NesticoPe',
                              style: pw.TextStyle(
                                fontSize: 22,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Buy - Sell - Rent',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'Contractor',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              '${user?.user?.email ?? ''} | ${user?.user?.phone ?? ''}',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 20),

                    // QUOTATION Label (Right aligned)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text(
                          'QUOTATION',
                          style: pw.TextStyle(
                            fontSize: 26,
                            fontWeight: pw.FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 10),

                    // Meta Info (Right aligned)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Quotation #:',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Date:',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              widget.quotation.id.substring(0, 8).toUpperCase(),
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: secondaryColor,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              _formatQuotationDate(widget.quotation.createdAt),
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 20),

                    // Divider
                    pw.Container(
                      width: double.infinity,
                      height: 0.5,
                      color: PdfColor.fromInt(0xFFE6E6E6),
                    ),

                    pw.SizedBox(height: 20),

                    // Client & Property Grid
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Left: Bill To
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Bill To',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              pw.Text(
                                widget.quotation.user.name,
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: darkColor,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              if (widget.quotation.user.phone.isNotEmpty)
                                pw.Text(
                                  widget.quotation.user.phone,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: secondaryColor,
                                  ),
                                ),
                              pw.SizedBox(height: 2),
                              if (widget.quotation.user.email.isNotEmpty)
                                pw.Text(
                                  widget.quotation.user.email,
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    color: secondaryColor,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        pw.SizedBox(width: 20),

                        // Right: Property Details
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Property Details',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              pw.SizedBox(height: 8),
                              _buildPropertyRow(
                                'Type',
                                widget
                                        .quotation
                                        .meta
                                        .propertyDetails
                                        ?.propertyType ??
                                    '',
                              ),
                              _buildPropertyRow(
                                'City',
                                widget.quotation.meta.propertyDetails?.city ??
                                    '',
                              ),
                              _buildPropertyRow(
                                'Location',
                                widget
                                        .quotation
                                        .meta
                                        .propertyDetails
                                        ?.location ??
                                    '',
                              ),
                              if (widget
                                          .quotation
                                          .meta
                                          .propertyDetails
                                          ?.carpetArea !=
                                      null &&
                                  widget
                                          .quotation
                                          .meta
                                          .propertyDetails!
                                          .carpetArea >
                                      0)
                                _buildPropertyRow(
                                  'Area',
                                  '${widget.quotation.meta.propertyDetails!.carpetArea} sqft',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 30),

                    // Item Table
                    _buildItemTable(primaryColor, darkColor, secondaryColor),

                    pw.SizedBox(height: 30),

                    // Terms & Notes
                    pw.Text(
                      'Terms & Notes:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: darkColor,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      _getFooterNotes(),
                      style: pw.TextStyle(fontSize: 9, color: secondaryColor),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      );
      Get.back(); // close first dialog
      Get.dialog(
        Center(
          child: Container(
            width: 220,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  color: ColorRes.primary,
                  strokeWidth: 3,
                ),
                SizedBox(height: 18),
                Text(
                  "Preparing to share PDF...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorRes.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.4), // 🔹 Dim background
      );


      // Close loading dialog

      await _sharePDF(pdf);
      Get.back();
     /* Get.snackbar(
        'Success',
        'Quotation PDF generated and ready to share!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.primary,
        colorText: Colors.white,
      );*/
    } catch (e, stackTrace) {
      Get.back(); // Close loading dialog
      print('PDF Generation Error: $e');
      print('Stack Trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to generate PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.error,
        colorText: ColorRes.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  pw.Widget _buildPropertyRow(String label, String value) {
    if (value.isEmpty) return pw.SizedBox();

    final secondaryColor = PdfColor.fromInt(0xFF7F8C8D);
    final darkColor = PdfColor.fromInt(0xFF2C3E50);

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 60,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: darkColor,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 10, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildItemTable(
    PdfColor primaryColor,
    PdfColor darkColor,
    PdfColor secondaryColor,
  ) {
    // Build description
    String description = widget.quotation.meta.serviceNames ?? '';

    if (widget.quotation.meta.notes.isNotEmpty) {
      String cleanNotes = widget.quotation.meta.notes.replaceAll(
        'Generated from inquiry for: ',
        '',
      );
      if (!description.contains(cleanNotes) && cleanNotes.isNotEmpty) {
        description +=
            description.isNotEmpty ? '\n\nNote: $cleanNotes' : cleanNotes;
      }
    }

    if (description.isEmpty) description = 'General Service';

    // Parse and format price
    final price =
        double.tryParse(
          widget.quotation.price.toString().replaceAll(',', ''),
        ) ??
        0;

    String formatIndianCurrency(double amount) {
      final s = amount.toStringAsFixed(0);
      final n = s.length;
      if (n <= 3) return '₹ $s';
      final last3 = s.substring(n - 3);
      final rest = s.substring(0, n - 3);
      final formatted =
          rest.replaceAllMapped(
            RegExp(r'(\d)(?=(\d\d)+\d$)'),
            (Match m) => '${m[1]},',
          ) +
          ',' +
          last3;
      return 'Rs. $formatted';
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.8),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
      },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        // Header Row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: primaryColor),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: pw.Text(
                'Description',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: pw.Text(
                'Total',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ],
        ),

        // Body Row
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Text(
                description,
                style: pw.TextStyle(fontSize: 10, color: darkColor),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  formatIndianCurrency(price),
                  style: pw.TextStyle(fontSize: 10, color: darkColor),
                ),
              ),
            ),
          ],
        ),

        // Footer (Grand Total)
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F5F5F5')),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Grand Total:',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  formatIndianCurrency(price),
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // pw.Widget _buildItemTable(PdfColor primaryColor, PdfColor darkColor, PdfColor secondaryColor) {
  //   // Build description
  //   String description = widget.quotation.meta.serviceNames ?? '';
  //
  //   if (widget.quotation.meta.notes.isNotEmpty) {
  //     String cleanNotes = widget.quotation.meta.notes.replaceAll('Generated from inquiry for: ', '');
  //     if (!description.contains(cleanNotes) && cleanNotes.isNotEmpty) {
  //       description += description.isNotEmpty ? '\n\nNote: $cleanNotes' : cleanNotes;
  //     }
  //   }
  //
  //   if (description.isEmpty) description = 'General Service';
  //
  //   // Parse price from string to double
  //   final price = double.tryParse(widget.quotation.price.toString().replaceAll(',', '')) ?? 0;
  //
  //   // Format price manually to avoid NumberFormat issues
  //   String formatPrice(double amount) {
  //     final intAmount = amount.toInt();
  //     final formatted = intAmount.toString().replaceAllMapped(
  //       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  //           (Match m) => '${m[1]},',
  //     );
  //     return '₹ $formatted';
  //   }
  //
  //   return pw.Table(
  //     border: pw.TableBorder.all(color: PdfColors.grey400),
  //     columnWidths: {
  //       0: const pw.FlexColumnWidth(3),
  //       1: const pw.FlexColumnWidth(1),
  //     },
  //     children: [
  //       // Header
  //       pw.TableRow(
  //         decoration: pw.BoxDecoration(color: primaryColor),
  //         children: [
  //           pw.Padding(
  //
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Text(
  //               'Description',
  //               style: pw.TextStyle(
  //                 fontSize: 11,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: PdfColors.white,
  //               ),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Text(
  //               'Total',
  //               textAlign: pw.TextAlign.right,
  //               style: pw.TextStyle(
  //                 fontSize: 11,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: PdfColors.white,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //
  //       // Body
  //       pw.TableRow(
  //         children: [
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Text(
  //               description,
  //               style: pw.TextStyle(
  //                 fontSize: 10,
  //                 color: darkColor,
  //               ),
  //             ),
  //           ),
  //
  //
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Text(
  //               "Rs. ${widget.quotation.price}",
  //               style: pw.TextStyle(
  //                 fontSize: 10,
  //                 color: darkColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //
  //       // Footer (Grand Total)
  //       pw.TableRow(
  //         decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFF5F5F5)),
  //         children: [
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Text(
  //               'Grand Total:',
  //               textAlign: pw.TextAlign.right,
  //               style: pw.TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: primaryColor,
  //               ),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(10),
  //             child: pw.Text(
  //             'Rs. ${price.toString()}',
  //               textAlign: pw.TextAlign.right,
  //               style: pw.TextStyle(
  //                 fontSize: 12,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: primaryColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  String _getFooterNotes() {
    String notes = 'Standard terms and conditions apply.';

    try {
      if (widget.quotation.meta.propertyDetails?.serviceDescription != null &&
          widget
              .quotation
              .meta
              .propertyDetails!
              .serviceDescription
              .isNotEmpty) {
        notes +=
            '\nScope: ${widget.quotation.meta.propertyDetails!.serviceDescription}';
      }
    } catch (e) {
      print('Error getting footer notes: $e');
    }

    return notes;
  }

  // Helper method to format date safely
  String _formatQuotationDate(DateTime date) {
    try {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      print('Error formatting date: $e');
      return 'N/A';
    }
  }

  // Future<void> _downloadQuotationPDF() async {
  //   try {
  //     // Show loading dialog
  //     Get.dialog(
  //       const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //       barrierDismissible: false,
  //     );
  //     final primaryColor = PdfColor.fromInt(0xFF2980B9); // Professional Blue
  //     final secondaryColor = PdfColor.fromInt(0xFF7F8C8D); // Gray
  //     final darkColor = PdfColor.fromInt(0xFF2C3E50); // Dark Navy
  //
  //     final pdf = pw.Document();
  //
  //     // Add page to PDF
  //     pdf.addPage(
  //       pw.MultiPage(
  //         pageFormat: PdfPageFormat.a4,
  //         margin: const pw.EdgeInsets.all(32),
  //         build: (pw.Context context) {
  //           return [
  //             // Header
  //             _buildPDFHeader(),
  //             pw.SizedBox(height: 30),
  //
  //             // Quotation ID and Date
  //             _buildPDFQuotationInfo(),
  //             pw.SizedBox(height: 20),
  //
  //             // Customer Details
  //             _buildPDFSection('Customer Details', [
  //               _buildPDFRow('Name', widget.quotation.user.name),
  //               _buildPDFRow('Phone', widget.quotation.user.phone),
  //               _buildPDFRow('Email', widget.quotation.user.email),
  //             ]),
  //             pw.SizedBox(height: 20),
  //
  //             // Property Details
  //             _buildPDFSection('Property Details', [
  //               _buildPDFRow('Type', widget.quotation.meta.propertyDetails?.propertyType??''),
  //               _buildPDFRow('City', widget.quotation.meta.propertyDetails?.city??''),
  //               _buildPDFRow('Location', widget.quotation.meta.propertyDetails?.location??''),
  //               _buildPDFRow('State', widget.quotation.meta.propertyDetails?.state??''),
  //               _buildPDFRow('Carpet Area', '${widget.quotation.meta.propertyDetails?.carpetArea} sq.ft'),
  //               if (widget.quotation.meta.propertyDetails?.bhk != null)
  //                 _buildPDFRow('BHK', '${widget.quotation.meta.propertyDetails?.bhk}'),
  //             ]),
  //             pw.SizedBox(height: 20),
  //
  //             // Service Details
  //             _buildPDFSection('Service Details', [
  //               _buildPDFRow('Services', widget.quotation.meta.serviceNames??''),
  //               _buildPDFRow('Description', widget.quotation.meta.propertyDetails?.serviceDescription??''),
  //             ]),
  //             pw.SizedBox(height: 20),
  //
  //             // Notes
  //             _buildPDFSection('Notes', [
  //               pw.Text(
  //                 widget.quotation.meta.notes,
  //                 style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
  //               ),
  //             ]),
  //             pw.SizedBox(height: 30),
  //
  //             // Price Section
  //             pw.Container(
  //               padding: const pw.EdgeInsets.all(16),
  //               decoration: pw.BoxDecoration(
  //                 color: PdfColor.fromHex('#E3F2FD'),
  //                 borderRadius: pw.BorderRadius.circular(8),
  //               ),
  //               child: pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   pw.Text(
  //                     'Total Quotation Price',
  //                     style: pw.TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: pw.FontWeight.bold,
  //                       color: PdfColor.fromHex('#1976D2'),
  //                     ),
  //                   ),
  //                   pw.Text(
  //                     '₹ ${widget.quotation.price}',
  //                     style: pw.TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: pw.FontWeight.bold,
  //                       color: PdfColor.fromHex('#1976D2'),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             pw.SizedBox(height: 20),
  //
  //             // Status
  //             pw.Row(
  //               children: [
  //                 pw.Text(
  //                   'Status: ',
  //                   style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
  //                 ),
  //                 pw.Container(
  //                   padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //                   decoration: pw.BoxDecoration(
  //                     color: _getPDFStatusColor(widget.quotation.status),
  //                     borderRadius: pw.BorderRadius.circular(4),
  //                   ),
  //                   child: pw.Text(
  //                     widget.quotation.status.toUpperCase(),
  //                     style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //             pw.Spacer(),
  //
  //             // Footer
  //             pw.Divider(),
  //             pw.SizedBox(height: 10),
  //             pw.Text(
  //               'Generated on ${_formatDate(DateTime.now())}',
  //               style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
  //               textAlign: pw.TextAlign.center,
  //             ),
  //             pw.Text(
  //               'This is a system-generated quotation',
  //               style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
  //               textAlign: pw.TextAlign.center,
  //             ),
  //           ];
  //         },
  //       ),
  //     );
  //
  //     // // Close loading dialog
  //     Get.back();
  //     await _sharePDF(pdf);
  //
  //     // Show save/share dialog
  //     // await _showPDFOptions(pdf);
  //   } catch (e) {
  //     Get.back(); // Close loading dialog
  //     Get.snackbar(
  //       'Error',
  //       'Failed to generate PDF: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: ColorRes.error,
  //       colorText: ColorRes.white,
  //       duration: const Duration(seconds: 3),
  //     );
  //   }
  // }
  //
  // pw.Widget _buildPDFHeader() {
  //   return pw.Container(
  //     padding: const pw.EdgeInsets.all(16),
  //     decoration: pw.BoxDecoration(
  //       color: PdfColor.fromHex('#1976D2'),
  //       borderRadius: pw.BorderRadius.circular(8),
  //     ),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.Text(
  //           'QUOTATION',
  //           style: pw.TextStyle(
  //             fontSize: 28,
  //             fontWeight: pw.FontWeight.bold,
  //             color: PdfColors.white,
  //           ),
  //         ),
  //         pw.SizedBox(height: 4),
  //         pw.Text(
  //           'Professional Service Quotation',
  //           style: pw.TextStyle(
  //             fontSize: 12,
  //             color: PdfColors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // pw.Widget _buildPDFQuotationInfo() {
  //   return pw.Row(
  //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //     children: [
  //       pw.Column(
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           pw.Text(
  //             'Quotation ID',
  //             style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
  //           ),
  //           pw.SizedBox(height: 4),
  //           pw.Text(
  //             '#${widget.quotation.id.substring(0, 12).toUpperCase()}',
  //             style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       pw.Column(
  //         crossAxisAlignment: pw.CrossAxisAlignment.end,
  //         children: [
  //           pw.Text(
  //             'Date',
  //             style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
  //           ),
  //           pw.SizedBox(height: 4),
  //           pw.Text(
  //             _formatDate(widget.quotation.createdAt),
  //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }
  //
  // pw.Widget _buildPDFSection(String title, List<pw.Widget> children) {
  //   return pw.Column(
  //     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //     children: [
  //       pw.Container(
  //         padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  //         decoration: pw.BoxDecoration(
  //           color: PdfColors.grey300,
  //           borderRadius: pw.BorderRadius.circular(4),
  //         ),
  //         child: pw.Text(
  //           title,
  //           style: pw.TextStyle(
  //             fontSize: 14,
  //             fontWeight: pw.FontWeight.bold,
  //             color: PdfColors.grey800,
  //           ),
  //         ),
  //       ),
  //       pw.SizedBox(height: 12),
  //       pw.Container(
  //         padding: const pw.EdgeInsets.all(12),
  //         decoration: pw.BoxDecoration(
  //           border: pw.Border.all(color: PdfColors.grey300),
  //           borderRadius: pw.BorderRadius.circular(4),
  //         ),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: children,
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  // pw.Widget _buildPDFRow(String label, String value) {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.only(bottom: 8),
  //     child: pw.Row(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         pw.SizedBox(
  //           width: 120,
  //           child: pw.Text(
  //             '$label:',
  //             style: pw.TextStyle(
  //               fontSize: 11,
  //               fontWeight: pw.FontWeight.bold,
  //               color: PdfColors.grey700,
  //             ),
  //           ),
  //         ),
  //         pw.Expanded(
  //           child: pw.Text(
  //             value,
  //             style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  PdfColor _getPDFStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return PdfColor.fromHex('#4CAF50');
      case 'rejected':
        return PdfColor.fromHex('#F44336');
      case 'completed':
        return PdfColor.fromHex('#2196F3');
      default:
        return PdfColor.fromHex('#FF9800');
    }
  }

  Future<void> _showPDFOptions(pw.Document pdf) async {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'PDF Generated Successfully',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        content: const Text(
          'Choose an action for the quotation PDF',
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.textSecondary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _savePDF(pdf);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save_alt, color: ColorRes.primary),
            label: const Text(
              'Save to Device',
              style: TextStyle(
                color: ColorRes.primary,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pop();
              await _sharePDF(pdf);
            },
            icon: const Icon(Icons.share, color: ColorRes.white),
            label: const Text(
              'Share',
              style: TextStyle(
                color: ColorRes.white,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePDF(pw.Document pdf) async {
    try {
      final bytes = await pdf.save();
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/quotation_${widget.quotation.id.substring(0, 8)}.pdf',
      );
      await file.writeAsBytes(bytes);

      Get.snackbar(
        'Success',
        'PDF saved to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.primary,
        colorText: ColorRes.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.error,
        colorText: ColorRes.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _sharePDF(pw.Document pdf) async {
    try {
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'quotation_${widget.quotation.id.substring(0, 8)}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.error,
        colorText: ColorRes.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
