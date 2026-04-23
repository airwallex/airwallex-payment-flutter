import Airwallex
import Foundation
import ObjectiveC.runtime

internal enum AirwallexResourceBundleName: String {
    case core = "AirwallexCore"
    case payment = "AirwallexPayment"
    case paymentSheet = "AirwallexPaymentSheet"
}

internal final class AirwallexBundleLocalizer {
    static let shared = AirwallexBundleLocalizer()

    private let sdkBundleProvider: () -> Bundle

    init(sdkBundleProvider: @escaping () -> Bundle = { Bundle(for: Airwallex.self) }) {
        self.sdkBundleProvider = sdkBundleProvider
    }

    func apply(languageTag: String, preferredLanguageTags: [String]) {
        for bundle in resourceBundles() {
            Self.installLocalizedBundleClassIfNeeded(on: bundle)
            objc_setAssociatedObject(
                bundle,
                &Self.languageTagAssociationKey,
                languageTag,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
            objc_setAssociatedObject(
                bundle,
                &Self.preferredLanguageTagsAssociationKey,
                preferredLanguageTags,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    func resourceBundle(named bundleName: AirwallexResourceBundleName) -> Bundle? {
        switch bundleName {
        case .core:
            return resourceBundle(candidateNames: [bundleName.rawValue, "Airwallex_AirwallexCore"])
        case .payment, .paymentSheet:
            return resourceBundle(candidateNames: [bundleName.rawValue])
        }
    }

    fileprivate static func localizedBundle(for bundle: Bundle) -> Bundle? {
        guard
            let preferredLanguageTags = objc_getAssociatedObject(
                bundle,
                &preferredLanguageTagsAssociationKey
            ) as? [String]
        else {
            return nil
        }

        for languageTag in preferredLanguageTags {
            guard
                let bundlePath = bundle.path(forResource: languageTag, ofType: "lproj"),
                let localizedBundle = Bundle(path: bundlePath)
            else {
                continue
            }
            return localizedBundle
        }

        return nil
    }

    private func resourceBundles() -> [Bundle] {
        var uniqueBundles = [String: Bundle]()
        for bundleName in [
            AirwallexResourceBundleName.core,
            .payment,
            .paymentSheet,
        ] {
            guard let bundle = resourceBundle(named: bundleName) else {
                continue
            }
            uniqueBundles[bundle.bundlePath] = bundle
        }
        return Array(uniqueBundles.values)
    }

    private func resourceBundle(candidateNames: [String]) -> Bundle? {
        let sdkBundle = sdkBundleProvider()
        for bundleName in candidateNames {
            guard
                let bundlePath = sdkBundle.path(forResource: bundleName, ofType: "bundle"),
                let bundle = Bundle(path: bundlePath)
            else {
                continue
            }
            return bundle
        }
        return nil
    }

    private static func installLocalizedBundleClassIfNeeded(on bundle: Bundle) {
        guard object_getClass(bundle) !== AirwallexLocalizedBundle.self else {
            return
        }
        object_setClass(bundle, AirwallexLocalizedBundle.self)
    }

    private static var languageTagAssociationKey: UInt8 = 0
    private static var preferredLanguageTagsAssociationKey: UInt8 = 0
}

private final class AirwallexLocalizedBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let localizedBundle = AirwallexBundleLocalizer.localizedBundle(for: self) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return localizedBundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

final class AirwallexLocaleManager {
    private let userDefaults: UserDefaults
    private let bundleLocalizer: AirwallexBundleLocalizer

    init(
        userDefaults: UserDefaults = .standard,
        bundleLocalizer: AirwallexBundleLocalizer = .shared
    ) {
        self.userDefaults = userDefaults
        self.bundleLocalizer = bundleLocalizer
    }

    var currentLanguageTag: String {
        let preferredLanguage = (userDefaults.array(forKey: "AppleLanguages") as? [String])?
            .first { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            ?? Locale.preferredLanguages.first
        return Self.normalizeLanguageTag(preferredLanguage)
    }

    func applyLocale() {
        let normalizedLanguageTag = currentLanguageTag
        bundleLocalizer.apply(
            languageTag: normalizedLanguageTag,
            preferredLanguageTags: Self.preferredLanguageTags(for: normalizedLanguageTag)
        )
    }

    private static let defaultLanguageTag = "en"

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
