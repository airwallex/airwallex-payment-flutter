// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "airwallex_payment_flutter",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "airwallex-payment-flutter", targets: ["airwallex_payment_flutter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/airwallex/airwallex-payment-ios.git", exact: "6.4.2"),
    ],
    targets: [
        .target(
            name: "airwallex_payment_flutter",
            dependencies: [
                .product(name: "Airwallex", package: "airwallex-payment-ios"),
                .product(name: "AirwallexWeChatPay", package: "airwallex-payment-ios"),
            ],
            resources: [
                .process("Resources/PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
