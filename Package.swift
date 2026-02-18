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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.29.0/MidtransCoreKit.xcframework-1.29.0.zip", checksum: "a78ae72955cbb4620400714018de9104eabbabca26f5a40eb0fcdb0a20ecdcad"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.29.0/MidtransKit.xcframework-1.29.0.zip", checksum: "f90213700cdea173b08a0605468c4fa4eeb191627ac8220238056a04bc8a86fe")
    ]
)
