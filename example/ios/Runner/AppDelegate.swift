import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "ExampleHostLocalePlugin"
    ) {
      ExampleHostLocalePlugin.register(with: registrar)
    }
  }
}

private final class ExampleHostLocalePlugin: NSObject, FlutterPlugin {
  private static let defaultLanguageTag = "en"

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "example_host_locale",
      binaryMessenger: registrar.messenger()
    )
    let instance = ExampleHostLocalePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setLanguage":
      let arguments = call.arguments as? [String: Any]
      let normalizedLanguageTag = Self.normalizeLanguageTag(
        arguments?["languageTag"] as? String
      )
      let userDefaults = UserDefaults.standard
      userDefaults.set(
        Self.preferredLanguageTags(for: normalizedLanguageTag),
        forKey: "AppleLanguages"
      )
      userDefaults.set(
        normalizedLanguageTag.replacingOccurrences(of: "-", with: "_"),
        forKey: "AppleLocale"
      )
      userDefaults.synchronize()
      result(normalizedLanguageTag)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func normalizeLanguageTag(_ languageTag: String?) -> String {
    let trimmedLanguageTag = languageTag?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    guard !trimmedLanguageTag.isEmpty else {
      return defaultLanguageTag
    }

    let canonicalTag = trimmedLanguageTag.replacingOccurrences(of: "_", with: "-")
    let components = Locale.components(fromIdentifier: canonicalTag)
    let languageCode = (components[NSLocale.Key.languageCode.rawValue] ?? "").lowercased()

    if languageCode == "zh" {
      let scriptCode = (components[NSLocale.Key.scriptCode.rawValue] ?? "").lowercased()
      let regionCode = (components[NSLocale.Key.countryCode.rawValue] ?? "").uppercased()
      if canonicalTag.caseInsensitiveCompare("zh-Hant") == .orderedSame ||
        scriptCode == "hant" ||
        regionCode == "TW" ||
        regionCode == "HK" ||
        regionCode == "MO" {
        return "zh-Hant"
      }
      return "zh-Hans"
    }

    if languageCode == "en" {
      return defaultLanguageTag
    }

    return canonicalTag
  }

  private static func preferredLanguageTags(for languageTag: String) -> [String] {
    switch languageTag {
    case "zh-Hans":
      return ["zh-Hans", "zh-CN", "zh", defaultLanguageTag]
    case "zh-Hant":
      return ["zh-Hant", "zh-TW", "zh-HK", "zh", defaultLanguageTag]
    default:
      return languageTag == defaultLanguageTag
        ? [languageTag]
        : [languageTag, defaultLanguageTag]
    }
  }
}
