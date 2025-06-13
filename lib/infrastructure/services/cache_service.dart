import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> storeString(String key, String value);
  Future<String?> getString(String key);
  Future<void> storeObject<T>(String key, T object, Map<String, dynamic> Function(T) toJson);
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> storeList<T>(String key, List<T> list, Map<String, dynamic> Function(T) toJson);
  Future<List<T>?> getList<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> exists(String key);
  Future<void> setTimestamp(String key);
  Future<bool> isExpired(String key, Duration maxAge);
}

@LazySingleton(as: CacheService)
class CacheServiceImpl implements CacheService {
  final SharedPreferences _prefs;

  CacheServiceImpl(this._prefs);

  @override
  Future<void> storeString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> storeObject<T>(String key, T object, Map<String, dynamic> Function(T) toJson) async {
    final jsonString = jsonEncode(toJson(object));
    await storeString(key, jsonString);
    await setTimestamp('${key}_timestamp');
  }

  @override
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      // Invalid JSON, remove corrupted data
      await remove(key);
      return null;
    }
  }

  @override
  Future<void> storeList<T>(String key, List<T> list, Map<String, dynamic> Function(T) toJson) async {
    final jsonList = list.map((item) => toJson(item)).toList();
    final jsonString = jsonEncode(jsonList);
    await storeString(key, jsonString);
    await setTimestamp('${key}_timestamp');
  }

  @override
  Future<List<T>?> getList<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    final jsonString = await getString(key);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      // Invalid JSON, remove corrupted data
      await remove(key);
      return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
    await _prefs.remove('${key}_timestamp');
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> exists(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<void> setTimestamp(String key) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _prefs.setInt(key, timestamp);
  }

  @override
  Future<bool> isExpired(String key, Duration maxAge) async {
    final timestampKey = '${key}_timestamp';
    final timestamp = _prefs.getInt(timestampKey);

    if (timestamp == null) return true;

    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final expiration = lastUpdated.add(maxAge);

    return DateTime.now().isAfter(expiration);
  }
}

// Cache Keys Constants
class CacheKeys {
  static const String topProducts = 'top_products';
  static const String productDetails = 'product_details_';

  static String productDetail(String productId) => '$productDetails$productId';
}
