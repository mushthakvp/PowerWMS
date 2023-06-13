import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../model/pick_list_model.dart';

class HiveDB {
  static Future<void> initialize() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter();
    Hive.init(appDocDir.path);
    if (!Hive.isAdapterRegistered(PickListNewAdapter().typeId)) {
      Hive.registerAdapter(PickListNewAdapter());
    }
    if (!Hive.isAdapterRegistered(DebtorAdapter().typeId)) {
      Hive.registerAdapter(DebtorAdapter());
    }
  }
}
