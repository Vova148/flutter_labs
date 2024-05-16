import Flutter
import UIKit

public class SwiftFlashlightPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flashlight_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlashlightPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "turnOn" || call.method == "turnOff") {
      result(FlutterError(code: "UNAVAILABLE", message: "Flashlight not available on iOS", details: nil))
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
