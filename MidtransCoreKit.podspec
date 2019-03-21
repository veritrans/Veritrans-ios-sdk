Pod::Spec.new do |s|

s.name             = "MidtransCoreKit"
s.version          = "2.0.0"
s.summary          = "Veritrans mobile SDK refined version"
s.homepage         = "https://veritrans.co.id/"
s.license          = 'MIT'
s.author           = { "veritrans" => "dev@veritrans.co.id" }
s.source           = { :git => 'https://github.com/veritrans/Veritrans-ios-sdk.git', :tag => s.version}
s.platform         = :ios, '9.0'
s.requires_arc     = true
s.source_files     = 'Core/**/*.{h,m}'
s.frameworks       = 'UIKit', 'Foundation'
s.static_framework = true

end
