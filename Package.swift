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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.27.0/MidtransCoreKit.xcframework-1.27.0.zip", checksum: "ccd97fabfc0c899eceab968d79589acd9ed2e7791f32523a550fc7abefdbc54a"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.27.0/MidtransKit.xcframework-1.27.0.zip", checksum: "1ba733a622505bee15d1ca52e26bf4839ffbf2108bb63a4091607f74332ba2c8")
    ]
)
