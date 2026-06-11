import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_quotation_controller.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_dashboard_controller.dart';
import 'package:nesticope_app/modules/contractor/view/widget/contractor_inquiry_quotation_screen.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:timeago/timeago.dart' as currencyFormat;

import '../../../../widgets/messages/snack_bar.dart';
import '../../controller/contractor_referral_controller.dart';

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
  int advanceAmount = 0;
  int advancePercentage = 0;

  final List<String> _statusOptions = ['Pending', 'Accepted', 'Rejected'];
   ContractorQuotationController _quotationController =
      Get.find<ContractorQuotationController>();

  @override
  void initState() {
    super.initState();
    // Capitalize first letter to match dropdown items
    setState(() {
      advancePercentage = widget.quotation.meta.advanceRequiredPercentage;
      double price = double.tryParse(widget.quotation.price) ?? 0;
      advanceAmount = ((price * advancePercentage) / 100).round();
    });
    _currentStatus =
        widget.quotation.status.isNotEmpty
            ? capitalizeEachWord(widget.quotation.status)
            : 'Pending';
    _selectedStatus = _currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    bool hasMaterialSpecs = [
      widget.quotation.meta.cementBrand,
      widget.quotation.meta.steelBrand,
      widget.quotation.meta.brickType,
      widget.quotation.meta.sandSource,
      widget.quotation.meta.falseCeiling,
      widget.quotation.meta.fabricationWork,
      widget.quotation.meta.waterTankBrand,
      widget.quotation.meta.brickType,
      widget.quotation.meta.cementBrand,
      widget.quotation.meta.chokhatType,
      widget.quotation.meta.doorsType,
      widget.quotation.meta.electricalSwitchesBrand,
      widget.quotation.meta.electricalWiresBrand,
      widget.quotation.meta.exteriorPaintBrand,
      widget.quotation.meta.flooringTilesBrand,
      widget.quotation.meta.interiorPaintBrand,
      widget.quotation.meta.plasterType,
      widget.quotation.meta.plumbingPipesBrand,
      widget.quotation.meta.railingType,
      widget.quotation.meta.steelBrand,
      widget.quotation.meta.structure,
      widget.quotation.meta.waterproofing,
      widget.quotation.meta.windowsType,
    ].any((e) => e?.isNotEmpty ?? false);
    bool hasAdditionalDetails = [
      widget.quotation.meta.design3D,
      widget.quotation.meta.boreAndPump,
      widget.quotation.meta.homeAutomation,
      widget.quotation.meta.modularKitchen,
      widget.quotation.meta.securitySystems,
      widget.quotation.meta.solarSolutions,
    ].any((e) => e != null && e.trim().isNotEmpty);

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
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Expected Start Date:',
                    DateFormat(
                      'MM/dd/yyyy',
                    ).format(widget.quotation.meta.expectedStartDate),
                  ),
                  // const SizedBox(height: 12),
                  if (hasMaterialSpecs) ...[
                    const SizedBox(height: 12),
                    Divider(color: ColorRes.leadGreyColor.shade400),
                    const SizedBox(height: 12),

                    // Material Specifications
                    Text(
                      'Material Specifications',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    buildOptionalRow(
                      'Cement Brand:',
                      widget.quotation.meta.cementBrand,
                    ),
                    buildOptionalRow(
                      'Steel Brand:',
                      widget.quotation.meta.steelBrand,
                    ),
                    buildOptionalRow(
                      'Bricks Type:',
                      widget.quotation.meta.brickType,
                    ),
                    buildOptionalRow(
                      'Sand Source:',
                      widget.quotation.meta.sandSource,
                    ),
                    buildOptionalRow(
                      'Electrical Wires:',
                      widget.quotation.meta.electricalWiresBrand,
                    ),
                    buildOptionalRow(
                      'Switches / Sockets:',
                      widget.quotation.meta.electricalSwitchesBrand,
                    ),
                    buildOptionalRow(
                      'Plumbing Pipes:',
                      widget.quotation.meta.plumbingPipesBrand,
                    ),
                    buildOptionalRow(
                      'Sanitary / WC:',
                      widget.quotation.meta.sanitaryFittingsBrand,
                    ),
                    buildOptionalRow(
                      'Water Tank:',
                      widget.quotation.meta.waterTankBrand,
                    ),
                    buildOptionalRow(
                      'Flooring Tiles:',
                      widget.quotation.meta.flooringTilesBrand,
                    ),
                    buildOptionalRow(
                      'Interior Paint:',
                      widget.quotation.meta.interiorPaintBrand,
                    ),
                    buildOptionalRow(
                      'Exterior Paint:',
                      widget.quotation.meta.exteriorPaintBrand,
                    ),
                    buildOptionalRow(
                      'Doors Type:',
                      widget.quotation.meta.doorsType,
                    ),
                    buildOptionalRow(
                      'Windows Type:',
                      widget.quotation.meta.windowsType,
                    ),
                    buildOptionalRow(
                      'Structure:',
                      widget.quotation.meta.structure,
                    ),
                    buildOptionalRow(
                      'Plaster:',
                      widget.quotation.meta.plasterType,
                    ),
                    buildOptionalRow(
                      'Waterproofing:',
                      widget.quotation.meta.waterproofing,
                    ),
                    buildOptionalRow(
                      'Chokhat Type:',
                      widget.quotation.meta.chokhatType,
                    ),
                    buildOptionalRow(
                      'Railing Type:',
                      widget.quotation.meta.railingType,
                    ),
                    buildOptionalRow(
                      'False Ceiling:',
                      widget.quotation.meta.falseCeiling,
                    ),
                    buildOptionalRow(
                      'Fabrication Work:',
                      widget.quotation.meta.fabricationWork,
                    ),
                  ],
                  if (hasAdditionalDetails) ...[
                    Divider(color: ColorRes.leadGreyColor.shade400),
                    const SizedBox(height: 12),

                    // Additional Services
                    Text(
                      'Additional Services',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    buildOptionalTextRow(
                      'Modular Kitchen:',
                      widget.quotation.meta.modularKitchen,
                    ),
                    buildOptionalTextRow(
                      'Bore and Pump:',
                      widget.quotation.meta.boreAndPump,
                    ),
                    buildOptionalTextRow(
                      'Security Systems:',
                      widget.quotation.meta.securitySystems,
                    ),
                    buildOptionalTextRow(
                      'Home Automation:',
                      widget.quotation.meta.homeAutomation,
                    ),
                    buildOptionalTextRow(
                      'Solar Solutions:',
                      widget.quotation.meta.solarSolutions,
                    ),
                  ],

                  // Add this where you want to show the advance payment info
                  if (advancePercentage > 0 && advanceAmount > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADVANCE PAYMENT REQUIRED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$advancePercentage% (${Formatter.formatPrice(advanceAmount)})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              // Price Summary Section
              _buildPriceSummarySection(),

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
                  _buildInfoRow('Notes:', widget.quotation.meta.notes ?? ''),
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
              _buildActionButtons(_quotationController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummarySection() {
    // Get base price from meta
    final double basePrice = widget.quotation.meta.basePrice ?? 0;

    // Get discount information
    final double discountPercentage =
        widget.quotation.meta.discountPercentage ?? 0;
    final double discountAmount = widget.quotation.meta.discountAmount ?? 0;

    // Calculate discounted price (base price - discount amount)
    final double priceAfterDiscount = basePrice - discountAmount;

    // Get GST information
    final bool isGstEnabled = widget.quotation.meta.isGstEnabled ?? false;
    final double gstPercentage = widget.quotation.meta.gstPercentage ?? 0;
    final double gstAmount = widget.quotation.meta.gstAmount ?? 0;

    // Calculate total price (discounted price + GST)
    final double totalPrice =
        widget.quotation.meta.totalPrice ?? (priceAfterDiscount + gstAmount);

    return _buildSectionCard(
      children: [
        _buildSummaryRow('Base Price', Formatter.formatPrice(basePrice)),

        // Show discount if applicable
        if (discountAmount > 0) ...[
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Discount (${discountPercentage.toStringAsFixed(0)}%)',
            '- ${Formatter.formatPrice(discountAmount)}',
            valueColor: ColorRes.success,
          ),
          const SizedBox(height: 4),
          Text(
            '(Buyer\'s referral points benefit)',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],

        // Show GST if enabled
        if (isGstEnabled && gstAmount > 0) ...[
          const SizedBox(height: 8),
          _buildSummaryRow(
            'GST (${gstPercentage.toStringAsFixed(0)}%)',
            Formatter.formatPrice(gstAmount),
            valueColor: ColorRes.primary,
          ),
        ],

        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(),
        ),

        Row(
          children: [
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isGstEnabled ? 'Total Price (Incl. GST)' : 'Total Price',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 6),

                Text(
                  Formatter.formatPrice(totalPrice),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorRes.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      title: 'Price Summery',
      icon: Icons.attach_money_outlined,
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget buildOptionalRow(String label, List<String>? values) {
    if (values == null || values.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _buildInfoRow(label, values.join(', ')),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildOptionalTextRow(String label, String? value) {
    if (value == null || value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [_buildInfoRow(label, value), const SizedBox(height: 12)],
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
         boxShadow: [
          BoxShadow(
            color: ColorRes.primary.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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

  Widget _buildActionButtons(ContractorQuotationController _quotationController) {
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
        if (widget.quotation.isConverted) ...[
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                // onPressed: _downloadQuotationPDF,
                  onPressed: () {
                _quotationController.getQuotation(widget.quotation.id);
                  },
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
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: (){
                 _quotationController.getQuotation(widget.quotation.id);
              },
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
          const SizedBox(height: 12),
        ],

        // Convert to Lead Button
        if (!widget.quotation.isConverted)
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Obx(() {
                final dashboardController = Get.isRegistered<ContractorDashboardController>()
                    ? Get.find<ContractorDashboardController>()
                    : Get.put(ContractorDashboardController());

                final bool showDisabledStyle = !dashboardController.hasActivePlan ||
                    (dashboardController.activeSubscription.value?.isLeadLimitReached ?? true);

                return ElevatedButton.icon(
                  onPressed: () async {
                    if (showDisabledStyle) {
                      await dashboardController.showUpgradePlanDialog(
                        title: dashboardController.hasActivePlan
                            ? 'Limit Reached'
                            : 'Active plan required',
                        message: dashboardController.hasActivePlan
                            ? 'Limit Reached, please upgrade your plan.'
                            : 'You do not have an active subscription. Please activate a plan to continue.',
                      );
                      return;
                    }

                    _convertToLead();
                  },
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
                    backgroundColor:
                        showDisabledStyle ? Colors.grey.shade400 : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                );
              }),
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
        title: Text(
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
    final dashboardController = Get.find<ContractorDashboardController>();
    final bool showDisabledStyle = !dashboardController.hasActivePlan ||
        (dashboardController.activeSubscription.value?.isLeadLimitReached ?? true);

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
            onPressed: () async {
              Navigator.pop(context);

              if (showDisabledStyle) {
                await dashboardController.showUpgradePlanDialog(
                  title: dashboardController.hasActivePlan
                      ? 'Limit Reached'
                      : 'Active plan required',
                  message: dashboardController.hasActivePlan
                      ? 'Limit Reached, please upgrade your plan.'
                      : 'You do not have an active subscription. Please activate a plan to continue.',
                );
                return;
              }

              final controller = Get.find<ContractorQuotationController>();
              controller.convertIntoLead(widget.quotation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: showDisabledStyle
                  ? Colors.grey.shade400
                  : Colors.green,
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
    Get.put(ContractorReferralController(userId: widget.quotation.user.id));
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

  /*
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
      final file = await savePdfToTemp(
        pdf,
        widget.quotation.id.substring(0, 8),
      );

      Get.back(); // close loader

      // Open preview
      Get.to(
            () => QuotationPdfPreviewScreen(file: file),
      );
     */

  /*
    } catch (e, stackTrace) {
      Get.back(); // Close loading dialog
      print('PDF Generation Error: $e');
      print('Stack Trace: $stackTrace');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to generate PDF: ${e.toString()}',
        contentType: ContentType.failure,
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

    if (widget.quotation.meta.notes?.isNotEmpty ?? false) {
      String cleanNotes =
          widget.quotation.meta.notes?.replaceAll(
            'Generated from inquiry for: ',
            '',
          ) ??
          '';
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
  Future<File> savePdfToTemp(
      pw.Document pdf,
      String quotationId,
      ) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();

    final file = File('${dir.path}/quotation_$quotationId.pdf');

    // overwrite same file every time
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }


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
}*/

  Future<void> _downloadQuotationPDF() async {
    final user = await SecureStorage.getUserData();
    log("user : $user");
    Uint8List logoBytes =
        (await rootBundle.load(
          'assets/images/NesticoPe_logo.png',
        )).buffer.asUint8List();
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

      // Define colors matching the provided PDF
      final headerColor = PdfColor.fromInt(0xFF2C3E50); // Dark blue/gray
      final accentColor = PdfColor.fromInt(0xFF3498DB); // Blue accent
      final lightGray = PdfColor.fromInt(0xFFF5F5F5);
      final darkText = PdfColors.black;
      final grayText = PdfColor.fromInt(0xFF555555);

      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),

          header:
              (context) => pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 30,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xff277FB8),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // LEFT
                    pw.Stack(
                      children: [
                        pw.Image(
                          pw.MemoryImage(logoBytes),
                          width: 120,
                          height: 120,
                          fit: pw.BoxFit.cover,
                        ),

                        pw.Positioned(
                          top: 70,
                          left: 10,
                          child: pw.Text(
                            'REAL ESTATE SIMPLIFIED',
                            style: pw.TextStyle(
                              fontSize: 5,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    pw.Spacer(),

                    // RIGHT
                    pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _buildInfoPDFRow(
                          'QUOTATION #',
                          widget.quotation.quotationNumber,
                        ),
                        pw.SizedBox(height: 4),
                        _buildInfoPDFRow(
                          'DATE',
                          _formatQuotationDate(widget.quotation.createdAt),
                        ),
                        pw.SizedBox(height: 4),
                        _buildInfoPDFRow(
                          'VALID UNTIL',
                          _formatValidUntilDate(widget.quotation.createdAt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

          footer: (context) {
            // Only show full footer on the last page
            if (context.pageNumber == context.pagesCount) {
              return pw.Padding(
                padding: const pw.EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.SizedBox(height: 12),
                    pw.Container(
                      height: 5,
                      width: double.infinity,
                      decoration: pw.BoxDecoration(color: PdfColors.blue600),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'Thank You for your business!',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: headerColor,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Generated via NesticoPe Platform',
                            style: pw.TextStyle(fontSize: 9, color: grayText),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: pw.TextStyle(fontSize: 8, color: grayText),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Simple footer for other pages
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Column(
                  children: [
                    pw.SizedBox(height: 12),
                    pw.Container(
                      height: 5,
                      width: double.infinity,
                      decoration: pw.BoxDecoration(color: PdfColors.blue600),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Center(
                      child: pw.Column(
                        children: [
                          pw.Text(
                            'Thank You for your business!',
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: headerColor,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            'Generated via NesticoPe Platform',
                            style: pw.TextStyle(fontSize: 9, color: grayText),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: pw.TextStyle(fontSize: 8, color: grayText),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          build: (pw.Context context) {
            return [
              pw.Padding(
                padding: const pw.EdgeInsets.all(30),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Customer Details
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'CUSTOMER DETAILS',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: headerColor,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              widget.quotation.user.name,
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            _buildDetailRow(
                              'Phone:',
                              widget.quotation.user.phone,
                            ),
                            _buildDetailRow(
                              'Email:',
                              widget.quotation.user.email,
                            ),
                          ],
                        ),

                        pw.Spacer(),

                        // Contractor Details
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'CONTRACTOR DETAILS',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: headerColor,
                              ),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              (user?.user?.fullName.isEmpty ?? false)
                                  ? user?.user?.username ?? ''
                                  : user?.user?.fullName ?? 'N/A',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            _buildDetailRow(
                              'Phone:',
                              user?.user?.phone ?? 'N/A',
                            ),
                            _buildDetailRow(
                              'City:',
                              widget.quotation.meta.propertyDetails?.city ??
                                  'N/A',
                            ),
                            _buildDetailRow('Rating on NesticoPe:', '0/5'),
                          ],
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 25),

                    // Property Details Section
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        // Title
                        pw.Text(
                          'Property Details',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: headerColor,
                          ),
                        ),

                        pw.SizedBox(height: 8),

                        // Header Row
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey100,
                          ),
                          child: pw.Row(
                            children: [
                              pw.Expanded(flex: 2, child: _tableHeader('Type')),
                              pw.Expanded(
                                flex: 5,
                                child: _tableHeader('City / Location'),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: _tableHeader(
                                  'Area (Sq ft)',
                                  alignRight: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Data Row
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey200,
                          ),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: _tableCell(
                                  widget
                                          .quotation
                                          .meta
                                          .propertyDetails
                                          ?.propertyType ??
                                      'N/A',
                                ),
                              ),
                              pw.Expanded(
                                flex: 5,
                                child: _tableCell(
                                  '${widget.quotation.meta.propertyDetails?.city ?? 'N/A'}, '
                                  '${widget.quotation.meta.propertyDetails?.location ?? 'N/A'}',
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: _tableCell(
                                  widget
                                          .quotation
                                          .meta
                                          .propertyDetails
                                          ?.carpetArea
                                          ?.toString() ??
                                      'N/A',
                                  alignRight: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 20),

                    // Material Brands & Specifications Section
                    pw.Text(
                      'Material Brands & Specifications',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: headerColor,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    ..._buildMaterialBrandsList(),

                    pw.SizedBox(height: 20),

                    // Expected Start Date
                    /* pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: lightGray,
                        border: pw.Border.all(color: PdfColors.grey300),
                      ),
                      child: pw.Row(
                        children: [
                          pw.Text(
                            'EXPECTED START',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: headerColor,
                            ),
                          ),
                          pw.SizedBox(width: 20),
                          pw.Text(
                            _formatQuotationDate(
                              widget.quotation.meta.expectedStartDate,
                            ),
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 20),*/

                    // Service Scope & Pricing Section

                    // Service Table
                    _buildServiceTable(),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Notes',
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: headerColor,
                                ),
                              ),
                              pw.SizedBox(height: 6),
                              pw.Text(
                                _getNotes(),
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  color: grayText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 16),
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: pw.BoxDecoration(
                              color: lightGray,
                              border: pw.Border.all(color: PdfColors.grey300),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Terms & Conditions',
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: headerColor,
                                  ),
                                ),
                                pw.SizedBox(height: 6),
                                _buildTermRow(
                                  '1. Payments shall be released based on pre-defined project milestones.',
                                ),
                                _buildTermRow(
                                  '2. NesticoPe platform shall not be held liable for any disputes.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
        barrierColor: Colors.black.withOpacity(0.4),
      );

      final file = await savePdfToTemp(pdf, widget.quotation.quotationNumber);

      Get.back(); // close loader

      // Open preview
      Get.to(() => QuotationPdfPreviewScreen(file: file));
    } catch (e, stackTrace) {
      Get.back(); // Close loading dialog
      print('PDF Generation Error: $e');
      print('Stack Trace: $stackTrace');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to generate PDF: ${e.toString()}',
        contentType: ContentType.failure,
      );
    }
  }

  // Helper method to build info rows (QUOTATION #, DATE, etc.)
  pw.Widget _buildInfoPDFRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Container(
          width: 100,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.white),
        ),
      ],
    );
  }

  // Helper method to build detail rows
  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        children: [
          pw.Text(
            '$label ',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  // Helper method for propert
  List<pw.Widget> _buildMaterialBrandsList() {
    List<Map<String, String>> materials = [];
    final DateTime? startDate = widget.quotation.meta.expectedStartDate;

    // ... (all your material additions)
    if (widget.quotation.meta.cementBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'CEMENT',
        'value': widget.quotation.meta.cementBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.steelBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'STEEL',
        'value': widget.quotation.meta.steelBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.brickType?.isNotEmpty ?? false) {
      materials.add({
        'label': 'BRICKS',
        'value': widget.quotation.meta.brickType!.join(', '),
      });
    }
    if (widget.quotation.meta.sandSource?.isNotEmpty ?? false) {
      materials.add({
        'label': 'SAND',
        'value': widget.quotation.meta.sandSource!.join(', '),
      });
    }
    if (widget.quotation.meta.electricalWiresBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'WIRES',
        'value': widget.quotation.meta.electricalWiresBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.electricalSwitchesBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'SWITCHES',
        'value': widget.quotation.meta.electricalSwitchesBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.plumbingPipesBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'PIPES',
        'value': widget.quotation.meta.plumbingPipesBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.sanitaryFittingsBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'SANITARY',
        'value': widget.quotation.meta.sanitaryFittingsBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.waterTankBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'WATER TANK',
        'value': widget.quotation.meta.waterTankBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.flooringTilesBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'FLOORING',
        'value': widget.quotation.meta.flooringTilesBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.interiorPaintBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'INTERIOR PAINT',
        'value': widget.quotation.meta.interiorPaintBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.exteriorPaintBrand?.isNotEmpty ?? false) {
      materials.add({
        'label': 'EXTERIOR PAINT',
        'value': widget.quotation.meta.exteriorPaintBrand!.join(', '),
      });
    }
    if (widget.quotation.meta.doorsType?.isNotEmpty ?? false) {
      materials.add({
        'label': 'DOORS',
        'value': widget.quotation.meta.doorsType!.join(', '),
      });
    }
    if (widget.quotation.meta.windowsType?.isNotEmpty ?? false) {
      materials.add({
        'label': 'WINDOWS',
        'value': widget.quotation.meta.windowsType!.join(', '),
      });
    }
    if (widget.quotation.meta.structure?.isNotEmpty ?? false) {
      materials.add({
        'label': 'STRUCTURE',
        'value': widget.quotation.meta.structure!.join(', '),
      });
    }
    if (widget.quotation.meta.plasterType?.isNotEmpty ?? false) {
      materials.add({
        'label': 'PLASTER',
        'value': widget.quotation.meta.plasterType!.join(', '),
      });
    }
    if (widget.quotation.meta.waterproofing?.isNotEmpty ?? false) {
      materials.add({
        'label': 'WATERPROOFING',
        'value': widget.quotation.meta.waterproofing!.join(', '),
      });
    }
    if (widget.quotation.meta.chokhatType?.isNotEmpty ?? false) {
      materials.add({
        'label': 'CHOKHAT',
        'value': widget.quotation.meta.chokhatType!.join(', '),
      });
    }
    if (widget.quotation.meta.railingType?.isNotEmpty ?? false) {
      materials.add({
        'label': 'RAILING',
        'value': widget.quotation.meta.railingType!.join(', '),
      });
    }
    if (widget.quotation.meta.falseCeiling?.isNotEmpty ?? false) {
      materials.add({
        'label': 'FALSE CEILING',
        'value': widget.quotation.meta.falseCeiling!.join(', '),
      });
    }
    if (widget.quotation.meta.modularKitchen?.isNotEmpty ?? false) {
      materials.add({
        'label': 'MODULAR KITCHEN',
        'value': widget.quotation.meta.modularKitchen!,
      });
    }
    if (widget.quotation.meta.boreAndPump?.isNotEmpty ?? false) {
      materials.add({
        'label': 'BORE AND PUMP',
        'value': widget.quotation.meta.boreAndPump!,
      });
    }
    if (widget.quotation.meta.securitySystems?.isNotEmpty ?? false) {
      materials.add({
        'label': 'SECURITY SYSTEMS',
        'value': widget.quotation.meta.securitySystems!,
      });
    }
    if (widget.quotation.meta.homeAutomation?.isNotEmpty ?? false) {
      materials.add({
        'label': 'HOME AUTOMATION',
        'value': widget.quotation.meta.homeAutomation!,
      });
    }
    if (widget.quotation.meta.solarSolutions?.isNotEmpty ?? false) {
      materials.add({
        'label': 'SOLAR SOLUTIONS',
        'value': widget.quotation.meta.solarSolutions!,
      });
    }
    if (widget.quotation.meta.fabricationWork?.isNotEmpty ?? false) {
      materials.add({
        'label': 'FABRICATION',
        'value': widget.quotation.meta.fabricationWork!.join(', '),
      });
    }

    if (widget.quotation.meta.design3D?.isNotEmpty ?? false) {
      materials.add({
        'label': '3D Design',
        'value': widget.quotation.meta.design3D ?? '',
      });
    }
    if (widget.quotation.meta.solarSolutions?.isNotEmpty ?? false) {
      materials.add({
        'label': 'Solar Solutions',
        'value': widget.quotation.meta.solarSolutions ?? '',
      });
    }
    if (widget.quotation.meta.securitySystems?.isNotEmpty ?? false) {
      materials.add({
        'label': 'Security Systems',
        'value': widget.quotation.meta.securitySystems ?? '',
      });
    }
    if (widget.quotation.meta.modularKitchen?.isNotEmpty ?? false) {
      materials.add({
        'label': 'Modular Kitchen',
        'value': widget.quotation.meta.modularKitchen ?? '',
      });
    }
    if (widget.quotation.meta.homeAutomation?.isNotEmpty ?? false) {
      materials.add({
        'label': 'Home Automation',
        'value': widget.quotation.meta.homeAutomation ?? '',
      });
    }
    if (widget.quotation.meta.boreAndPump?.isNotEmpty ?? false) {
      materials.add({
        'label': 'Bore And Pump',
        'value': widget.quotation.meta.boreAndPump ?? '',
      });
    }
    if (startDate != null) {
      materials.add({
        'label': 'EXPECTED START',
        'value': _formatQuotationDate(startDate),
      });
    }
    if (materials.isEmpty) {
      return [];
    }

    // Categorize materials by content length
    List<Map<String, String>> shortItems = [];
    List<Map<String, String>> mediumItems = [];
    List<Map<String, String>> longItems = [];

    for (var material in materials) {
      final contentLength = material['value']!.length;
     /* if (contentLength <= 20) {
        shortItems.add(material);
      } else if (contentLength <= 50) {
        mediumItems.add(material);
      } else {*/
        longItems.add(material);
      // }
    }

    List<pw.Widget> rows = [];

    // Build rows for short items (4 per row)
/*    rows.addAll(_buildMaterialRows(shortItems, 4));

    // Build rows for medium items (3 per row)
    rows.addAll(_buildMaterialRows(mediumItems, 4));*/

    // Build rows for long items (2 per row)
    rows.addAll(_buildMaterialRows(longItems, 4));

    return rows;
  }

  List<pw.Widget> _buildMaterialRows(
    List<Map<String, String>> materials,
    int itemsPerRow,
  ) {
    if (materials.isEmpty) return [];

    List<pw.Widget> rows = [];


    for (int i = 0; i < materials.length; i += itemsPerRow) {
      final rowMaterials = materials.sublist(
        i,
        i + itemsPerRow > materials.length ? materials.length : i + itemsPerRow,
      );


      rows.add(
        pw.Padding(
          padding: pw.EdgeInsets.only(right: 15,top: 4,bottom: 4),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              ...rowMaterials.map((material) {

                return pw.SizedBox(
                  width: 130,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 8),
                    child: pw.Container(
                      height: 50,
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromInt(0xFFF7FAFC),
                        border: pw.Border.all(
                          width: 1,
                          color: PdfColors.grey300,
                        ),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            material['label']!,
                            style: pw.TextStyle(
                              fontSize: 7,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            material['value']!,
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              // Fill empty columns
              /*...List.generate(
        itemsPerRow - rowMaterials.length,
            (index) => pw.Expanded(child: pw.SizedBox()),
              ),*/
            ],
          ),
        ),
      );
    }

    return rows;
  }

  pw.Widget _tableHeader(String text, {bool alignRight = false}) {
    return pw.Text(
      text,
      textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey700,
      ),
    );
  }

  pw.Widget _tableCell(String text, {bool alignRight = false}) {
    return pw.Text(
      text,
      textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
      style: pw.TextStyle(fontSize: 9, color: PdfColors.black),
    );
  }

  // Build Service Table
  // pw.Widget _buildServiceTable() {
  //   final headerColor = PdfColor.fromInt(0xFF2C3E50);
  //   final lightGray = PdfColor.fromInt(0xFFF5F5F5);
  //
  //   String description =
  //       widget.quotation.meta.serviceNames ?? 'General Service';
  //
  //   if (widget.quotation.meta.notes?.isNotEmpty ?? false) {
  //     String cleanNotes =
  //         widget.quotation.meta.notes?.replaceAll(
  //           'Generated from inquiry for: ',
  //           '',
  //         ) ??
  //         '';
  //     if (!description.contains(cleanNotes) && cleanNotes.isNotEmpty) {
  //       description +=
  //           description.isNotEmpty ? '\n\nNote: ($cleanNotes)' : cleanNotes;
  //     }
  //   }
  //
  //   final price =
  //       double.tryParse(
  //         widget.quotation.price.toString().replaceAll(',', ''),
  //       ) ??
  //       0;
  //   final advancePercentage = widget.quotation.meta.advanceRequiredPercentage;
  //   final advanceAmount = (price * advancePercentage) / 100;
  //
  //   return pw.Table(
  //     border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
  //     columnWidths: {
  //       0: const pw.FlexColumnWidth(3),
  //       1: const pw.FlexColumnWidth(1),
  //       2: const pw.FlexColumnWidth(1.5),
  //     },
  //     children: [
  //       // Header Row
  //       pw.TableRow(
  //         decoration: pw.BoxDecoration(color: lightGray),
  //         children: [
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(8),
  //             child: pw.Text(
  //               'Service Description',
  //               style: pw.TextStyle(
  //                 fontSize: 10,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: headerColor,
  //               ),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(8),
  //             child: pw.Text(
  //               'Adv. Payment %',
  //               style: pw.TextStyle(
  //                 fontSize: 10,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: headerColor,
  //               ),
  //               textAlign: pw.TextAlign.center,
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(8),
  //             child: pw.Text(
  //               'Amount (INR)',
  //               style: pw.TextStyle(
  //                 fontSize: 10,
  //                 fontWeight: pw.FontWeight.bold,
  //                 color: headerColor,
  //               ),
  //               textAlign: pw.TextAlign.right,
  //             ),
  //           ),
  //         ],
  //       ),
  //       // Data Row
  //       pw.TableRow(
  //         children: [
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(8),
  //             child: pw.Text(
  //               description,
  //               style: const pw.TextStyle(fontSize: 9),
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(8),
  //             child: pw.Text(
  //               '$advancePercentage%',
  //               style: const pw.TextStyle(fontSize: 9),
  //               textAlign: pw.TextAlign.center,
  //             ),
  //           ),
  //           pw.Padding(
  //             padding: const pw.EdgeInsets.all(8),
  //             child: pw.Text(
  //               _formatIndianCurrency(price),
  //               style: const pw.TextStyle(fontSize: 9),
  //               textAlign: pw.TextAlign.right,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  pw.Widget _buildServiceTable() {
    final headerColor = PdfColor.fromInt(0xFF2C3E50);
    final lightGray = PdfColor.fromInt(0xFFF5F5F5);
    final totalBg = PdfColor.fromInt(0xFFE8F5E9);

    // 1. Service Description
    String description =
        widget.quotation.meta.serviceNames ?? 'General Service';

    if (widget.quotation.meta.notes?.isNotEmpty ?? false) {
      String cleanNotes =
          widget.quotation.meta.notes?.replaceAll(
            'Generated from inquiry for: ',
            '',
          ) ??
          '';

      if (!description.contains(cleanNotes) && cleanNotes.isNotEmpty) {
        description +=
            description.isNotEmpty ? '\n\nNote: ($cleanNotes)' : cleanNotes;
      }
    }

    // 2. Pricing Logic
    final basePrice =
        double.tryParse(
          widget.quotation.meta.basePrice.toString().replaceAll(',', ''),
        ) ??
        0;

    final discountAmount =
        double.tryParse(
          widget.quotation.meta.discountAmount.toString().replaceAll(',', ''),
        ) ??
        0;

    final discountPercent =
        double.tryParse(
          widget.quotation.meta.discountPercentage.toString().replaceAll(
            ',',
            '',
          ),
        ) ??
        0;

    final gstAmount =
        double.tryParse(
          widget.quotation.meta.gstAmount.toString().replaceAll(',', ''),
        ) ??
        0;

    final gstPercentage =
        double.tryParse(
          widget.quotation.meta.gstPercentage.toString().replaceAll(',', ''),
        ) ??
        0;

    final totalAmount =
        double.tryParse(
          widget.quotation.price.toString().replaceAll(',', ''),
        ) ??
        0;

    final isGSTEnable = widget.quotation.meta.isGstEnabled ?? false;

    // Advance
    final advancePercentage = widget.quotation.meta.advanceRequiredPercentage;
    final advanceAmount = (totalAmount * advancePercentage) / 100;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Service Scope & Pricing',
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: headerColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1.5),
          },
          children: [
            // HEADER
            pw.TableRow(
              decoration: pw.BoxDecoration(color: lightGray),

              children: [
                _pdfHeaderCell('Description', headerColor),
                _pdfHeaderCell(
                  'Rate/Info',
                  headerColor,
                  align: pw.TextAlign.center,
                ),
                _pdfHeaderCell(
                  'Amount (INR)',
                  headerColor,
                  align: pw.TextAlign.right,
                ),
              ],
            ),

            // SERVICE DESCRIPTION ROW
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    description,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'Adv: $advancePercentage%',
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        '(${_formatIndianCurrency(advanceAmount)})',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(''),
                ),
              ],
            ),

            // BASE AMOUNT
            _priceRow('Base Amount', basePrice),

            // DISCOUNT (optional)
            if (discountAmount > 0)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Discount',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                        pw.Text(
                          "(Buyer's referral points benefit)",
                          style: pw.TextStyle(
                            fontSize: 7,
                            color: PdfColors.grey700,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    child: pw.Text(
                      '${discountPercent.toStringAsFixed(0)}%',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: pw.Text(
                      '-${_formatIndianCurrency(discountAmount)}',
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),

            // GST ROW
            if (isGSTEnable && gstAmount > 0)
              _priceRow('GST (${gstPercentage}%)', gstAmount),

            // TOTAL ROW (highlighted)
            pw.TableRow(
              decoration: pw.BoxDecoration(color: totalBg),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    'Total Quotation Amount (Inclusive of all taxes)',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    _formatIndianCurrency(totalAmount),
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _pdfHeaderCell(
    String text,
    PdfColor color, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  pw.TableRow _priceRow(String label, double amount) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('')),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: pw.Text(
            _formatIndianCurrency(amount),
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
      ],
    );
  }

  // Helper method for term rows
  pw.Widget _buildTermRow(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, color: PdfColor.fromInt(0xFF555555)),
      ),
    );
  }

  // Format Indian Currency
  String _formatIndianCurrency(double amount) {
    final s = amount.toStringAsFixed(0);
    final n = s.length;
    if (n <= 3) return 'Rs. $s';
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

  // Get Notes
  String _getNotes() {
    List<String> notes = [];

    notes.add('This quotation is valid for 15 days from the date of issue.');
    notes.add(
      'Any additional work outside the specified scope will be charged separately.',
    );
    notes.add(
      'Work will commence within 3 days of receiving the advance payment.',
    );

    return notes.join('\n');
  }

  // Format Valid Until Date (15 days from creation)
  String _formatValidUntilDate(DateTime date) {
    try {
      final validUntil = date.add(const Duration(days: 15));
      return '${validUntil.month.toString().padLeft(2, '0')}/${validUntil.day.toString().padLeft(2, '0')}/${validUntil.year}';
    } catch (e) {
      print('Error formatting valid until date: $e');
      return 'N/A';
    }
  }

  // Format Quotation Date
  String _formatQuotationDate(DateTime date) {
    try {
      return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      print('Error formatting date: $e');
      return 'N/A';
    }
  }

  // Save PDF to Temp
  Future<File> savePdfToTemp(pw.Document pdf, String quotationNumber) async {
    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/quotation_$quotationNumber.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

class QuotationPdfPreviewScreen extends StatelessWidget {
  final File file;

  const QuotationPdfPreviewScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quotation Preview',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        actions: [
          TextButton(
            child: Text('Share'),
            onPressed: () async {
              await Printing.sharePdf(
                bytes: await file.readAsBytes(),
                filename: path.basename(file.path),
              );
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(file),
    );
  }
}
