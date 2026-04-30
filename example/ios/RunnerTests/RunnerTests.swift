import Airwallex
import Flutter
import UIKit
import XCTest


@testable import airwallex_payment_flutter

class RunnerTests: XCTestCase {

  // Verifies the brand strings sent from the Dart `CardBrand` enum map to the
  // exact `AWXCardBrand` constants defined in the iOS SDK. If the SDK ever
  // renames a brand string, this test fails immediately rather than silently
  // dropping the brand at runtime.
  func testSupportedBrandStringMapping() {
    XCTAssertEqual(AWXCardBrand(rawValue: "visa"), AWXCardBrand.visa)
    XCTAssertEqual(AWXCardBrand(rawValue: "mastercard"), AWXCardBrand.mastercard)
    XCTAssertEqual(AWXCardBrand(rawValue: "amex"), AWXCardBrand.amex)
    XCTAssertEqual(AWXCardBrand(rawValue: "discover"), AWXCardBrand.discover)
    XCTAssertEqual(AWXCardBrand(rawValue: "jcb"), AWXCardBrand.JCB)
    XCTAssertEqual(AWXCardBrand(rawValue: "diners"), AWXCardBrand.dinersClub)
    XCTAssertEqual(AWXCardBrand(rawValue: "unionpay"), AWXCardBrand.unionPay)
  }

  func testSupportedBrandStringMapping_allMappedBrandsAreInAllAvailable() {
    let mapped: [AWXCardBrand] = [
      "visa", "mastercard", "amex", "discover", "jcb", "diners", "unionpay"
    ].map { AWXCardBrand(rawValue: $0) }
    for brand in mapped {
      XCTAssertTrue(AWXCardBrand.allAvailable.contains(brand), "\(brand.rawValue) missing from AWXCardBrand.allAvailable")
    }
  }

  // Mirrors the filter in AirwallexSdk.presentCardPaymentFlow: unknown brand
  // strings are silently dropped to match Android behavior.
  func testSupportedBrandLookup_filtersUnknownBrands() {
    let knownBrands = AWXCardBrand.allAvailable
    let input = ["visa", "bogus", "mastercard"]
    let filtered = input.compactMap { value in
      knownBrands.first { $0.rawValue == value }
    }
    XCTAssertEqual(filtered, [AWXCardBrand.visa, AWXCardBrand.mastercard])
  }
}
