#!/bin/sh
cd DemoTest
pod install
rm -rf "~/Library/Caches/CocoaPods"
rm -rf "Pods/"
pod update
xcodebuild -workspace VTDirectDemo.xcworkspace -scheme MidtransSDKDemo -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.0' ONLY_ACTIVE_ARCH=NO clean test | xcpretty
