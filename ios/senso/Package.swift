// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "senso",
  platforms: [
    .iOS("12.0")
  ],
  products: [
    .library(name: "senso", targets: ["senso"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "senso",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ]
    )
  ]
)
