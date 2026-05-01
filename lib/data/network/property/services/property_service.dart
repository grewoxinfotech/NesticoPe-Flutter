import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../modules/add_property/model/photo_model.dart';
import '../../../../utils/logger/app_logger.dart';
import '../../reseller/reseller_dashboard/model/reseller_dashboard_model.dart';
import '../models/top_property_model.dart';

class PropertyService {
  final String baseUrl = ApiConstants.property;
  final String topPropertyUrl = ApiConstants.topProperties;
  final String recommendedPropertyUrl = ApiConstants.recommmendedPorperties;

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<Items>> fetchProperties({
    int page = 1,
    Map<String, String>? filters,
    int? limit,
    List<String>? fields,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (fields != null) ...{'fields': fields.join(',')},
        if (limit != null) ...{'limit': limit.toString()},
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      print("Reseller uri Property Approved : $uri");
      final response = await http.get(uri, headers: await headers());

      var logger = Logger();

      // logger.d("📦 Response Body → ${response.body}");

      print("New ly add proeprtyu response: ${response.body}");
      // logger.d("New ly add proeprtyu response: response.body");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AppLogger.structured("PROPERTY DATA XJFNSDFSDJ ", data);

        return PaginationResponse<Items>.fromJson(
          
          data,
          (json) => Items.fromJson(json),
        );
      } else {
        print("Failed to load properties: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("Exception in fetchProperties: $e");
      rethrow; // Let controller handle error
    }
  }

  Future<PaginationResponse<Items>> fetchTopProperties({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      // Remove keys that should not be sent to top properties API
      final sanitized = <String, String>{};
      if (filters != null) {
        sanitized.addAll(filters);
        sanitized.remove('approval_status');
        sanitized.remove('isVerified');
      }
      final queryParameters = {
        'page': page.toString(),
        'limit':"5",
        if (sanitized.isNotEmpty) ...sanitized,
      };

      final uri = Uri.parse(topPropertyUrl).replace(queryParameters: queryParameters);
      print("top property uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<Items>.fromJson(
          data,
          (json) => Items.fromJson(json),
        );
      } else {
        print("Failed to load properties: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("Exception in fetchProperties: $e");
      rethrow; // Let controller handle error
    }
  }

  /// Get single property by ID
  Future<Items?> getPropertyById(String id) async {
    try {
      print("baseUrl : $baseUrl/$id");
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return Items.fromJson(jsonData['data']);
      }
    } catch (e) {
      print("Get property by ID exception: $e");
    }
    return null;
  }

  /// Create new property
  Future<bool> createProperty(
    Map<String, dynamic> property,
    List<io.File>? images,
    List<io.File>? videos,
    List<io.File>? documents,
  ) async {
    try {
      final url = Uri.parse(baseUrl);
      print("url: $url");
      debugPrint("Property JSON: ${jsonEncode(property)}");

      var request = http.MultipartRequest("POST", url);

      // Add headers
      request.headers.addAll(await headers());

      property.forEach((key, value) {
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(
            value,
          ); // nested objects/lists as JSON string
        } else {
          request.fields[key] = value.toString();
        }
      });

      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'property_images',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      // ==== Attach Project Videos ====
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'property_videos',
              video.path,
              contentType: MediaType('video', 'mp4'),
            ),
          );
        }
      }

      if (documents != null) {
        for (var document in documents) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'property_documents',
              document.path,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      AppLogger.structured("Create property response: ", response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Create Property Successful",
          contentType: ContentType.success,
        );
      } else {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message:
              data['message'] ?? "Failed to create property. Please try again.",
          contentType: ContentType.failure,
        );
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Create property exception: $e");
      return false;
    }
  }

  /// Update property
  //   Future<bool> updateProperty(
  //     String id,
  //     Map<String, dynamic> property,
  //     List<io.File>? images,
  //     List<io.File>? videos,
  //     List<io.File>? documents,
  //   ) async {
  //     try {
  //       final url = Uri.parse('$baseUrl/$id');
  //       print("url: $url");
  //       debugPrint("Property JSON: ${jsonEncode(property['financial_info'])}");

  //       AppLogger.structured("Property JSON Update property : ", jsonEncode(property['propertyMedia']));
  //       debugPrint("Property Images: ${images?.map((e) => e.path).toList()}");

  //       debugPrint("Property Videos: ${videos?.map((e) => e.path).toList()}");
  //       debugPrint("Property Documents: ${documents?.map((e) => e.path).toList()}");

  //       var request = http.MultipartRequest("PUT", url);

  //       // Add headers
  //       request.headers.addAll(await headers());

  //       property.forEach((key, value) {

  //         if (value is Map || value is List) {

  //           log("Property JSON Update property hjbdjfjds: $key $value");

  //           request.fields[key] = jsonEncode(
  //             value,
  //           ); // nested objects/lists as JSON string
  //         } else {
  //            log("Property JSON Update property hjbdjsssfjds: $key $value");
  //           request.fields[key] = value.toString();
  //         }
  //       });
  //  List<String> retainImageUrls = [];
  //       // ==== Attach Images ====
  //       if (images != null && images.isNotEmpty) {
  //         for (var image in images) {
  //           if (isNetworkFile(image.path)) {
  //             print("Skipping network image: ${image.path}");
  //             retainImageUrls.add(image.path);
  //             continue; // Skip upload
  //           }
  //           log("Property JSON Update property Image section : ${image.path}");

  //           request.files.add(
  //             await http.MultipartFile.fromPath(
  //               'property_images',
  //               image.path,
  //               contentType: MediaType('image', 'jpeg'),
  //             ),
  //           );
  //         }
  //       }
  //       log("Property JSON Update property Image sectionfdsvd : $retainImageUrls");

  //       // ==== Attach Videos ====
  //       if (videos != null && videos.isNotEmpty) {
  //         for (var video in videos) {
  //           if (isNetworkFile(video.path)) {
  //             print("Skipping network video: ${video.path}");
  //             continue; // Skip upload
  //           }

  //           request.files.add(
  //             await http.MultipartFile.fromPath(
  //               'property_videos',
  //               video.path,
  //               contentType: MediaType('video', 'mp4'),
  //             ),
  //           );
  //         }
  //       }

  //       // ==== Attach Documents ====
  //       if (documents != null && documents.isNotEmpty) {
  //         for (var document in documents) {
  //           if (isNetworkFile(document.path)) {
  //             print("Skipping network document: ${document.path}");
  //             continue; // Skip upload
  //           }

  //           request.files.add(
  //             await http.MultipartFile.fromPath(
  //               'property_documents',
  //               document.path,
  //               contentType: MediaType('application', 'pdf'),
  //             ),
  //           );
  //         }
  //       }

  //       // Send request
  //       final streamedResponse = await request.send();
  //       final response = await http.Response.fromStream(streamedResponse);

  //       debugPrint("Update property response: ${response.body}");
  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         NesticoPeSnackBar.showAwesomeSnackbar(
  //           title: "Success",
  //           message: "Update Property Successful",
  //           contentType: ContentType.success,
  //         );
  //       } else {
  //         NesticoPeSnackBar.showAwesomeSnackbar(
  //           title: "Error",
  //           message: "Failed to Update property. Please try again.",
  //           contentType: ContentType.failure,
  //         );
  //       }

  //       return response.statusCode == 200 || response.statusCode == 201;
  //     } catch (e) {
  //       print("Update property exception: $e");
  //       return false;
  //     }
  //   }

  Future<bool> updateProperty(
    String id,
    Map<String, dynamic> property,
    List<io.File>? images,
    List<io.File>? videos,
    List<io.File>? documents,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/$id');

      final hasLocalImage = (images ?? []).any((f) => !isNetworkFile(f.path));
      final hasLocalVideo = (videos ?? []).any((f) => !isNetworkFile(f.path));
      final hasLocalDocument =
          (documents ?? []).any((f) => !isNetworkFile(f.path));
      final hasLocalMediaUpload =
          hasLocalImage || hasLocalVideo || hasLocalDocument;

      final retainImageUrls =
          (images ?? [])
              .where((f) => isNetworkFile(f.path))
              .map((f) => f.path)
              .toList();
      final retainVideoUrls =
          (videos ?? [])
              .where((f) => isNetworkFile(f.path))
              .map((f) => f.path)
              .toList();
      final retainDocumentUrls =
          (documents ?? [])
              .where((f) => isNetworkFile(f.path))
              .map((f) => f.path)
              .toList();

      // If there are no local files to upload, send plain JSON.
      // This preserves `propertyMedia` as a real object with array values.
      if (!hasLocalMediaUpload) {
        final payload = Map<String, dynamic>.from(property);
        payload['propertyMedia'] = {
          'images': retainImageUrls,
          'videos': retainVideoUrls,
          'documents': retainDocumentUrls,
        };

        final response = await http.put(
          url,
          headers: await headers(),
          body: jsonEncode(payload),
        );

        AppLogger.structured("Update property response: ", response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Success",
            message: "Update Property Successful",
            contentType: ContentType.success,
          );
        } else {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: "Error",
            message: "Failed to Update property. Please try again.",
            contentType: ContentType.failure,
          );
        }

        return response.statusCode == 200 || response.statusCode == 201;
      }

      var request = http.MultipartRequest("PUT", url);
      request.headers.addAll(await headers());

      property.forEach((key, value) {
        if (key == 'propertyMedia') return;
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // ─── IMAGES ───────────────────────────────────────────────

      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          if (isNetworkFile(image.path)) {
            // old URL already collected in retainImageUrls
          } else {
            request.files.add(
              // new local file → upload
              await http.MultipartFile.fromPath(
                'property_images',
                image.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            );
          }
        }
      }

      // ─── VIDEOS ───────────────────────────────────────────────
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          if (isNetworkFile(video.path)) {
            // old URL already collected in retainVideoUrls
          } else {
            request.files.add(
              await http.MultipartFile.fromPath(
                'property_videos',
                video.path,
                contentType: MediaType('video', 'mp4'),
              ),
            );
          }
        }
      }

      // ─── DOCUMENTS ────────────────────────────────────────────
      if (documents != null && documents.isNotEmpty) {
        for (var document in documents) {
          if (isNetworkFile(document.path)) {
            // old URL already collected in retainDocumentUrls
          } else {
            request.files.add(
              await http.MultipartFile.fromPath(
                'property_documents',
                document.path,
                contentType: MediaType('application', 'pdf'),
              ),
            );
          }
        }
      }

      // ─── Send retained URLs to backend as propertyMedia ───────
      //
      // Case 1: user removed ALL old images → retainImageUrls is []
      //         → propertyMedia.images = [] on backend
      //
      // Case 2: user kept some/all old images → retainImageUrls has URLs
      //         → backend merges them with newly uploaded property_images
      //
      for (int i = 0; i < retainImageUrls.length; i++) {
        request.fields['propertyMedia[images][$i]'] = retainImageUrls[i];
      }
      for (int i = 0; i < retainVideoUrls.length; i++) {
        request.fields['propertyMedia[videos][$i]'] = retainVideoUrls[i];
      }
      for (int i = 0; i < retainDocumentUrls.length; i++) {
        request.fields['propertyMedia[documents][$i]'] = retainDocumentUrls[i];
      }

      log("retainImageUrls: $retainImageUrls");
      log("retainVideoUrls: $retainVideoUrls");
      log("retainDocumentUrls: $retainDocumentUrls");
      log(
        "propertyMedia fields sent: "
        "images=${retainImageUrls.length}, "
        "videos=${retainVideoUrls.length}, "
        "documents=${retainDocumentUrls.length}",
      );

      // ─── Send ─────────────────────────────────────────────────
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      AppLogger.structured("Update property response: ", response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Update Property Successful",
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "Failed to Update property. Please try again.",
          contentType: ContentType.failure,
        );
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Update property exception: $e");
      return false;
    }
  }

  /// Delete property
  Future<bool> deleteProperty(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );
      print("Delete property response: ${response.body}");
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    try {
      print("data : ${data}");
      print("baseUrl : $baseUrl/$id/inquiry");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/inquiry"),
        headers:
            UserHelper.isGuest
                ? await ApiConstants.getHeadersWithoutToken()
                : await ApiConstants.getHeaders(),
        body: jsonEncode(data),
      );
      print("response : ${response.body}");
      print("Status code : ${response.statusCode}");
      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<bool> addInquiryForNesticoPeService(Map<String, dynamic> data) async {
    try {
      print("data : ${data}");
      print("baseUrl : $baseUrl/general-inquiry");
      final response = await http.post(
        Uri.parse("$baseUrl/general-inquiry"),
        headers:
            UserHelper.isGuest
                ? await ApiConstants.getHeadersWithoutToken()
                : await ApiConstants.getHeaders(),
        body: jsonEncode(data),
      );
      print("response : ${response.body}");
      print("Status code : ${response.statusCode}");
      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<bool> addView(String id) async {
    try {
      print("baseUrl : ${baseUrl}/${id}");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/view"),
        headers: await headers(),
      );
      print("response : ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  // Future<List<Map<String, dynamic>>> getRecommendedPropertyByUserId(
  //   String userId,
  // ) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$recommendedPropertyUrl/$userId"),
  //       headers: await headers(),
  //     );
  //
  //     print("Response of Recommended properties: ${response.body}");
  //     print("Response of Recommended properties: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       if (jsonData['data'] != null &&
  //           jsonData['data']['properties'] != null) {
  //         return List<Map<String, dynamic>>.from(
  //           jsonData['data']['properties'],
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print("Get property by ID exception: $e");
  //   }
  //   return [];
  // }

  Future<List<Items>> getRecommendedPropertyByUserId(String userId) async {
    try {
      final uri = Uri.parse("$recommendedPropertyUrl/$userId");
      print("ReCommanded Property baseUrl : $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Recommended properties response: ${response.body}");

      if (response.statusCode != 200) {
        debugPrint(
          "Failed to fetch recommended properties. Status: ${response.statusCode}",
        );
        return [];
      }

      final Map<String, dynamic> jsonData = json.decode(response.body);
      AppLogger.structured("Recommended properties data: ", jsonData);

      final properties = jsonData['data']?['properties'] as List<dynamic>?;

      if (properties == null || properties.isEmpty) {
        return [];
      }

      final data =
          properties
              .map((e) => Items.fromJson(e as Map<String, dynamic>))
              .toList();
      print(
        "Recommended properties data count: ${data.map((e) => e.id).toList()}",
      );
      return data;
    } catch (e, stackTrace) {
      debugPrint(
        "getRecommendedPropertyByUserId service error: $e\n$stackTrace",
      );
      return [];
    }
  }

  //
  // Future<Map<String,dynamic>> getRecommendedPropertyById(String id) async {
  //   try {
  //     print("baseUrl : $baseUrl/$id");
  //     final response = await http.get(
  //       Uri.parse("$recommendedPropertyUrl/$id"),
  //       headers: await headers(),
  //     );
  //
  //     print("Response of Recommended properties: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       print("hubdshbds Response of Recommended properties ${jsonData['data']}");
  //       return jsonData['data'];
  //     }
  //   } catch (e) {
  //     print("Get property by ID exception: $e");
  //   }
  //   return {};
  // }
  bool isNetworkFile(String path) {
    return path.startsWith("http://") || path.startsWith("https://");
  }
}
