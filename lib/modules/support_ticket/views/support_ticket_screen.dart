import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/add_support_ticket.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/support_ticket_chat_screen.dart';
import 'package:housing_flutter_app/modules/support_ticket/views/widgets/support_ticket_card.dart';
import 'package:intl/intl.dart';

import '../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import '../controllers/chat_socket_controller.dart';
import '../controllers/support_ticket_controller.dart';

class SupportTicketScreen extends StatelessWidget {
  SupportTicketScreen({super.key});

  final SupportTicketController controller = Get.put(SupportTicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support Tickets'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.resetFormField();
          Get.to(() => const CreateTicketScreen());
        },
        foregroundColor: ColorRes.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Tabs
          // Container(
          //   margin: const EdgeInsets.all(16),
          //   padding: const EdgeInsets.all(4),
          //   decoration: BoxDecoration(
          //     color: Colors.grey[200],
          //     borderRadius: BorderRadius.circular(25),
          //   ),
          //   child: Obx(
          //     () => Row(
          //       children:
          //           ['All', 'High', 'Medium', 'Low', 'Critical'].map((tab) {
          //             bool isSelected = controller.selectedTab.value == tab;
          //             return Expanded(
          //               child: GestureDetector(
          //                 onTap: () => controller.selectedTab.value = tab,
          //                 child: Container(
          //                   padding: const EdgeInsets.symmetric(
          //                     vertical: 10,
          //                     horizontal: 12,
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color:
          //                         isSelected
          //                             ? Colors.white
          //                             : Colors.transparent,
          //                     borderRadius: BorderRadius.circular(22),
          //                     // boxShadow:
          //                     //     isSelected
          //                     //         ? [
          //                     //           BoxShadow(
          //                     //             color: Colors.black.withOpacity(0.1),
          //                     //             blurRadius: 4,
          //                     //             offset: const Offset(0, 2),
          //                     //           ),
          //                     //         ]
          //                     //         : null,
          //                   ),
          //                   child: Text(
          //                     tab,
          //                     textAlign: TextAlign.center,
          //                     style: TextStyle(
          //                       color:
          //                           isSelected
          //                               ? Colors.black
          //                               : Colors.grey[600],
          //                       fontWeight:
          //                           isSelected
          //                               ? FontWeight.w600
          //                               : FontWeight.normal,
          //                       fontSize: 13,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             );
          //           }).toList(),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 8),
          // Ticket list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.items.isEmpty && !controller.isLoading.value) {
                return const Center(child: Text('No tickets found'));
              }

              // if (controller.filteredTickets.isEmpty) {
              //   return const Center(child: Text('No tickets found'));
              // }
              return NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  final matrices = notification.metrics;
                  if (matrices.pixels >= matrices.maxScrollExtent) {
                    controller.loadMore();
                  }
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: controller.refreshList,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final ticket = controller.items[index];
                      // return GestureDetector(
                      //   onTap: () => Get.to(() => SupportTicketChatScreen()),
                      //   child: Container(
                      //     padding: const EdgeInsets.all(20),
                      //     margin: const EdgeInsets.only(bottom: 8),
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.grey),
                      //       borderRadius: BorderRadius.circular(8),
                      //       color: Colors.grey,
                      //     ),
                      //     child: Text(ticket.title.toString()),
                      //   ),
                      // );
                      return GestureDetector(
                        onTap: () {
                          Get.lazyPut(() => SocketController());
                          Get.to(
                            () => SupportTicketChatScreen(
                              ticketId: ticket.id ?? '',
                              ticket: ticket,
                            ),
                          );
                        },
                        child: SupportTicketCard(ticket: ticket),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
