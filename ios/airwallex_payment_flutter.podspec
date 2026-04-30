#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint airwallex_payment_flutter.podspec` to validate before publishing.
#

airwallex_version = '~> 6.4.2'

Pod::Spec.new do |s|
  s.name             = 'airwallex_payment_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Airwallex Payment Flutter plugin project.'
  s.description      = <<-DESC
Airwallex Payment Flutter plugin project.
                       DESC
  s.homepage         = 'https://www.airwallex.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Airwallex PA Mobile' => 'pa_mobile_sdk@airwallex.com' }
  s.source           = { :path => '.' }
  s.source_files = 'airwallex_payment_flutter/Sources/airwallex_payment_flutter/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'Airwallex', airwallex_version
  s.platform = :ios, '13.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.10'
end
