package com.example.flashlight_plugin

import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlashlightPlugin  */
class FlashlightPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private var channel: MethodChannel? = null
  private var cameraManager: CameraManager? = null
  private var cameraId: String? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flashlight_plugin")
    channel?.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "turnOn" -> {
        try {
          cameraManager?.setTorchMode(cameraId!!, true)
          result.success(null)
        } catch (e: CameraAccessException) {
          result.error("CAMERA_ACCESS", "Failed to access camera", null)
        }
      }
      "turnOff" -> {
        try {
          cameraManager?.setTorchMode(cameraId!!, false)
          result.success(null)
        } catch (e: CameraAccessException) {
          result.error("CAMERA_ACCESS", "Failed to access camera", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
    cameraManager = binding.activity.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    try {
      cameraId = cameraManager?.cameraIdList?.get(0)
    } catch (e: CameraAccessException) {
      e.printStackTrace()
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding) {}
  override fun onDetachedFromActivity() {}
}
