// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CanhNotes",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "CanhNotesCore", targets: ["CanhNotesCore"]),
        .library(name: "CanhNotesUI", targets: ["CanhNotesUI"])
    ],
    targets: [
        .target(
            name: "CanhNotesCore",
            path: "Sources/CanhNotesCore"
        ),
        .target(
            name: "CanhNotesUI",
            dependencies: ["CanhNotesCore"],
            path: "Sources/CanhNotesUI"
        ),
        .testTarget(
            name: "CanhNotesCoreTests",
            dependencies: ["CanhNotesCore"],
            path: "Tests/CanhNotesCoreTests"
        )
    ]
)
