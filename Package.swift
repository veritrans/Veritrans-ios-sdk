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
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.26.0/MidtransCoreKit.xcframework-1.26.0.zip", checksum: "de27851d927c03828186ef90c0fd4e220f65d930b51112b5288f31d49eb53cbb"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/veritrans/Midtrans-xcframework/releases/download/1.26.0/MidtransKit.xcframework-1.26.0.zip", checksum: "a4f27bb353c1745a973238a3b988372476bb3c564dcfcd48b378d450d52e738b")
    ]
)
