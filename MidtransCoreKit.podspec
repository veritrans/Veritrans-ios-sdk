Pod::Spec.new do |s|

s.name             = "MidtransCoreKit"
s.version          = "1.24.1"
s.summary          = "Veritrans mobile SDK beta version"
s.homepage         = "https://veritrans.co.id/"
s.license          = 'MIT'
s.author           = { "veritrans" => "dev@veritrans.co.id" }
s.source           = { :git => 'https://github.com/veritrans/Veritrans-ios-sdk.git', :tag => s.version}
s.platform     = :ios, '12.0'
s.swift_version    = '5.0'
s.requires_arc = true
s.source_files = 'MidtransCoreKit/MidtransCoreKit/**/*.{h,m}', 'MidtransCoreKit/MidtransCoreKit/**/*.swift'
s.frameworks    = 'UIKit', 'Foundation'
s.dependency 'ClickstreamLib', '2.0.21'
s.static_framework = true
end
