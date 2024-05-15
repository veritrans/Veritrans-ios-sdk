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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.25.0/MidtransCoreKit.xcframework-1.25.0.zip", checksum: "6b421fd722843f03361f5bef339e5305b9c3b181e184d4318aeaa1fbec9df75e"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.25.0/MidtransKit.xcframework-1.25.0.zip", checksum: "9cb2368c25a5d01e8cce7c3cf79a763d1d030fa037a162e03d39b9538e640732")
    ]
)
