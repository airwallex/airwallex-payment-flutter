import Foundation

final class AirwallexLocaleManager {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var currentLanguageTag: String? {
        guard let languageTag = userDefaults.string(forKey: Self.languageTagKey) else {
            return nil
        }
        return Self.normalizeLanguageTag(languageTag)
    }

    func setLocale(_ languageTag: String?) {
        let normalizedLanguageTag = Self.normalizeLanguageTag(languageTag)
        userDefaults.set(normalizedLanguageTag, forKey: Self.languageTagKey)
        applyLocale()
    }

    func applyLocale() {
        guard let normalizedLanguageTag = currentLanguageTag else {
            return
        }

        userDefaults.set(Self.preferredLanguageTags(for: normalizedLanguageTag), forKey: "AppleLanguages")
        userDefaults.set(normalizedLanguageTag.replacingOccurrences(of: "-", with: "_"), forKey: "AppleLocale")
        userDefaults.set(normalizedLanguageTag, forKey: Self.languageTagKey)
        userDefaults.synchronize()
    }

    private static let languageTagKey = "airwallex_payment_flutter.languageTag"
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
