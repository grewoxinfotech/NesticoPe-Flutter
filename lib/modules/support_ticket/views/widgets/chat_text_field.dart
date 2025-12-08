//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import '../../../../app/constants/color_res.dart';
//
// class ChatMessageInputField extends StatelessWidget {
//   final TextEditingController messageController;
//   final VoidCallback onSendTap;
//   final Function(PlatformFile file)? onDocumentPicked;
//
//   const ChatMessageInputField({
//     super.key,
//     required this.messageController,
//     required this.onSendTap,
//     this.onDocumentPicked,
//   });
//
//   Future<void> pickDocument() async {
//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       type: FileType.any,
//       withData: true, // IMPORTANT → get bytes
//     );
//
//     if (result != null && onDocumentPicked != null) {
//       onDocumentPicked!(result.files.first);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               // Attachment Button
//               IconButton(
//                 icon: const Icon(Icons.attach_file),
//                 color: Colors.grey,
//                 onPressed: pickDocument,
//               ),
//
//               // Input Field
//               Expanded(
//                 child: TextField(
//                   controller: messageController,
//                   decoration: InputDecoration(
//                     hintText: 'Type your message...',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(24),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 10,
//                     ),
//                   ),
//                   maxLines: null,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               // Send Button
//               CircleAvatar(
//                 backgroundColor: ColorRes.primary,
//                 child: IconButton(
//                   icon: const Icon(Icons.send, color: ColorRes.white),
//                   onPressed: onSendTap,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/constants/color_res.dart';

class ChatMessageInputField extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSendTap;
  final Rxn<PlatformFile> pendingFile;

  // final Function(PlatformFile file)? onDocumentPicked;

  const ChatMessageInputField({
    super.key,
    required this.messageController,
    required this.onSendTap,
    // this.onDocumentPicked,
    required this.pendingFile,
  });

  @override
  State<ChatMessageInputField> createState() => _ChatMessageInputFieldState();
}

class _ChatMessageInputFieldState extends State<ChatMessageInputField> {
  // PlatformFile? _pickedFile;

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      widget.pendingFile.value = result.files.first;
    }
  }

  void removeFile() {
    widget.pendingFile.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show picked file name if exists
          if (widget.pendingFile.value != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.pendingFile.value!.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: removeFile,
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),

          // Input + buttons
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Attachment Button
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      color: Colors.grey,
                      onPressed: pickDocument,
                    ),

                    // Input Field
                    Expanded(
                      child: TextField(
                        controller: widget.messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Send Button
                    CircleAvatar(
                      backgroundColor: ColorRes.primary,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: ColorRes.white),
                        onPressed: widget.onSendTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
