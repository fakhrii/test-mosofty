

import 'dart:convert';

import 'package:test_technique/models/mobile_model.dart';

import '../models/employee_model.dart';
import '../networking/api_base_helper.dart';

class MobileRepository {

  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Mobile>> fetchMobiles(String token) async {
    List response = await _helper.get(url: "mobiles",token: token);
    return response.map((message) {
      print(message);
      return Mobile.fromJson(message);
    }).toList();
  }

  Future<List<Employee>> fetchEmployees(String token) async {
    List response = await _helper.get(url: "persons",token: token);

    return response.map((message) => Employee.fromJson(message)).toList();
  }

  Future<Mobile> getMobile(String id, String token) async {
    var response = await _helper.get(url: 'mobiles/$id', token: token);
    return Mobile.fromJson(response);
  }


  Future<void> createMobile(Mobile folder, String token) async {
    await _helper.post(url: 'mobiles/create', token: token, body: json.encode(Mobile().toJson(folder)));
  }

  Future<bool> updateMobile(Mobile mobile, String token) async {
    try {
      var response = await _helper.put(
          url: 'mobiles/upmobile/${mobile.id}',
          token: token,
          body: json.encode(Mobile().toJson(mobile)));
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> assignMobile(int mobileId,int employeeId, String token) async {
    try {
      var response = await _helper.put(
          url: 'mobiles/${mobileId}/$employeeId',
          token: token);
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<void> deleteMobile(Mobile mobile, String token) async {
    await _helper.delete(url: 'mobiles/${mobile.id}', token: token);
  }
}