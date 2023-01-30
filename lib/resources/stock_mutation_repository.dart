import 'dart:developer';

import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/resources/stock_mutation_api_provider.dart';
import 'package:scanner/resources/stock_mutation_db_provider.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:sembast/sembast.dart';

class StockMutationRepository {
  StockMutationRepository(Database db) {
    _apiProvider = StockMutationApiProvider();
    _dbProvider = StockMutationDbProvider(db);
  }

  late StockMutationApiProvider _apiProvider;
  late StockMutationDbProvider _dbProvider;

  Stream<Map<int, StockMutation>> getStockMutationsStream(int picklistId) {
    return _dbProvider.getStockMutationsStream(picklistId);
  }

  Future<BaseResponse> saveMutation(StockMutation mutation) async {
    if (InternetState.shared.connectivityAvailable()) {
      try {
        var resp = await _apiProvider.addStockMutation(mutation);
        if (resp.data != null) {
          final data = BaseResponse.fromJson(resp.data!);
          print(data.toJson());
          if (data.success) {
            final id = await _dbProvider.addStockMutation(mutation);
            await _dbProvider.deleteStockMutation(id);
            return data;
          } else {
            throw data;
          }
        } else {
          throw BaseResponse(success: false, message: 'Data is empty!');
        }
      } catch (error) {
        print(error);
        if (error is BaseResponse) {
          throw error;
        } else {
          throw BaseResponse(success: false, message: 'Unknown Error!');
        }
      }
    } else {
      log("No INTERNET");
      log("No NO NO");
      log("No INTERNET");
      final id = await _dbProvider.addStockMutation(mutation);
      addStockMutation(id, mutation);
      return BaseResponse(success: true, message: '');
    }
  }

  Future<dynamic> processQueue() async {
    final mutations = await _dbProvider.getStockMutations();
    // print("mutation que".toUpperCase());
    // print("mutation queue".toUpperCase());
    // print(mutations.length);
    // (mutations.forEach((key, value) {
    //   print("$key ---  ${value.toJson().toString()}");
    // }));
    mutations.forEach(addStockMutation);
  }

  Future<BaseResponse> addStockMutation(int id, StockMutation mutation) async {
    try {
      var resp = await _apiProvider.addStockMutation(mutation);
      if (resp.data != null) {
        final data = BaseResponse.fromJson(resp.data!);
        if (data.success) {
          await _dbProvider.deleteStockMutation(id);
        }
        return data;
      } else {
        return BaseResponse(success: false, message: 'Data is empty!');
      }
    } catch (e) {
      print(e);
      return BaseResponse(success: false, message: e.toString());
    }
  }

  Future<void> doCancelledRemain(StockMutation mutation) async {
    await _apiProvider.triggerCancelledAmount(
        picklistId: mutation.picklistId, lineId: mutation.lineId);
  }

  Future<void> doBackorderRemain(StockMutation mutation) async {
    await _apiProvider.triggerBackorderAmount(
        picklistId: mutation.picklistId, lineId: mutation.lineId);
  }
}
