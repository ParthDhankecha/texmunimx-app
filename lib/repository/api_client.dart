import 'dart:convert';
import 'dart:developer';

import 'package:textile_po/repository/api_exception.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:textile_po/repository/media_type_from_file.dart';
import 'package:textile_po/utils/shared_pref.dart';

enum ApiType { get, post, put, delete }

class ApiClient extends GetxService {
  final String baseUrl;
  final Sharedprefs sp;

  ApiClient({required this.baseUrl, required this.sp});

  //get request
  Future<dynamic> request(
    String endPoint, {
    ApiType method = ApiType.get,
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    log('url : $baseUrl$endPoint');
    final url = Uri.parse('$baseUrl$endPoint');
    http.Response response;

    try {
      switch (method) {
        case ApiType.post:
          response = await http.post(url, body: body, headers: headers);
          break;

        case ApiType.put:
          response = await http.put(url, body: body, headers: headers);
          break;

        case ApiType.delete:
          response = await http.delete(url, body: body, headers: headers);
          break;
        default:
          response = await http.get(url, headers: headers);
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          return response.body;

        case 401:
          throw ApiException(statusCode: 401, message: 'Unauthorized');

        case 404:
          throw ApiException(statusCode: 404, message: 'Not Found');

        default:
          throw ApiException(
            statusCode: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        statusCode: -1,
        message: 'Network or Parsing error : $e',
      );
    }
  }

  // post request
  Future<String> requestPost(
    String endPoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    log('url : $baseUrl$endPoint');
    final url = Uri.parse('$baseUrl$endPoint');
    http.Response response;

    try {
      response = await http.post(url, body: body, headers: headers);

      switch (response.statusCode) {
        case 200:
        case 201:
          return response.body;

        case 401:
          throw ApiException(statusCode: 401, message: 'Unauthorized');

        case 404:
          throw ApiException(statusCode: 404, message: 'Not Found');

        default:
          throw ApiException(
            statusCode: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        statusCode: -1,
        message: 'Network or Parsing error : $e',
      );
    }
  }

  //post with image
  Future<dynamic> requestMultipartPost(
    String endPoint, {
    required String filePath,
    required String fileKey,
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    log('url : $baseUrl$endPoint');
    final url = Uri.parse('$baseUrl$endPoint');

    try {
      var request = http.MultipartRequest('POST', url);

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }
      var contentType = getMediaTypeFromFile(filePath);

      // Add file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey, // The key for the file in the request body
          filePath, // The path to the file
          contentType: contentType,
        ),
      );

      // Add other form fields if available
      if (body != null) {
        request.fields.addAll(body);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      switch (response.statusCode) {
        case 200:
        case 201:
          return json.decode(response.body);

        case 401:
          throw ApiException(statusCode: 401, message: 'Unauthorized');

        case 404:
          throw ApiException(statusCode: 404, message: 'Not Found');

        default:
          throw ApiException(
            statusCode: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: -1,
        message: 'Network or Parsing error : $e',
      );
    }
  }

  // put request
  Future<dynamic> requestPut(
    String endPoint, {
    Map<String, String>? headers,
    Map<String, String>? body,
  }) async {
    log('url : $baseUrl$endPoint');
    final url = Uri.parse('$baseUrl$endPoint');
    http.Response response;

    try {
      response = await http.put(url, body: body, headers: headers);
      switch (response.statusCode) {
        case 200:
        case 201:
          return response.body;

        case 401:
          throw ApiException(statusCode: 401, message: 'Unauthorized');

        case 404:
          throw ApiException(statusCode: 404, message: 'Not Found');

        default:
          throw ApiException(
            statusCode: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        statusCode: -1,
        message: 'Network or Parsing error : $e',
      );
    }
  }

  Future<dynamic> requestMultipartPut(
    String endPoint, {
    String? filePath,
    String? fileKey,
    required Map<String, String> body,
    Map<String, String>? headers,
  }) async {
    log('url : $baseUrl$endPoint');
    final url = Uri.parse('$baseUrl$endPoint');

    try {
      var request = http.MultipartRequest('PUT', url);

      // Add headers
      if (headers != null) {
        request.headers.addAll(headers);
      }

      // Add file to the request
      if (filePath != null) {
        var contentType = getMediaTypeFromFile(filePath);

        request.files.add(
          await http.MultipartFile.fromPath(
            fileKey!,
            filePath,
            contentType: contentType,
          ),
        );
      }

      // Add other form fields
      request.fields.addAll(body);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      switch (response.statusCode) {
        case 200:
        case 201:
          return json.decode(response.body);

        case 401:
          throw ApiException(statusCode: 401, message: 'Unauthorized');

        case 404:
          throw ApiException(statusCode: 404, message: 'Not Found');

        default:
          throw ApiException(
            statusCode: response.statusCode,
            message: response.reasonPhrase ?? '',
          );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        statusCode: -1,
        message: 'Network or Parsing error : $e',
      );
    }
  }
}
