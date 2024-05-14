import 'package:flutter/services.dart';

class FlashlightControl {
  static const MethodChannel _channel = MethodChannel('flashlight_plugin');

  static Future<void> turnOn() async {
    try {
      await _channel.invokeMethod('turnOn');
    } on PlatformException catch (e) {
      print("Failed to turn on flashlight: '${e.message}'.");
    }
  }

  static Future<void> turnOff() async {
    try {
      await _channel.invokeMethod('turnOff');
    } on PlatformException catch (e) {
      print("Failed to turn off flashlight: '${e.message}'.");
    }
  }
}
