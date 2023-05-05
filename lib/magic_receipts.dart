import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef MagicReceiptsWallLoadedListener = void Function();
typedef MagicReceiptsWallLoadFailedListener = void Function(
    MagicReceiptsLoadError);
typedef MagicReceiptsWallShowedListener = void Function();
typedef MagicReceiptsWallHiddenListener = void Function();
typedef MagicReceiptsWallShowFailedListener = void Function(
    MagicReceiptsShowError);

class MagicReceiptsShowError {
  final String message;

  MagicReceiptsShowError._private(this.message);

  static MagicReceiptsShowError? fromArguments(dynamic error) {
    if (error != null && error is String) {
      return MagicReceiptsShowError._private(error);
    } else {
      return null;
    }
  }
}

class MagicReceiptsLoadError {
  final String message;

  MagicReceiptsLoadError._private(this.message);

  static MagicReceiptsLoadError? fromArguments(dynamic error) {
    if (error != null && error is String) {
      return MagicReceiptsLoadError._private(error);
    } else {
      return null;
    }
  }
}

class MagicReceipts {
  final MethodChannel _channel;

  MagicReceiptsWallLoadedListener? _magicReceiptsWallLoadedListener;
  MagicReceiptsWallLoadFailedListener? _magicReceiptsWallLoadFailedListener;
  MagicReceiptsWallShowedListener? _magicReceiptsWallShowedListener;
  MagicReceiptsWallHiddenListener? _magicReceiptsWallHiddenListener;
  MagicReceiptsWallShowFailedListener? _magicReceiptsWallShowFailedListener;

  static final MagicReceipts _instance =
      MagicReceipts._private(const MethodChannel('magic_receipts'));

  MagicReceipts._private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  static Future<void> initialize(
      {required String? androidApiKey,
      required String? iosApiKey,
      String? clickId,
      String? userId,
      bool incentiveMode = false}) async {
    _instance._channel.invokeMethod("initialize", <String, dynamic>{
      'androidApiKey': androidApiKey,
      'iOSApiKey': iosApiKey,
      'clickId': clickId,
      'userId': userId,
      'incentiveMode': incentiveMode
    });
  }

  static Future<void> show() {
    return _instance._channel.invokeMethod("show");
  }

  static Future<void> hide() {
    return _instance._channel.invokeMethod("hide");
  }

  static Future<bool> isReady() {
    return _instance._channel
        .invokeMethod<bool>("isReady")
        .then<bool>((bool? value) => value ?? false);
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "magicReceiptsWallLoaded":
        _instance._magicReceiptsWallLoadedListener?.call();
        break;
      case "magicReceiptsWallLoadFailed":
        final error = MagicReceiptsLoadError.fromArguments(call.arguments);

        if (error != null) {
          _instance._magicReceiptsWallLoadFailedListener?.call(error);
        }

        break;
      case "magicReceiptsWallShowed":
        _instance._magicReceiptsWallShowedListener?.call();
        break;
      case "magicReceiptsWallHidden":
        _instance._magicReceiptsWallHiddenListener?.call();
        break;
      case "magicReceiptsWallShowFailed":
        final error = MagicReceiptsShowError.fromArguments(call.arguments);

        if (error != null) {
          _instance._magicReceiptsWallShowFailedListener?.call(error);
        }

        break;
      default:
        if (kDebugMode) {
          print("Unknown method ${call.method}");
        }
    }
  }

  static void setMagicReceiptsWallLoadedListener(
          MagicReceiptsWallLoadedListener magicReceiptsWallLoadedListener) =>
      _instance._magicReceiptsWallLoadedListener =
          magicReceiptsWallLoadedListener;

  static void setMagicReceiptsWallLoadFailedListener(
          MagicReceiptsWallLoadFailedListener
              magicReceiptsWallLoadFailedListener) =>
      _instance._magicReceiptsWallLoadFailedListener =
          magicReceiptsWallLoadFailedListener;

  static void setMagicReceiptsWallShowedListener(
          MagicReceiptsWallShowedListener magicReceiptsWallShowedListener) =>
      _instance._magicReceiptsWallShowedListener =
          magicReceiptsWallShowedListener;

  static void setMagicReceiptsWallHiddenListener(
          MagicReceiptsWallHiddenListener magicReceiptsWallHiddenListener) =>
      _instance._magicReceiptsWallHiddenListener =
          magicReceiptsWallHiddenListener;

  static void setMagicReceiptsWallShowFailedListener(
          MagicReceiptsWallShowFailedListener
              magicReceiptsWallShowFailedListener) =>
      _instance._magicReceiptsWallShowFailedListener =
          magicReceiptsWallShowFailedListener;
}
