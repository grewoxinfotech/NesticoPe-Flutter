import 'dart:convert';
import 'dart:developer';

import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/confige/helper/api_helper.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../model/contractor_lead_model/contractor_lead_model.dart';

class ContractorLeadService{
  ContractorLeadService._();
final _basurl=ApiConstants.leads;
  static ContractorLeadService contractorLeadService=ContractorLeadService._();

 static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorLeadItem>> fetchContractorLead({int page = 1,Map<String ,String>? filter,required String id})
  async {
   try{
     final query={
       'page':page.toString(),
       if(filter!=null)...filter,
       'reseller_id':id
     };
     final uri=Uri.parse(_basurl).replace(queryParameters: query);

     log("Contractor Lead Url $uri");

     final response=await http.get(uri,headers:await  header());
     if(response.statusCode==200 || response.statusCode==201)
       {
         log("Contractor lead Response");
         final data =jsonDecode(response.body);
         return PaginationResponse<ContractorLeadItem>.fromJson(data, (json) =>ContractorLeadItem.fromMap(json) ,);
       }
     else{
       print("Failed to load Contractor lead Response: ${response.statusCode}");
       print("Response body: ${response.body}");
       throw Exception("Failed to load Contractor lead Response");
     }


  } catch (e){
     print("Exception in Contractor lead Response: $e");
     rethrow;
   }
  }


  Future<bool> deleteContractorLead(String id) async {
    try {
      final uri = Uri.parse('$_basurl/$id');
      final headers = await header();

      final response = await http.delete(uri, headers: headers);

      log("Delete Contractor Lead URL: $uri");
      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
       final data=jsonDecode(response.body);
       return data['success'];
      } else {

        log("Failed to delete contractor lead. Status: ${response.statusCode}");
        return false;
      }
    } catch (e, stack) {
      log("Exception while deleting contractor lead: $e");
      log("StackTrace: $stack");
      return false;
    }




  }

  Future<bool> convertIntoProject(Map<String,dynamic> project) async {

   try{
     final uri = Uri.parse('${ApiConstants.contractorProject}');
     final headers = await header();

     final response = await http.post(uri, headers: headers,body: jsonEncode(project));

     log("Convert Into Project URL: $uri");
     log("Response Status: ${response.statusCode}");
     log("Response Body: ${response.body}");

     if (response.statusCode == 200 || response.statusCode == 201) {
       final data=jsonDecode(response.body);
       AppLogger.structured("Convert Into Project Response", data);
       return data['success'];
     } else {

       log("Failed to Convert Into Project. Status: ${response.statusCode}");
       return false;
     }
   }catch(e){
     log("Failed to Convert Into Project. Status: ${e}");
     return false;
   }
  }

  Future<bool> updateTheLeadStatusAndStage(
      Map<String, dynamic> stage, String id) async {
    try {
      final uri = Uri.parse('${ApiConstants.leads}/$id');
      final headers = await header();

      // 🟦 Log the request details
      log("🔹 [UPDATE LEAD STATUS & STAGE]");
      log("➡️  URL: $uri");
      log("📦  Request Body: ${jsonEncode(stage)}");
      log("🧾  Headers: $headers");

      final response =
      await http.put(uri, headers: headers, body: jsonEncode(stage));

      // 🟩 Log response details
      log("✅ [RESPONSE RECEIVED]");
      log("📊 Status Code: ${response.statusCode}");
      log("📄 Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final success = data['success'] ?? false;

        log("🟢 Lead Updated Successfully → success: $success");
        return success;
      } else {
        log("🔴 Failed to update lead. Status Code: ${response.statusCode}");
        log("❌ Response: ${response.body}");
        return false;
      }
    } catch (e, stack) {
      log("🚨 Exception while updating lead: $e");
      log("🧠 Stack Trace: $stack");
      return false;
    }
  }

  /// 🔹 Update Full Lead Details (PUT /leads/:id)
  Future<bool> updateContractorLead(String id, Map<String, dynamic> payload) async {
    try {
      final uri = Uri.parse('${ApiConstants.leads}/$id');
      final headers = await header();

      log("🔹 [UPDATE CONTRACTOR LEAD]");
      log("➡️  URL: $uri");
      log("📦  Request Body: ${jsonEncode(payload)}");
      log("🧾  Headers: $headers");

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );

      log("✅ [UPDATE RESPONSE RECEIVED]");
      log("📊 Status Code: ${response.statusCode}");
      log("📄 Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final success = data['success'] == true;
        if (success) {
          log("🟢 Lead updated successfully for ID: $id");
        } else {
          log("🔴 Lead update response returned success = false");
        }

        return success;
      } else {
        log("🔴 Failed to update lead. Status Code: ${response.statusCode}");
        log("❌ Response: ${response.body}");
        return false;
      }
    } catch (e, stack) {
      log("🚨 Exception while updating contractor lead: $e");
      log("🧠 Stack Trace: $stack");
      return false;
    }
  }




}