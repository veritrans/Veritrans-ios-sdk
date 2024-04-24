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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.24.2/MidtransCoreKit.xcframework-1.24.2.zip", checksum: "8dc670a54f31a1d262e3834ca493829ee0418f0d2d0643c87fbff347dd5089cc"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.24.2/MidtransKit.xcframework-1.24.2.zip", checksum: "49a58da8ca5a80692a00e220500cc476ff30f2e88211c6137e709b44d2cc2857")
    ]
)
