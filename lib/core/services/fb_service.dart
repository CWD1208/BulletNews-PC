import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

class FacebookService {
  static final FacebookService _instance = FacebookService._internal();

  factory FacebookService() {
    return _instance;
  }

  FacebookService._internal();

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  /// Initialize the Facebook SDK (Optional, but good for custom settings)
  /// Note: The SDK auto-initializes if configured correctly in AndroidManifest/Info.plist
  Future<void> init() async {
    try {
      // Create an instance helps to ensure the MethodChannel is setup
      // You can also toggle advert ID collection here if needed
      await _facebookAppEvents.setAutoLogAppEventsEnabled(true);

      if (kDebugMode) {
        print("Facebook SDK initialized");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Facebook SDK init error: $e");
      }
    }
  }

  /// Log a custom event
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
    double? valueToSum,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: name,
        parameters: parameters,
        valueToSum: valueToSum,
      );
      if (kDebugMode) {
        print("Facebook event logged: $name");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Facebook logEvent error: $e");
      }
    }
  }

  /// Log purchase event
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _facebookAppEvents.logPurchase(
        amount: amount,
        currency: currency,
        parameters: parameters,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Facebook logPurchase error: $e");
      }
    }
  }

  /// Set the user ID (similar to AppsFlyer setCustomerUserId)
  Future<void> setUserID(String? id) async {
    try {
      await _facebookAppEvents.setUserID(id!);
      if (kDebugMode) {
        print("Facebook setUserID: $id");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Facebook setUserID error: $e");
      }
    }
  }
}
