// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DropdownGridMenu",
    products: [
        .library(
            name: "DropdownGridMenu",
            targets: ["DropdownGridMenu"]),
    ],
    targets: [
        .target(
            name: "DropdownGridMenu",
            dependencies: [],
            path: "./DropdownGridMenu")
    ]
)
