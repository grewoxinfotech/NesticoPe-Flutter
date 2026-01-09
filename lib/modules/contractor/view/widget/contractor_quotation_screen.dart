import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_quotation_controller.dart';
import 'package:housing_flutter_app/modules/contractor/view/widget/contractor_inquiry_quotation_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Screen for displaying quotation details with action buttons
class ContractorQuotationScreen extends StatefulWidget {
  final ContractorQuotation quotation;

  const ContractorQuotationScreen({
    super.key,
    required this.quotation,
  });

  @override
  State<ContractorQuotationScreen> createState() =>
      _ContractorQuotationScreenState();
}

class _ContractorQuotationScreenState
    extends State<ContractorQuotationScreen> {
  String? _selectedStatus;
  String _currentStatus = '';

  final List<String> _statusOptions = [
    'Pending',
    'Accepted',
    'Rejected',
  ];

  @override
  void initState() {
    super.initState();
    // Capitalize first letter to match dropdown items
    _currentStatus = widget.quotation.status.isNotEmpty
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
                  _buildInfoRow('Type:', widget.quotation.meta.propertyDetails?.propertyType??''),
                  const SizedBox(height: 12),
                  _buildInfoRow('City:', widget.quotation.meta.propertyDetails?.city??''),
                  const SizedBox(height: 12),
                  _buildInfoRow('Location:', widget.quotation.meta.propertyDetails?.location??''),
                  const SizedBox(height: 12),
                  _buildInfoRow('State:', widget.quotation.meta.propertyDetails?.state??''),
                  const SizedBox(height: 12),
                  _buildInfoRow('Carpet Area:', '${widget.quotation.meta.propertyDetails?.carpetArea} sq.ft'),
                  const SizedBox(height: 12),
                  if (widget.quotation.meta.propertyDetails?.bhk != null)
                    _buildInfoRow('BHK:', '${widget.quotation.meta.propertyDetails?.bhk}'),
                ],
              ),

              const SizedBox(height: 16),

              // Service Details Section
              _buildSectionCard(
                icon: Icons.build_outlined,
                title: 'Service Details',
                children: [
                  _buildInfoRow('Services:', widget.quotation.meta.serviceNames??''),
                  const SizedBox(height: 12),
                  _buildInfoRow('Description:', widget.quotation.meta.propertyDetails?.serviceDescription??''),
                ],
              ),

              const SizedBox(height: 16),

              // Quotation Details Section
              _buildSectionCard(
                icon: Icons.receipt_outlined,
                title: 'Quotation Details',
                children: [
                  _buildInfoRow('Price:', '₹ ${widget.quotation.price}'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Notes:', widget.quotation.meta.notes),
                  const SizedBox(height: 12),
                  _buildInfoRow('Created At:', _formatDate(widget.quotation.createdAt)),
                  const SizedBox(height: 12),
                  _buildInfoRow('Updated At:', _formatDate(widget.quotation.updatedAt)),
                  const SizedBox(height: 12),
                  _buildInfoRow('Converted:', widget.quotation.isConverted ? 'Yes' : 'No'),
                ],
              ),

              const SizedBox(height: 24),

              // Status Change Section
              if (!widget.quotation.isConverted)
                _buildStatusChangeSection(),

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
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Status: ${capitalizeEachWord(_selectedStatus??'')}',
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
        border: Border.all(
          color: ColorRes.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: ColorRes.textSecondary,
              ),
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
            value,
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
        border: Border.all(
          color: ColorRes.border,
          width: 1,
        ),
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
                borderSide: const BorderSide(
                  color: ColorRes.primary,
                  width: 2,
                ),
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
            items: _statusOptions.map((String status) {
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
              onPressed: _selectedStatus != capitalizeEachWord(widget.quotation.status)
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
        if (!widget.quotation.isConverted)
          SizedBox(
            width: double.infinity,
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
            ),
          ),),),

        if (!widget.quotation.isConverted) const SizedBox(height: 12),

        // Download PDF Button
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

        // Convert to Lead Button
        if (!widget.quotation.isConverted)
          SizedBox(
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

        if (!widget.quotation.isConverted) const SizedBox(height: 12),

        // Delete Button
        SizedBox(
          width: double.infinity,
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
              side: const BorderSide(
                color: ColorRes.error,
                width: 1.5,
              ),
            ),
          ),
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirm Status Change',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
    Get.to(() => ContractorInquiryQuotationScreen(
      quotation: widget.quotation,
      isEditMode: true,
    ));
  }

  String capitalizeEachWord(String text) {
    if (text.isEmpty) return text;
    return text.split('_').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }


  Future<void> _downloadQuotationPDF() async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );

      final pdf = pw.Document();

      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              _buildPDFHeader(),
              pw.SizedBox(height: 30),

              // Quotation ID and Date
              _buildPDFQuotationInfo(),
              pw.SizedBox(height: 20),

              // Customer Details
              _buildPDFSection('Customer Details', [
                _buildPDFRow('Name', widget.quotation.user.name),
                _buildPDFRow('Phone', widget.quotation.user.phone),
                _buildPDFRow('Email', widget.quotation.user.email),
              ]),
              pw.SizedBox(height: 20),

              // Property Details
              _buildPDFSection('Property Details', [
                _buildPDFRow('Type', widget.quotation.meta.propertyDetails?.propertyType??''),
                _buildPDFRow('City', widget.quotation.meta.propertyDetails?.city??''),
                _buildPDFRow('Location', widget.quotation.meta.propertyDetails?.location??''),
                _buildPDFRow('State', widget.quotation.meta.propertyDetails?.state??''),
                _buildPDFRow('Carpet Area', '${widget.quotation.meta.propertyDetails?.carpetArea} sq.ft'),
                if (widget.quotation.meta.propertyDetails?.bhk != null)
                  _buildPDFRow('BHK', '${widget.quotation.meta.propertyDetails?.bhk}'),
              ]),
              pw.SizedBox(height: 20),

              // Service Details
              _buildPDFSection('Service Details', [
                _buildPDFRow('Services', widget.quotation.meta.serviceNames??''),
                _buildPDFRow('Description', widget.quotation.meta.propertyDetails?.serviceDescription??''),
              ]),
              pw.SizedBox(height: 20),

              // Notes
              _buildPDFSection('Notes', [
                pw.Text(
                  widget.quotation.meta.notes,
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
                ),
              ]),
              pw.SizedBox(height: 30),

              // Price Section
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#E3F2FD'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Quotation Price',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#1976D2'),
                      ),
                    ),
                    pw.Text(
                      '₹ ${widget.quotation.price}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#1976D2'),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Status
              pw.Row(
                children: [
                  pw.Text(
                    'Status: ',
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: _getPDFStatusColor(widget.quotation.status),
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      widget.quotation.status.toUpperCase(),
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
                    ),
                  ),
                ],
              ),

              pw.Spacer(),

              // Footer
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on ${_formatDate(DateTime.now())}',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                'This is a system-generated quotation',
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                textAlign: pw.TextAlign.center,
              ),
            ];
          },
        ),
      );

      // Close loading dialog
      Get.back();

      // Show save/share dialog
      await _showPDFOptions(pdf);
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to generate PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorRes.error,
        colorText: ColorRes.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  pw.Widget _buildPDFHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#1976D2'),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'QUOTATION',
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Professional Service Quotation',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPDFQuotationInfo() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Quotation ID',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '#${widget.quotation.id.substring(0, 12).toUpperCase()}',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Date',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              _formatDate(widget.quotation.createdAt),
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPDFSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPDFRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
            ),
          ),
        ],
      ),
    );
  }

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
      final file = File('${directory.path}/quotation_${widget.quotation.id.substring(0, 8)}.pdf');
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
