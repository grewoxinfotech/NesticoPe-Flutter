import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' ;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../model/contractor_quotation/contractor_quotation.dart';
import '../model/contractot_service_model/contractor_inquiry_model.dart';

class ContractorInquiryService{
  ContractorInquiryService._();
  static ContractorInquiryService contractorInquiryService=ContractorInquiryService._();
  final _baseUrl = ApiConstants.contractorInquiry;
  final _baseUrlQutation = ApiConstants.contractorInquiryQuotation;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorInquiryItem>> fetchContractorInquiry({
    int page = 1,
    Map<String, String>? filters,
    required String id

  }) async {
    log("USer $id");
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,

      };

      final uri = Uri.parse("$_baseUrl").replace(queryParameters: queryParams);

      log("Contractor Inquiry Url $uri");
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Inquiry data: $data");

        return PaginationResponse<ContractorInquiryItem>.fromJson(
          data,
              (json) => ContractorInquiryItem.fromMap(json),
        );
      } else {
        print("Failed to load Review: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Review");
      }
    } catch (e) {
      print("Exception in Review: $e");
      rethrow;
    }
  }
    Future<PaginationResponse<ContractorQuotation>> fetchContractorQuotation({
    int page = 1,
    Map<String, String>? filters,
    required String id

  }) async {
    log("USer $id");
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,

      };

      final uri = Uri.parse("$_baseUrlQutation").replace(queryParameters: queryParams);

      log("Contractor Quotation Url $uri");
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Quotation data: $data");

        return PaginationResponse<ContractorQuotation>.fromJson(
          data,
              (json) => ContractorQuotation.fromMap(json),
        );
      } else {
        print("Failed to load Review: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Review");
      }
    } catch (e) {
      print("Exception in Review: $e");
      rethrow;
    }
  }









  Future<bool> updateStatusOfInquiry(String id,String status)
  async {
    try{
      final response=await http.put(Uri.parse('$_baseUrl/$id'),headers:await headers(),body: jsonEncode({'status':status}));

      if(response.statusCode==200)
        {
          final data =jsonDecode(response.body);
          print("Contractor Inquiry Status Change : $data");
          final jsonData = json.decode(response.body);
          // final jsonData = json.decode(response.body);
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: jsonData['message'],
            contentType: ContentType.success,
          );
          return data['success'];
        }
      else{
        print("Failed to Change Status: ${response.statusCode}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Response body: ${response.body}");
        throw Exception("Failed to Change Status");
      }
    }
    catch(e)
    {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Status: $e");
      return false;
    }
  }


  Future<bool> updateStatusOfQuotation(String id,String status)
  async {
    try{
      final response=await http.put(Uri.parse('$_baseUrlQutation/$id'),headers:await headers(),body: jsonEncode({'status':status}));

      if(response.statusCode==200)
        {
          final data =jsonDecode(response.body);
          print("Contractor Quotation Status Change : $data");
          final jsonData = json.decode(response.body);
          // final jsonData = json.decode(response.body);
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Success',
            message: jsonData['message'],
            contentType: ContentType.success,
          );
          return data['success'];
        }
      else{
        print("Failed to Change Status: ${response.statusCode}");
        print("Response body: ${response.body}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        throw Exception("Failed to Change Status");
      }
    }
    catch(e)
    {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Status: $e");
      return false;
    }
  }


  Future<bool> deleteInquiry(String id)
  async {
    try{
      final response=await http.delete(Uri.parse('$_baseUrl/$id'),headers:await headers(),);

      if(response.statusCode==200)
      {
        final data =jsonDecode(response.body);
        print("Contractor Inquiry Deleted : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );

        return data['success'];
      }
      else{
        print("Failed to Delete Inquiry: ${response.statusCode}");
        print("Response body: ${response.body}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        throw Exception("Failed to Delete Inquiry");
      }
    }
    catch(e)
    {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Delete Inquiry: $e");
      return false;
    }
  }
  Future<bool> deleteQuotation(String id)
  async {
    try{
      final response=await http.delete(Uri.parse('$_baseUrlQutation/$id'),headers:await headers(),);

      if(response.statusCode==200)
      {
        final data =jsonDecode(response.body);
        print("Contractor Quotation Deleted : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      }
      else{
        print("Failed to Delete Quotation: ${response.statusCode}");
        print("Response body: ${response.body}");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        throw Exception("Failed to Delete Quotation");
      }
    }
    catch(e)
    {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception in Delete Quotation: $e");
      return false;
    }
  }

  Future<bool> convertInquiryIntoLead(Map<String,dynamic> lead)
  async {
    try{
      final response=await http.post(Uri.parse(ApiConstants.leads),headers:await headers(),body: jsonEncode(lead));
      if(response.statusCode==200|| response.statusCode==201)
      {
        final data =jsonDecode(response.body);
        print("Contractor Inquiry Convert Into Lead : $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      }
      else{
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to convert Into Lead: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to Convert into lead");
      }

    }catch(e){
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception Convert Into Lead $e");
      return false;
    }
  }

  Future<bool> convertInquiryQuotation(Map<String,dynamic> quotation)
  async {
    try{
      final response=await http.post(Uri.parse(_baseUrlQutation),headers:await headers(),body: jsonEncode(quotation));
      if(response.statusCode==200|| response.statusCode==201)
      {
        final data =jsonDecode(response.body);
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        print("Contractor Inquiry Send Quotation : $data");
        return data['success'];
      }
      else{
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to Send Quotation: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to Send Quotation");
      }

    }catch(e){
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception Convert Into Lead $e");
      return false;
    }
  }
  Future<bool> updateQuotation(Map<String,dynamic> quotation)
  async {
    try{
      final response=await http.put(Uri.parse('$_baseUrlQutation/${quotation['id']}'),headers:await headers(),body: jsonEncode(quotation));
      if(response.statusCode==200|| response.statusCode==201)
      {
        final data =jsonDecode(response.body);
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        print("Contractor Inquiry Send Quotation : $data");
        return data['success'];
      }
      else{
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to Send Quotation: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to Send Quotation");
      }

    }catch(e){
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Exception Convert Into Lead $e");
      return false;
    }
  }
}