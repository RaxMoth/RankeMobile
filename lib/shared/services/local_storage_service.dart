import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger_service.dart';

/// Local Storage Service using SharedPreferences
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late SharedPreferences _prefs;
  bool _initialized = false;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      LoggerService.info('LocalStorageService initialized');
    } catch (e) {
      LoggerService.error('Failed to initialize LocalStorageService', e);
      rethrow;
    }
  }

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      LoggerService.error('Error saving string', e);
      return false;
    }
  }

  /// Get string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      LoggerService.error('Error getting string', e);
      return null;
    }
  }

  /// Save int value
  Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      LoggerService.error('Error saving int', e);
      return false;
    }
  }

  /// Get int value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      LoggerService.error('Error getting int', e);
      return null;
    }
  }

  /// Save bool value
  Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      LoggerService.error('Error saving bool', e);
      return false;
    }
  }

  /// Get bool value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      LoggerService.error('Error getting bool', e);
      return null;
    }
  }

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      LoggerService.error('Error saving double', e);
      return false;
    }
  }

  /// Get double value
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      LoggerService.error('Error getting double', e);
      return null;
    }
  }

  /// Save list of strings
  Future<bool> saveList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      LoggerService.error('Error saving list', e);
      return false;
    }
  }

  /// Get list of strings
  List<String>? getList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      LoggerService.error('Error getting list', e);
      return null;
    }
  }

  /// Save JSON object
  Future<bool> saveJson<T>(String key, T value) async {
    try {
      final json = jsonEncode(value);
      return await _prefs.setString(key, json);
    } catch (e) {
      LoggerService.error('Error saving json', e);
      return false;
    }
  }

  /// Get JSON object
  T? getJson<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final json = _prefs.getString(key);
      if (json == null) return null;
      return fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (e) {
      LoggerService.error('Error getting json', e);
      return null;
    }
  }

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      LoggerService.error('Error removing key', e);
      return false;
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      LoggerService.error('Error clearing storage', e);
      return false;
    }
  }

  /// Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}
