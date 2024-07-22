Pod::Spec.new do |s|

s.name             = "MidtransCoreKit"
s.version          = "1.27.0"
s.summary          = "Veritrans mobile SDK beta version"
s.homepage         = "https://veritrans.co.id/"
s.license          = 'MIT'
s.author           = { "veritrans" => "dev@veritrans.co.id" }
s.source           = { :git => 'https://github.com/veritrans/Veritrans-ios-sdk.git', :tag => s.version}
s.platform     = :ios, '9.0'
s.resource_bundles = {'MidtransCoreKit' => ['MidtransCoreKit/PrivacyInfo.xcprivacy']}
s.requires_arc = true
s.source_files = 'MidtransCoreKit/MidtransCoreKit/**/*.{h,m}'
s.frameworks    = 'UIKit', 'Foundation'
s.static_framework = true
end
