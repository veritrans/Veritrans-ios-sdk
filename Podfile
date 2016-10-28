platform :ios, '7.0'

workspace 'MidtransSDK.xcworkspace'

project 'Demo/VTDirectDemo.xcodeproj'
project 'MidtransKit/MidtransKit.xcodeproj'
project 'MidtransCoreKit/MidtransCoreKit.xcodeproj'

target 'VTDirectDemo' do
    project 'Demo/VTDirectDemo.xcodeproj'
    pod 'SDWebImage', '~>3.7'
    pod 'iOS-Color-Picker'
    pod 'MBProgressHUD'
    pod 'CardIO', '~> 5.4'
end

target 'MidtransKit' do
    project 'MidtransKit/MidtransKit.xcodeproj'
end

target 'MidtransResources' do
    project 'MidtransKit/MidtransKit.xcodeproj'
end

target 'MidtransCoreKit' do
    project 'MidtransCoreKit/MidtransCoreKit.xcodeproj'
end
