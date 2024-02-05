
import 'package:flutter/services.dart';

class OverlayController {
  OverlayController._();

  static const MethodChannel _channel =
      MethodChannel('rl/overlay_channel');

  static Future<bool> get isPermissionGranted async {
    try {
      return await _channel.invokeMethod<bool>('checkPermission') ?? false;
    } on PlatformException {
      return Future.value(false);
    }
  }

  static Future<bool?> get requestPermission async {
    try {
      return await _channel.invokeMethod<bool?>('requestPermission');
    } on PlatformException {
      rethrow;
    }
  }
}