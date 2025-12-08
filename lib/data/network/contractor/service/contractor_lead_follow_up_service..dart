import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' ;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../model/contractor_lead_model/contractor_lead_followup_model.dart';
import '../model/contractot_service_model/contractor_inquiry_model.dart';

class ContractorLeadFollowUpService{
  ContractorLeadFollowUpService._();
  static ContractorLeadFollowUpService contractorInquiryService=ContractorLeadFollowUpService._();
  final _baseUrl = ApiConstants.contractorLeadFollowUp;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorLeadFollowUpItem>> fetchContractorLeadFollowUp({
    int page = 1,
    Map<String, String>? filters,
    required String id

  }) async {
    log("USer $id");
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
        'related_id':id,
        'section':'lead'

      };

      final uri = Uri.parse("$_baseUrl").replace(queryParameters: queryParams);

      log("Contractor Lead Follow Up Url $uri");
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Lead Follow Up data: $data");

        return PaginationResponse<ContractorLeadFollowUpItem>.fromJson(
          data,
              (json) => ContractorLeadFollowUpItem.fromJson(json),
        );
      } else {
        print("Failed to load Lead Follow Up: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Lead Follow Up");
      }
    } catch (e) {
      print("Exception in Lead Follow Up: $e");
      rethrow;
    }
  }

  // Future<bool> updateStatusOfInquiry(String id,String status)
  // async {
  //   try{
  //     final response=await http.put(Uri.parse('$_baseUrl/$id'),headers:await headers(),body: jsonEncode({'status':status}));
  //
  //     if(response.statusCode==200)
  //     {
  //       final data =jsonDecode(response.body);
  //       print("Contractor Inquiry Status Change : $data");
  //       return data['success'];
  //     }
  //     else{
  //       print("Failed to Change Status: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //       throw Exception("Failed to Change Status");
  //     }
  //   }
  //   catch(e)
  //   {
  //     print("Exception in Status: $e");
  //     return false;
  //   }
  // }
  //
  //
  // Future<bool> deleteInquiry(String id)
  // async {
  //   try{
  //     final response=await http.delete(Uri.parse('$_baseUrl/$id'),headers:await headers(),);
  //
  //     if(response.statusCode==200)
  //     {
  //       final data =jsonDecode(response.body);
  //       print("Contractor Inquiry Deleted : $data");
  //       return data['success'];
  //     }
  //     else{
  //       print("Failed to Delete Inquiry: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //       throw Exception("Failed to Delete Inquiry");
  //     }
  //   }
  //   catch(e)
  //   {
  //     print("Exception in Delete Inquiry: $e");
  //     return false;
  //   }
  // }
  //
  // Future<bool> convertInquiryIntoLead(Map<String,dynamic> lead)
  // async {
  //   try{
  //     final response=await http.post(Uri.parse(ApiConstants.leads),headers:await headers(),body: jsonEncode(lead));
  //     if(response.statusCode==200|| response.statusCode==201)
  //     {
  //       final data =jsonDecode(response.body);
  //       print("Contractor Inquiry Convert Into Lead : $data");
  //       return data['success'];
  //     }
  //     else{
  //       print("Failed to convert Into Lead: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //       throw Exception("Failed to Convert into lead");
  //     }
  //
  //   }catch(e){
  //     print("Exception Convert Into Lead $e");
  //     return false;
  //   }
  // }
}