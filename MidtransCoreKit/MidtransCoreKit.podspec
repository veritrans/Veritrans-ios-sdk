Pod::Spec.new do |s|

s.name          = 'MidtransCoreKit'
s.version       = '0.0.1'
s.homepage      = '****'
s.summary       = 'My Common lib'
s.description   = 'Library with common code'
s.author        = 'Darth Vader'
s.platform      = :ios, '7.0'
s.source       = { :http => "https://www.dropbox.com/s/smbwttug76qkjnt/MidtransCoreKit.zip" }
s.ios.vendored_frameworks = 'MidtransCoreKit.framework'
s.requires_arc  = true

end