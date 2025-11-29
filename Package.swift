// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "FNUQCore",
    platforms: [
        .macOS(.v11)  // Only support for macOS 11+
    ],
    products: [
        
        .library(
            name: "FNUQCore",
            targets: ["FNUQCore"]
        )
    ],
    dependencies: [
        // None
    ],
    targets: [
        
        .target(
            name: "FNUQCore",
            dependencies: [],
            path: "Sources",
            exclude: ["main.swift"], 
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        ),
       
        .testTarget(
            name: "FNUQCoreTests",
            dependencies: ["FNUQCore"],
            path: "Tests"
        )
    ]
)
