import 'package:get/get.dart';
import 'package:tradexpro_flutter/helper/app_helper.dart';
import 'package:tradexpro_flutter/utils/common_utils.dart';
import 'package:tradexpro_flutter/data/local/api_constants.dart';
import 'package:tradexpro_flutter/data/models/response.dart';

class APIProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = APIURLConstants.baseUrl;
    httpClient.maxAuthRetries = 3;
    httpClient.timeout = const Duration(seconds: 60);
    super.onInit();
  }

  /// *** Common Server Request *** ///
  Future<ServerResponse> postRequest(String url, Map body, Map<String, String> headers, {bool? isDynamic}) async {
    printFunction("postRequest body", body);
    printFunction("postRequest headers", headers);
    final response = await post(url, body, headers: headers);
    GetUtils.printFunction("postRequest url", response.request?.url, "");
    return handleResponse(response, isDynamic: isDynamic);
  }

  Future<ServerResponse> getRequest(String url, Map<String, String> headers, {Map<String, dynamic>? query, bool? isDynamic}) async {
    printFunction("getRequest query", query);
    printFunction("getRequest headers", headers);
    final response = await get(url, headers: headers, query: query);
    printFunction("getRequest url ", response.request?.url);
    return handleResponse(response, isDynamic: isDynamic);
  }

  Future<ServerResponse> postRequestFormData(String url, Map<String, dynamic> body, Map<String, String> headers, {bool? isDynamic}) async {
    printFunction("postRequestFormData body", body);
    printFunction("postRequestFormData headers", headers);
    final response = await post(url, FormData(body), headers: headers);
    printFunction("postRequestFormData url", response.request?.url);
    return handleResponse(response, isDynamic: isDynamic);
  }

  Future<ServerResponse> uploadFile(String url, List<int> img, String filename, Map<String, String> headers) async {
    printFunction("uploadFile headers", headers);
    final avatar = MultipartFile(img, filename: filename);
    final response = await post(url, FormData({APIKeyConstants.vProfilePhotoPath: avatar}), headers: headers);
    printFunction("uploadFile url", response.request?.url);
    return handleResponse(response);
  }

  Future<ServerResponse> handleResponse(Response response, {bool? isDynamic}) async {
    printFunction("handleResponse statusText", response.statusText);
    printFunction("handleResponse statusCode", response.statusCode);
    printFunction("handleResponse hasError", response.status.hasError);
    if (response.statusCode == 401) {
      logOutActions();
      return Future.error(response.statusText as String);
    }

    if (response.status.hasError) {
      if (response.status.connectionError) {
        return Future.error("Please verify your internet connection and try again".tr);
      }
      return Future.error(response.statusText as String);
    } else {
      printFunction("handleResponse body", response.body);
      if (isDynamic != null && isDynamic) {
        return ServerResponse(success: true, message: "", data: response.body);
      } else if (ServerResponse.isServerResponse(response.body)) {
        return ServerResponse.fromJson(response.body);
      } else {
        return ServerResponse(success: true, message: "", data: response.body);
      }
    }
  }
}

