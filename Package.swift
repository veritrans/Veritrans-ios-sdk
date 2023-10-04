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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.24.1/MidtransCoreKit.xcframework-1.24.1.zip", checksum: "621833ebfd43c02d01f87da2c53455b1da8ae794769136a8933f31a45f8cce82"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.24.1/MidtransKit.xcframework-1.24.1.zip", checksum: "c50ac1df51032255a8a904fb8abfd9ab0f875447506ab88efa8f8549408841d9")
    ]
)
