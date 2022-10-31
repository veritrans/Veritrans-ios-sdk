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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.23.0/MidtransCoreKit.xcframework-1.23.0.zip", checksum: "b68f1a3c4317d4b871388a0f68561d81a39e641a4ccbd07972acd1b2c4e31f4e"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.23.0/MidtransKit.xcframework-1.23.0.zip", checksum: "dfbaad78435e41643cec1aa6775277e57baa5149a72e40075921a9e3e9fbb56a")
    ]
)
