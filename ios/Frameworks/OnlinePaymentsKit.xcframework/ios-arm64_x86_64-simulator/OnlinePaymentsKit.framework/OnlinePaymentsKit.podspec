Pod::Spec.new do |s|

  s.name          = "OnlinePaymentsKit"
  s.version       = "4.0.1"
  s.summary       = "Online payments Swift SDK"
  s.description   = <<-DESC
                    This native iOS SDK facilitates handling payments in your apps
                    using the Online Payments platform.
                    DESC

  s.homepage      = "https://github.com/wl-online-payments-direct/sdk-client-swift"
  s.license       = { :type => "MIT", :file => "LICENSE.txt" }
  s.author        = "Worldline"
  s.platform      = :ios, "15.6"
  s.source        = { :git => "https://github.com/wl-online-payments-direct/sdk-client-swift.git", :tag => s.version }
  s.source_files  = "OnlinePaymentsKit/**/*.{swift,h}"
  s.resource      = "OnlinePaymentsKit/Resources/OnlinePaymentsKit.bundle"
  s.swift_version = "5"
  
  s.dependency 'Alamofire', '~> 5.6'
  s.dependency 'CryptoSwift', '~> 1.5'
end
