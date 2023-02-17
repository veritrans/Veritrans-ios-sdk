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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.24.0/MidtransCoreKit.xcframework-1.24.0.zip", checksum: "b57566f2d3d4af4f5306667b10491e92ad833548b15a1abc4a36b7a29bc5792b"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.24.0/MidtransKit.xcframework-1.24.0.zip", checksum: "6c08eeb3b6e06acd2befb2ed1d934c5534a4494a67cf38875f6f7ecc2ccf9b6a")
    ]
)
