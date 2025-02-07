// swift-tools-version: 5.10

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftMacros",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "SwiftMacros",
            targets: ["SwiftMacros"]
        ),
        .executable(
            name: "Client",
            targets: ["Client"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "600.0.0-latest"
        )
    ],
    targets: [
        .macro(
            name: "SwiftMacrosLib",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            path: "Sources/MacrosLib"
        ),
        .target(
            name: "SwiftMacros",
            dependencies: ["SwiftMacrosLib"],
            path: "Sources/Macros"
        ),
        .executableTarget(
            name: "Client",
            dependencies: ["SwiftMacros"]
        ),
        .testTarget(
            name: "Tests",
            dependencies: [
                "SwiftMacrosLib",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                )
            ],
            path: "UnitTests"
        )
    ]
)
