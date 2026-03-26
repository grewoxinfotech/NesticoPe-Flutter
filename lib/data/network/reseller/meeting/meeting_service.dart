import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/reseller/meeting/meeting_model.dart';

class MeetingService {
  MeetingService._();
  static final MeetingService instance = MeetingService._();

  Future<PaginationResponse<MeetingItem>> fetchMeetings({
    required int page,
    required int limit,
    required String resellerId,
  }) async {
    final uri = Uri.parse(ApiConstants.meeting).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
      'resellerId': resellerId,
    });

    final res = await http.get(uri, headers: await ApiConstants.getHeaders());
    if (res.statusCode != 200) {
      throw Exception('Failed to load meetings: ${res.statusCode}');
    }
    final body = json.decode(res.body) as Map<String, dynamic>;
    return PaginationResponse.fromJson(body, (m) => MeetingItem.fromJson(m));
  }

  Future<Map<String, dynamic>> createMeeting(CreateMeetingPayload payload) async {
    final uri = Uri.parse(ApiConstants.meeting);
    final res = await http.post(
      uri,
      headers: await ApiConstants.getHeaders(),
      body: jsonEncode(payload.toJson()),
    );
    final body = json.decode(res.body);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create meeting: ${body['message'] ?? res.statusCode}');
    }
    return body as Map<String, dynamic>;
  }
}
