import Flutter
import UIKit
import MagicReceipts

public class SwiftMagicReceiptsPlugin: NSObject, FlutterPlugin {
    
    private static var channel: FlutterMethodChannel? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "magic_receipts", binaryMessenger: registrar.messenger())
        let instance = SwiftMagicReceiptsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "initialize": initializeMagicReceipts(with: call, result: result)
        case "show":
            MagicReceipts.show()
            result(nil)
        case "hide":
            MagicReceipts.hide()
            result(nil)
        case "isReady": result(MagicReceipts.isReady())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    deinit {
        SwiftMagicReceiptsPlugin.channel = nil
    }
    
    private func show() {
        
    }
    
    private func initializeMagicReceipts(with call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any], let apiKey = arguments["iOSApiKey"] as? String else {
            result(FlutterError(code: "no_api_key", message: "Pollfish API Key is not provided", details: nil))
            return
        }
        
        let params = Params(apiKey)
        
        if let clickId = arguments["clickId"] as? String {
            params.clickId(clickId)
        }
        
        if let userId = arguments["userId"] as? String {
            params.userId(userId)
        }
        
        if let incentiveMode = arguments["incentiveMode"] as? Bool {
            params.incentiveMode(incentiveMode)
        }
        
        MagicReceipts.initialize(with: params, delegate: self)
    }
}

extension SwiftMagicReceiptsPlugin: MagicReceiptsDelegate {
    
    public func onWallDidLoad() {
        SwiftMagicReceiptsPlugin.channel?.invokeMethod("magicReceiptsWallLoaded", arguments: nil)
    }
    
    public func onWallDidFailToLoad(error: MagicReceiptsLoadError) {
        var message = ""
        
        switch (error) {
        case .disabled:
            message = "DISABLED"
        case .emptyApiKey:
            message = "EMPTY_API_KEY"
        case .emptyUserId:
            message = "EMPTY_USER_ID"
        case .internal:
            message = "INTERNAL"
        case .noIdfaPermission:
            message = "NO_IDFA_PERMISSION"
        case .timeout:
            message = "TIMEOUT"
        case .undefinedUser:
            message = "UNDEFINED_USER"
        case .wrongApiKey:
            message = "WRONG_API_KEY"
        default:
            message = "UNKNOWN"
        }
        
        SwiftMagicReceiptsPlugin.channel?.invokeMethod("magicReceiptsWallLoadFailed", arguments: message)
    }
    
    public func onWallDidShow() {
        SwiftMagicReceiptsPlugin.channel?.invokeMethod("magicReceiptsWallShowed", arguments: nil)
    }
    
    public func onWallDidFaildToShow(error: MagicReceiptsShowError) {
        var message = ""
        
        switch (error) {
        case .internal:
            message = "INTERNAL"
        case .notLoaded:
            message = "NOT_LOADED"
        case .timeout:
            message = "TIMEOUT"
        default:
            message = "UNKNOWN"
        }
        
        SwiftMagicReceiptsPlugin.channel?.invokeMethod("magicReceiptsWallShowFailed", arguments: message)
    }
    
    public func onWallDidHide() {
        SwiftMagicReceiptsPlugin.channel?.invokeMethod("magicReceiptsWallHidden", arguments: nil)
    }
    
}
