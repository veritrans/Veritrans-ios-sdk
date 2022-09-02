// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Midtrans",
    defaultLocalization: "en",
        platforms: [
            .iOS(.v12)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MidtransCoreKit",
            targets: ["MidtransCoreKit"]),
        .library(
            name: "MidtransKit",
            targets: ["MidtransKit", "MidtransCoreKit"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(name: "MidtransCoreKit", url: "https://github.com/uziwuzzy/MidtransSPM/releases/download/1.22.0/MidtransCoreKit.xcframework.zip", checksum: "11552dbb54f4739e98eab279e013bebfcb71e67207362cab6df8a269549b6e12"),
        .binaryTarget(name: "MidtransKit", url: "https://github.com/uziwuzzy/MidtransSPM/releases/download/1.22.0/MidtransKit.xcframework.zip", checksum: "be747f68cfd0147a9b69c42c8b756896ce44a0c416faba825a2c65b46328e246")
    ]
)
