// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaskerServer",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        .package(url: "https://github.com/AliSoftware/Dip", from: "6.0.0"),
        .package(url: "https://github.com/mczachurski/Dobby", from: "0.7.1"),
        .package(url: "https://github.com/IBM-Swift/Configuration.git", from: "3.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "TaskerServerApp", dependencies: ["TaskerServerLib", "PerfectHTTPServer", "Dip", "Configuration"]),
        .target(name: "TaskerServerLib", dependencies: ["PerfectHTTPServer", "Dip"]),
        .testTarget(name: "TaskerServerLibTests", dependencies: ["TaskerServerLib", "PerfectHTTPServer", "Dip", "Configuration", "Dobby"])
    ]
)
