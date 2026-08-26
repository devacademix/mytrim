import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:flutter/foundation.dart';

class ApiService extends GetxService {
  final String appBaseUrl;
  static const String connectionIssue = 'Connection failed!';
  final int timeoutInSeconds = 30;
  ApiService({required this.appBaseUrl});

  Future<Response> getPublic(String uri) async {
    try {
      http.Response response = await http.get(Uri.parse(appBaseUrl + uri)).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getOther(String uri) async {
    try {
      http.Response response = await http.get(Uri.parse(uri)).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getExternal(String uri) async {
    try {
      http.Response response = await http.get(Uri.parse(uri)).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPrivate(String uri, String token) async {
    try {
      http.Response response =
          await http.get(Uri.parse(appBaseUrl + uri), headers: {'Content-Type': 'application/json;', 'Authorization': 'Bearer $token'}).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> uploadFiles(String uri, List<MultipartBody> multipartBody) async {
    try {
      http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      for (MultipartBody multipart in multipartBody) {
        List<int> bytes = await multipart.file.readAsBytes();
        String fileName = multipart.file.name;
        if (fileName.isEmpty) {
          fileName = Uri.file(multipart.file.path).pathSegments.last;
        }
        request.files.add(http.MultipartFile.fromBytes(
          multipart.key,
          bytes,
          filename: fileName,
        ));
      }
      http.Response response = await http.Response.fromStream(await request.send().timeout(Duration(seconds: timeoutInSeconds)));
      return parseResponse(response, uri);
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ uploadFiles error: $e');
      }
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPublic(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      http.Response response = await http.post(Uri.parse(appBaseUrl + uri), headers: {"Content-Type": "application/json"}, body: jsonEncode(body)).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, appBaseUrl + uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPrivate(String uri, dynamic body, String token) async {
    try {
      http.Response response = await http
          .post(Uri.parse(appBaseUrl + uri), body: jsonEncode(body), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> logout(String uri, String token) async {
    try {
      http.Response response =
          await http.post(Uri.parse(appBaseUrl + uri), headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'}).timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Response parseResponse(http.Response res, String uri) {
    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (e) {
      body = res.body;
    }
    Response response = Response(
      body: body != null && body != '' ? body : res.body,
      bodyString: res.body.toString(),
      headers: res.headers,
      statusCode: res.statusCode,
      statusText: res.reasonPhrase,
    );
    if (response.statusCode != 200 && response.body != null && response.body is! String) {
      if (response.body.toString().startsWith('{errors: [{code:')) {
        response = Response(statusCode: response.statusCode, body: response.body, statusText: 'error');
      } else if (response.body.toString().startsWith('{message')) {
        response = Response(statusCode: response.statusCode, body: response.body, statusText: response.body['message']);
      }
    }
    return response;
  }
}

class MultipartBody {
  String key;
  XFile file;
  MultipartBody(this.key, this.file);
}
