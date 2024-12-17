import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class Storage {
  Future<void> saveData(String key, String value);
  Future<String?> getData(String key);
  Future<void> removeData(String key);
}

class LocalStorage implements Storage {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<String?> getData(String key) {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> removeData(String key) {
    return _secureStorage.delete(key: key);
  }

  @override
  Future<void> saveData(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }
}
