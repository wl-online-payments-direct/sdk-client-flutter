// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "online_payments_sdk",
    platforms: [
        .iOS("15.6")
    ],
    products: [
        .library(name: "online-payments-sdk", targets: ["online_payments_sdk"])
    ],
    targets: [
        .target(
            name: "online_payments_sdk",
            dependencies: [
                "OnlinePaymentsKit"
            ]
        ),
        .binaryTarget(
            name: "OnlinePaymentsKit",
            path: "Frameworks/OnlinePaymentsKit.xcframework"
        )
    ]
)