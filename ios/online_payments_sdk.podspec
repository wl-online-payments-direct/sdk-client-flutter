#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint online_payments_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'online_payments_sdk'
  s.version          = '1.2.0'
  s.summary          = 'Online Payments Flutter SDK iOS Plugin'
  s.description      = <<-DESC
        iOS Plugin for the Online Payments Flutter SDK.
                       DESC
  s.homepage         = 'https://github.com/wl-online-payments-direct/sdk-client-flutter'
  s.license          = { :type => "MIT", :file => "../LICENSE" }
  s.author           = "Worldline"
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Alamofire'
  s.dependency 'CryptoSwift'
  s.vendored_framework = 'Frameworks/OnlinePaymentsKit.xcframework'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end