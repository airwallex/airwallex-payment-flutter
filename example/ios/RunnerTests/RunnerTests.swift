import Airwallex
import XCTest

@testable import airwallex_payment_flutter

final class RunnerTests: XCTestCase {
  private var suiteName: String!
  private var userDefaults: UserDefaults!
  private var bundleLocalizer: AirwallexBundleLocalizer!

  override func setUp() {
    super.setUp()
    suiteName = "RunnerTests.\(UUID().uuidString)"
    userDefaults = UserDefaults(suiteName: suiteName)
    userDefaults.removePersistentDomain(forName: suiteName)
    bundleLocalizer = AirwallexBundleLocalizer()
  }

  override func tearDown() {
    if let suiteName {
      userDefaults.removePersistentDomain(forName: suiteName)
    }
    bundleLocalizer.apply(languageTag: "en", preferredLanguageTags: ["en"])
    bundleLocalizer = nil
    userDefaults = nil
    suiteName = nil
    super.tearDown()
  }

  func testCurrentLanguageTagReadsHostAppleLanguages() {
    userDefaults.set(["zh_CN", "en"], forKey: "AppleLanguages")
    let localeManager = AirwallexLocaleManager(
      userDefaults: userDefaults,
      bundleLocalizer: bundleLocalizer
    )

    XCTAssertEqual(localeManager.currentLanguageTag, "zh-Hans")
  }

  func testApplyConfiguredLocaleSetsSessionLangFromHostLanguage() {
    userDefaults.set(["zh-Hans", "en"], forKey: "AppleLanguages")
    let localeManager = AirwallexLocaleManager(
      userDefaults: userDefaults,
      bundleLocalizer: bundleLocalizer
    )
    localeManager.applyLocale()
    let sdk = AirwallexSdk(localeManager: localeManager)
    let session = AWXSession()

    sdk.applyConfiguredLocale(to: session)

    XCTAssertEqual(session.lang, "zh-Hans")
  }

  func testApplyLocaleOverridesPaymentSheetBundleStrings() throws {
    userDefaults.set(["zh-Hans", "en"], forKey: "AppleLanguages")
    let localeManager = AirwallexLocaleManager(
      userDefaults: userDefaults,
      bundleLocalizer: bundleLocalizer
    )

    localeManager.applyLocale()
    let paymentSheetBundle = try XCTUnwrap(
      bundleLocalizer.resourceBundle(named: .paymentSheet)
    )

    XCTAssertEqual(
      paymentSheetBundle.localizedString(forKey: "Pay", value: nil, table: nil),
      "支付"
    )
  }

  func testApplyLocaleCanSwitchBackToEnglishBundleStrings() throws {
    let localeManager = AirwallexLocaleManager(
      userDefaults: userDefaults,
      bundleLocalizer: bundleLocalizer
    )

    userDefaults.set(["zh-Hans", "en"], forKey: "AppleLanguages")
    localeManager.applyLocale()
    userDefaults.set(["en"], forKey: "AppleLanguages")
    localeManager.applyLocale()
    let paymentSheetBundle = try XCTUnwrap(
      bundleLocalizer.resourceBundle(named: .paymentSheet)
    )

    XCTAssertEqual(
      paymentSheetBundle.localizedString(forKey: "Pay", value: nil, table: nil),
      "Pay"
    )
  }
}
