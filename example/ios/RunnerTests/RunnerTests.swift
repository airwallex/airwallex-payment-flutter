import Airwallex
import XCTest

@testable import airwallex_payment_flutter

final class RunnerTests: XCTestCase {
  private var suiteName: String!
  private var userDefaults: UserDefaults!

  override func setUp() {
    super.setUp()
    suiteName = "RunnerTests.\(UUID().uuidString)"
    userDefaults = UserDefaults(suiteName: suiteName)
    userDefaults.removePersistentDomain(forName: suiteName)
  }

  override func tearDown() {
    if let suiteName {
      userDefaults.removePersistentDomain(forName: suiteName)
    }
    userDefaults = nil
    suiteName = nil
    super.tearDown()
  }

  func testSetLocaleNormalizesChineseLanguageTag() {
    let localeManager = AirwallexLocaleManager(userDefaults: userDefaults)

    localeManager.setLocale("zh_CN")

    XCTAssertEqual(localeManager.currentLanguageTag, "zh-Hans")
  }

  func testApplyConfiguredLocaleSetsSessionLang() {
    let localeManager = AirwallexLocaleManager(userDefaults: userDefaults)
    localeManager.setLocale("zh-Hans")
    let sdk = AirwallexSdk(localeManager: localeManager)
    let session = AWXSession()

    sdk.applyConfiguredLocale(to: session)

    XCTAssertEqual(session.lang, "zh-Hans")
  }

  func testApplyConfiguredLocaleKeepsDefaultLanguageWhenUnset() {
    let localeManager = AirwallexLocaleManager(userDefaults: userDefaults)
    let sdk = AirwallexSdk(localeManager: localeManager)
    let session = AWXSession()
    let defaultLanguage = session.lang

    sdk.applyConfiguredLocale(to: session)

    XCTAssertEqual(session.lang, defaultLanguage)
  }
}
