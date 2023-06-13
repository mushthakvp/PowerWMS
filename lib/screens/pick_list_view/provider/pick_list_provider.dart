import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../dio.dart';
import '../model/pick_list_model.dart';

class PickListProviderV2 extends ChangeNotifier {
  String _dbName = 'picklist';

  Future<List<PickListNew>> getPickListData() async {
    final pref = await SharedPreferences.getInstance();
    final db = await Hive.openBox<PickListNew>(_dbName);
    bool isExist = pref.getBool('isExist') ?? false;
    log("isExist: $isExist and dbName: $_dbName");
    if (!isExist) {
      try {
        log("Get Picklist Data");
        Response response = await dio.post('/picklist/list', data: {
          'skipPaging': true,
        });
        log("Response: ${response.statusCode}");
        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          PickListNewModel data = PickListNewModel.fromJson(response.data);
          log("Picklist Data: ${data.data!.length}");
          await db.clear();
          await db.addAll(data.data!);
          await pref.setBool('isExist', true);
          return db.values.toList();
        } else {
          throw Exception('Failed to load data');
        }
      } on SocketException {
        throw Exception('No Internet connection');
      } catch (e) {
        log(e.toString());
        throw Exception(e.toString());
      }
    } else {
      return db.values.toList();
    }
  }

  Future<List<PickListNew>> getOpenData() async {
    List<PickListNew> data = await getPickListData();
    return data
        .where((element) =>
            element.status == 1 ||
            element.status == 2 ||
            element.status == 7 ||
            element.status == 8)
        .toList();
  }

  Future<List<PickListNew>> getReviseData() async {
    List<PickListNew> data = await getPickListData();
    return data.where((element) => element.status == 4).toList();
  }

  Future<List<PickListNew>> getPickListDataBySearch(String search) async {
    final db = await Hive.openBox<PickListNew>(_dbName);
    List<PickListNew> data = db.values.toList();
    List<PickListNew> filteredData = data
        .where((element) =>
            element.uid!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    return filteredData;
  }

  //Pick List Status

  //added  - 1
  //inProgress - 2
  //inactive - 3
  //picked - 4
  //completed - 5
  //archived - 6
  //priority - 7
  //check - 8

  Color statusColor(int number) {
    switch (number) {
      case 2:
        return Color(0xFF034784);
      case 1:
        return Colors.black;
      case 8:
        return Color(0Xff777777);
      case 7:
        return Color(0xFFed6f56);
      default:
        return Colors.black;
    }
  }
}
