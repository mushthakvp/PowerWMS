import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/repository/local_db/stock_mutation_db_provider.dart';
import 'package:scanner/repository/remote_db/stock_mutation_api_provider.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:sembast/sembast.dart';

class StockMutationRepository {
  final StockMutationApiProvider _apiProvider = StockMutationApiProvider();
  late final StockMutationDbProvider _dbProvider;

  StockMutationRepository(Database db) {
    _dbProvider = StockMutationDbProvider(db);
  }

  Stream<Map<int, StockMutation>> getStockMutationsStream(int picklistId) =>
      _dbProvider.getStockMutationsStream(picklistId);

  Future<BaseResponse> saveMutation(StockMutation mutation) async {
    if (InternetState.shared.connectivityAvailable()) {
      return _trySaveMutationOnline(mutation);
    } else {
      return _saveMutationOffline(mutation);
    }
  }

  Future<BaseResponse> _trySaveMutationOnline(StockMutation mutation) async {
    try {
      var resp = await _apiProvider.addStockMutation(mutation);
      return _processApiResponse(resp, mutation);
    } catch (error) {
      print(error);
      throw _handleError(error);
    }
  }

  BaseResponse _handleError(dynamic error) {
    if (error is BaseResponse) {
      return error;
    } else {
      return BaseResponse(success: false, message: 'Unknown Error!');
    }
  }

  Future<BaseResponse> _processApiResponse(resp, mutation) async {
    if (resp.data != null) {
      final data = BaseResponse.fromJson(resp.data!);
      print(data.toJson());
      if (data.success) {
        await _dbProvider.deleteStockMutation(await _dbProvider.addStockMutation(mutation));
      }
      return data;
    } else {
      throw BaseResponse(success: false, message: 'Data is empty!');
    }
  }

  Future<BaseResponse> _saveMutationOffline(StockMutation mutation) async {
    var id = await _dbProvider.addStockMutation(mutation);
    return await addStockMutation(id, mutation);
  }

  Future<void> processQueue() async {
    var mutations = await _dbProvider.getStockMutations();
    for (var mutation in mutations.entries) {
      await addStockMutation(mutation.key, mutation.value);
    }
  }

  Future<BaseResponse> addStockMutation(int id, StockMutation mutation) async {
    try {
      var resp = await _apiProvider.addStockMutation(mutation);
      if (resp.data != null) {
        final data = BaseResponse.fromJson(resp.data!);
        if (data.success) await _dbProvider.deleteStockMutation(id);
        return data;
      } else {
        return BaseResponse(success: false, message: 'Data is empty!');
      }
    } catch (e) {
      print(e);
      return BaseResponse(success: false, message: e.toString());
    }
  }

  Future<void> doCancelledRemain(StockMutation mutation) =>
      _apiProvider.triggerCancelledAmount(
          picklistId: mutation.picklistId, lineId: mutation.lineId);

  Future<void> doBackorderRemain(StockMutation mutation) =>
      _apiProvider.triggerBackorderAmount(
          picklistId: mutation.picklistId, lineId: mutation.lineId);
}

// class StockMutationRepository {
//   StockMutationRepository(Database db) {
//     _apiProvider = StockMutationApiProvider();
//     _dbProvider = StockMutationDbProvider(db);
//   }
//
//   late StockMutationApiProvider _apiProvider;
//   late StockMutationDbProvider _dbProvider;
//
//   Stream<Map<int, StockMutation>> getStockMutationsStream(int picklistId) {
//     return _dbProvider.getStockMutationsStream(picklistId);
//   }
//
//   Future<BaseResponse> saveMutation(StockMutation mutation) async {
//     if (InternetState.shared.connectivityAvailable()) {
//       try {
//         var resp = await _apiProvider.addStockMutation(mutation);
//         if (resp.data != null) {
//           final data = BaseResponse.fromJson(resp.data!);
//           print(data.toJson());
//           if (data.success) {
//             final id = await _dbProvider.addStockMutation(mutation);
//             await _dbProvider.deleteStockMutation(id);
//             return data;
//           } else {
//             throw data;
//           }
//         } else {
//           throw BaseResponse(success: false, message: 'Data is empty!');
//         }
//       } catch (error) {
//         print(error);
//         if (error is BaseResponse) {
//           throw error;
//         } else {
//           throw BaseResponse(success: false, message: 'Unknown Error!');
//         }
//       }
//     } else {
//       final id = await _dbProvider.addStockMutation(mutation);
//       addStockMutation(id, mutation);
//       return BaseResponse(success: false, message: 'No Internet');
//     }
//   }
//
//   Future<dynamic> processQueue() async {
//     final mutations = await _dbProvider.getStockMutations();
//     mutations.forEach(addStockMutation);
//   }
//
//   Future<BaseResponse> addStockMutation(int id, StockMutation mutation) async {
//     try {
//       var resp = await _apiProvider.addStockMutation(mutation);
//       if (resp.data != null) {
//         final data = BaseResponse.fromJson(resp.data!);
//         if (data.success) {
//           await _dbProvider.deleteStockMutation(id);
//         }
//         return data;
//       } else {
//         return BaseResponse(success: false, message: 'Data is empty!');
//       }
//     } catch (e) {
//       print(e);
//       return BaseResponse(success: false, message: e.toString());
//     }
//   }
//
//   Future<void> doCancelledRemain(StockMutation mutation) async {
//     await _apiProvider.triggerCancelledAmount(
//         picklistId: mutation.picklistId, lineId: mutation.lineId);
//   }
//
//   Future<void> doBackorderRemain(StockMutation mutation) async {
//     await _apiProvider.triggerBackorderAmount(
//         picklistId: mutation.picklistId, lineId: mutation.lineId);
//   }
// }





