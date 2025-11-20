import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/form_data_model.dart';

class HiveService {
  static const String _boxName = 'formDataBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FormDataModelAdapter());
    await Hive.openBox<FormDataModel>(_boxName);
  }

  Box<FormDataModel> get _box => Hive.box<FormDataModel>(_boxName);

  Future<void> addData(FormDataModel data) async {
    await _box.add(data);
  }

  Future<void> deleteData(dynamic key) async {
    await _box.delete(key);
  }

  Future<void> clearAllData() async {
    await _box.clear();
  }

  ValueListenable<Box<FormDataModel>> listenable() {
    return _box.listenable();
  }
}
