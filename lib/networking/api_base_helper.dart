// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:io';
import 'package:flutter/foundation.dart';

import '/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'api_exceptions.dart';

class ApiBaseHelper {


  Future<dynamic> get({required String url, required String token}) async {

    if(kDebugMode) {
      print('Api Get, url $url');
    }
    var responseJson;
    try {
      final response = await http.get(
          Uri.parse(Constants.url + url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token
        },
      );
      print(json.decode(response.body)[0]);


      responseJson = _returnResponse(response);
    } on TimeoutException catch (_) {
      // A timeout occurred.
      rethrow;

    } on SocketException {
      throw SocketException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post({required String url, required String token, dynamic body}) async {
    if(kDebugMode) {
      print('Api Post, url $url');
    }
    var responseJson;
    try {
      final response = await http.post(
          Uri.parse(Constants.url + url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": token
          },
          body: body);
      responseJson = _returnResponse(response);
    } on TimeoutException catch (_) {
      // A timeout occurred.
      rethrow;

    } on SocketException {
      throw SocketException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put({required String url, required String token, dynamic body}) async {
    if(kDebugMode)
      print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(
          Uri.parse(Constants.url + url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": token
          },
          body: body);
      print(response.body);
      responseJson = _returnResponse(response);
    } on TimeoutException catch (_) {
      // A timeout occurred.
      rethrow;

    } on SocketException {
      throw SocketException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete({required String url, required String token, dynamic body}) async {
    if(kDebugMode)
      print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(
          Uri.parse(Constants.url + url),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": token
        },
      );
      apiResponse = _returnResponse(response);
    } on TimeoutException catch (_) {
      // A timeout occurred.
      rethrow;

    } on SocketException {
      throw SocketException('No Internet connection');
    }
    return apiResponse;
  }
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
      var responseJson = json.decode(response.body);
      return responseJson;
    case 204:
      return response.body;
    case 400:
      throw BadRequestException(response.body);
    case 404:
      throw NotFoundException(response.body);
    case 401:
    case 402:
    case 403:

      throw UnauthorisedException(response.body);
    case 420: var responseJson = json.decode(response.body);
    throw FetchDataException(response.body);

    case 421:
      throw Exception(response.body);
    case 504: throw TimeoutException(
        'Gateway Timeout, StatusCode : ${response.statusCode}');
    default:
      throw SocketException(
          'Error server: ${response.body}, StatusCode : ${response.statusCode}');
  }
}
