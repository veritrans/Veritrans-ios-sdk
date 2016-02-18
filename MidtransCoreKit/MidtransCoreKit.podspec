Pod::Spec.new do |s|

s.name          = 'MidtransCoreKit'
s.version       = '0.0.1'
s.homepage      = '****'
s.summary       = 'My Common lib'
s.description   = 'Library with common code'
s.author        = 'Darth Vader'
s.platform      = :ios, '7.0'
s.source       = { :git => "https://github.com/jukiginanjar/iossdk-private.git" }
s.ios.vendored_frameworks = 'MidtransCoreKit/MidtransCoreKit.framework'
s.requires_arc  = true

end