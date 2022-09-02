// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Midtrans",
    defaultLocalization: "en",
        platforms: [
            .iOS(.v9)
        ],
    products: [
        .library(
            name: "MidtransCoreKit",
            targets: ["MidtransCoreKit"]),
        .library(
            name: "MidtransKit",
            targets: ["MidtransKit", "MidtransCoreKit"])
    ],
    dependencies: [],
    targets: [
        
        //MARK:For Development
//        .binaryTarget(name: "MidtransCoreKit", path: "MidtransCoreKit/MidtransCoreKit.xcframework"),
//        .binaryTarget(name: "MidtransKit", path: "MidtransKit/MidtransKit.xcframework")
        
//        MARK:For Production
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/uziwuzzy/Midtrans-xcframework/releases/download/1.23.0/MidtransCoreKit.xcframework-1.23.0.zip", checksum: "131f01b1c3292da27656dcfb176bc52c6f72eceb58cc7cdfbee52edaffb3924b"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/uziwuzzy/Midtrans-xcframework/releases/download/1.23.0/MidtransKit.xcframework-1.23.0.zip", checksum: "1f4e9339da762a47b71ac8dcd6b719ca6076bb5ad529732772786e421ab0b8b3")
    ]
)
