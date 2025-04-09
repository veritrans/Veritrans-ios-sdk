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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.28.0/MidtransCoreKit.xcframework-1.28.0.zip", checksum: "7834333a072988fd87acdee448932f906321e3ccc842e707b17d46f19c72a3eb"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.28.0/MidtransKit.xcframework-1.28.0.zip", checksum: "f8cfe766582842df6ab53ef853616f0ba6db2deddf3584990a017968907df31f")
    ]
)
