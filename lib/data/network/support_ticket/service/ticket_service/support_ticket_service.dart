import 'dart:convert';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';

import '../../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../../app/widgets/snackbar/snackbar.dart';
import '../../../../../widgets/messages/snack_bar.dart';
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

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return PaginationResponse<TicketItem>.fromJson(
          json,
          (json) => TicketItem.fromJson(json),
        );
      } else {
        throw Exception("Failed to load tickets");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 🆕 POST – Create Ticket
  Future<bool> createTicket(TicketCreateRequest ticket, File image) async {
    try {
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: data['message'],
          contentType: ContentType.failure,
        );

        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// 🆕 POST – Create Ticket (JSON only, no file)
  Future<TicketItem?> createTicketSimple(TicketCreateRequest ticket) async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(ticket.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final item = data['data'];
        if (item != null) {
          return TicketItem.fromJson(item);
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// 📌 GET – Fetch a single ticket by ID
  Future<TicketItem?> fetchTicketById(String id) async {
    try {
      final uri = Uri.parse('$baseUrl/$id');
      final res = await http.get(uri, headers: await headers());
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['data'] != null) {
          return TicketItem.fromJson(data['data']);
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
