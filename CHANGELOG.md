## 0.1.13

# [0.2.0](https://github.com/airwallex/airwallex-payment-flutter/compare/0.1.12...0.2.0) (2026-04-24)


### Features

* add preview environment support ([a063519](https://github.com/airwallex/airwallex-payment-flutter/commit/a06351957b5cb1c9ce23ad3e33fc60932983c1ce))





## 0.1.12

  Bug Fixes                                                                                                                                                                                                                                                                                                                                                           - iOS: Fix UIScene lifecycle support — use scene-based window lookup in getViewController() to support apps using UIScene lifecycle, where the app delegate's window is nil       (#49, fixes #48)                                                                                                                                                                                                                                                                                                                                                    Dependencies        - Android: Update Airwallex Android SDK to 6.5.0 (#47)                                                                                                                            - iOS: Update Airwallex iOS SDK to 6.4.0 (#46)                                                                                                                                                                                     Build & Tooling                                                                                                                                                                                                                                                                                                                                                     - Update Kotlin versions (plugin: 1.8.22 → 1.9.25, example: 1.8.22 → 2.1.0)                                                                                                       - Bump minimum Flutter to 3.38.1 for UIScene lifecycle support   - Update compileSdkVersion to match native SDK requirement                                                                                                                        - Adopt UIScene lifecycle in example app                                                                                                                                          - CI: require iOS and Android builds to pass before publishing  

## 0.1.11

## [0.1.11](https://github.com/airwallex/airwallex-payment-flutter/compare/0.1.10...0.1.11) (2026-03-17)


### Bug Fixes

* implicit return compile error ([0fb90f7](https://github.com/airwallex/airwallex-payment-flutter/commit/0fb90f7f252a362b5e533f58197df2287b9b5625))





## 0.1.10

# [0.2.0](https://github.com/airwallex/airwallex-payment-flutter/compare/0.1.9...0.2.0) (2026-03-16)


### Features

* support recurring payment for Google Pay on Android ([5b827b4](https://github.com/airwallex/airwallex-payment-flutter/commit/5b827b40d1d9fe524113fb816a2f7a2b0b67e975))





## 0.1.9

## [0.1.9](https://github.com/airwallex/airwallex-payment-flutter/compare/0.1.8...0.1.9) (2026-01-28)


### Bug Fixes

* add missing result callbacks for iOS initialize and setTintColor ([18b56af](https://github.com/airwallex/airwallex-payment-flutter/commit/18b56af5dad49e696b7c0c65805c9e4faed0afcf))
* handle invalid environment with default fallback on iOS ([25b4d19](https://github.com/airwallex/airwallex-payment-flutter/commit/25b4d19d088ee1c1251c52d3ea603527648c85a9))





## 0.1.8

## [0.1.8](https://github.com/airwallex/airwallex-payment-flutter/compare/0.1.7...0.1.8) (2025-12-30)


### Bug Fixes

* country code for sample app ([9864567](https://github.com/airwallex/airwallex-payment-flutter/commit/986456706b8b749fb8cf071acfd76d3419cbdefe))


### Reverts

* Revert ci: fix multiline release note ([bfe4ed1](https://github.com/airwallex/airwallex-payment-flutter/commit/bfe4ed1e0e92803496d0f03b4f31159fd2b46868))





## 0.1.7

Update to iOS 6.3.0, Android 6.3.1

## 0.1.6

Update to iOS 6.2.1, Android 6.2.7

## 0.1.5

Update to iOS 6.1.9, Android 6.2.4

## 0.1.4

Update android dependency to 6.2.2

## 0.1.3

1. Update iOS dependency to 6.1.8
2. Update `airwallex_payment_flutter.podspec`, explicitly set `s.static_framework = true`

## 0.1.0

* Update details...

## 0.0.2

* Support more payment APIs.
* Support payment APIs for the iOS platform.

## 0.0.1

* Initialize the payment project.
