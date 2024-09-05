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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.27.1/MidtransCoreKit.xcframework-1.27.1.zip", checksum: "59558c074aaaf9e2b53c7f30bcaf111467acaef41e3f33ced6fa3abb4bfbe642"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.27.1/MidtransKit.xcframework-1.27.1.zip", checksum: "e111d8d67a346abd2cfc58185407068a2d2caf7bafca818df5342b285c3897fd")
    ]
)
