Pod::Spec.new do |s|

s.name          = 'MidtransKit'
s.version       = '0.0.1'
s.homepage      = 'http://veritrans.co.id'
s.summary       = 'my all summary'
s.description   = 'my all description'
s.author        = 'Nanang Rafsanjani'
s.platform      = :ios, '7.0'
s.source       = { :http => "https://www.dropbox.com/s/pa9zgi8cmx08ld5/MidtransKit.zip" }
s.ios.vendored_frameworks = 'MidtransKit.framework'
s.requires_arc  = true
s.dependency 'MidtransCoreKit'

end