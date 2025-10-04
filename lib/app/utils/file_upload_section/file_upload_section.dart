import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/file_upload_section/pdf_screen.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:open_filex/open_filex.dart';

class FileUploadSection extends StatelessWidget {
   FileUploadSection({super.key});

   final CreatePropertyController controller=Get.put(CreatePropertyController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Upload Section')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.pickFiles,
              child: const Text('Upload File'),
            ),
            const SizedBox(height: 20),
            Expanded( // give the list proper height
              child: Obx(() {
                if (controller.files?.isNotEmpty??false) {
                  return ListView.builder(
                    itemCount: controller.files?.length,
                    itemBuilder: (context, index) {
                      final file = controller.files?[index];
                      return ListTile(
                        onTap: ()  {
                          // this will open PDF/image/word with whatever viewer is installed
                          if (file != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PdfViewPage(path: file.path
                                .toString()),
                              ),
                            );
                          }

                        },
                        title: Text(file?.path.toString()??''),


                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No file uploaded yet.'));
                }
              }),
            ),
          ],
        ),
      ),

    );
  }
}


