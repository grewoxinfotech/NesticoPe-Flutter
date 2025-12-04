import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:housing_flutter_app/app/constants/api_constants.dart';

import '../../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../../app/widgets/snackbar/snackbar.dart';
import '../../models/ticket_model/support_ticket_model.dart';

class TicketService {
  final String baseUrl = ApiConstants.ticket; // ← SET CORRECT API ENDPOINT

  /// Headers with token
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// 📌 GET – Fetch tickets with pagination
  Future<PaginationResponse<TicketItem>> fetchTickets({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
        if (userId != null) 'created_by': userId.toString(),
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      print("🔹 Ticket URI: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("📥 Ticket data: $json");

        return PaginationResponse<TicketItem>.fromJson(
          json,
          (json) => TicketItem.fromJson(json),
        );
      } else {
        print("❌ Failed to load tickets: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception("Failed to load tickets");
      }
    } catch (e) {
      print("❌ Exception in fetchTickets: $e");
      rethrow;
    }
  }

  /// 🆕 POST – Create Ticket
  Future<bool> createTicket(TicketCreateRequest ticket, File image) async {
    try {
      print("📤 Create Ticket payload: ${ticket.toJson()}");

      final uri = Uri.parse(baseUrl);

      http.MultipartRequest request = http.MultipartRequest('POST', uri);

      request.headers.addAll(await headers());

      ticket.toJson().forEach((key, value) {
        request.fields[key] = value;
      });

      if (image.path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('files', image.path),
        );
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Ticket response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Ticket created successfully");
        return true;
      } else {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: data['message'],
          contentType: ContentType.failure,
        );
        print("❌ Ticket creation failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error creating ticket: $e");
      return false;
    }
  }
}
