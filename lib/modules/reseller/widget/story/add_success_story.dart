import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:intl/intl.dart';

import '../../controller/dashborad_controller/dashboard_controller.dart';

class AddSuccessStoryScreen extends StatelessWidget {
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 8),
            Text('Add Success Story'),
          ],
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Title'),
              TextFormField(
                controller: controller.titleController,
                decoration: _inputDecoration('e.g., 3 BHK Luxury Apartment Deal Closed'),
                validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
              ),
              buildTextField('Enter the title', Icons.drive_file_rename_outline, controller.titleController),
              SizedBox(height: 20),

              _buildLabel('Description'),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: _inputDecoration('Describe your success story in detail...'),
                validator: (v) => v!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),

              _buildLabel('Achievement'),
              TextFormField(
                controller: controller.achievementController,
                maxLines: 3,
                decoration: _inputDecoration('e.g., Highest sale in Q3, Record breaking...'),
                validator: (v) => v!.isEmpty ? 'Please enter achievement details' : null,
              ),
              SizedBox(height: 20),

              // Month / Year Picker
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Month/Year'),
                        Obx(() {
                          final selected = controller.selectedMonth.value;
                          return InkWell(
                            onTap: () async {
                              final now = DateTime.now();
                              final date = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (date != null) controller.selectedMonth.value = date;
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selected == null
                                        ? 'Select month and year'
                                        : DateFormat('MMMM yyyy').format(selected),
                                    style: TextStyle(
                                      color: selected == null ? Colors.grey[600] : Colors.black,
                                    ),
                                  ),
                                  Icon(Icons.calendar_today, size: 20),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status'),
                        SizedBox(height: 8),
                        Obx(() => DropdownButtonFormField<String>(
                          value: controller.selectedStatus.value,
                          decoration: _inputDecoration(''),
                          items: controller.statusOptions
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (val) => controller.selectedStatus.value = val!,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Total Deals & Value
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.totalDealsController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('0').copyWith(labelText: 'Total Deals'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: controller.totalValueController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('₹ 4,000').copyWith(labelText: 'Total Value (₹)'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Rating
              Text('Rating'),
              Obx(() => Row(
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < controller.rating.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => controller.rating.value = (i + 1).toDouble(),
                  );
                }),
              )),
              SizedBox(height: 20),

              // Image Picker
              Text('Image'),
              SizedBox(height: 8),
              Obx(() => GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                    image: controller.imageFile.value != null
                        ? DecorationImage(
                      image: FileImage(controller.imageFile.value!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.imageFile.value == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Upload Image', style: TextStyle(color: Colors.grey[600])),
                    ],
                  )
                      : null,
                ),
              )),
              SizedBox(height: 30),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Submit Story'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '* ', style: TextStyle(color: Colors.red)),
          TextSpan(text: text, style: TextStyle(color: Colors.black)),
        ],
      ),
    ),
  );
}
