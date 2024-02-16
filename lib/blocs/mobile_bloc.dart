import 'dart:async';

import '../models/mobile_model.dart';
import '../networking/api_response.dart';
import '../repositories/person_repository.dart';
import 'package:flutter/foundation.dart';


class MobileBloc {
  late MobileRepository _mobilesListRepository;
  final  _mobilesController = StreamController<ApiResponse<List<Mobile>>>.broadcast();


  StreamSink<ApiResponse<List<Mobile>>> get mobilesListSink =>
      _mobilesController.sink;

  Stream<ApiResponse<List<Mobile>>> get mobilesStream =>
      _mobilesController.stream.cast<ApiResponse<List<Mobile>>>();

  MobileBloc(String token) {
    _mobilesListRepository = MobileRepository();
    getMobilesList(token);
  }

  getMobilesList(String token) async {
    mobilesListSink.add(ApiResponse.loading('Fetching list'));
    try {
      List<Mobile> list =
      await _mobilesListRepository.fetchMobiles(token);
      mobilesListSink.add(ApiResponse.completed(list));
    } catch (e) {
      mobilesListSink.add(ApiResponse.error(e.toString()));
      if (kDebugMode) {
        print(e);
      }
    }
  }

  dispose() {
    _mobilesController.close();
  }
}
