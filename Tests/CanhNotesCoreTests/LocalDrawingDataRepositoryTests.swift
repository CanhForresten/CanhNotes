import XCTest
@testable import CanhNotesCore

final class LocalDrawingDataRepositoryTests: XCTestCase {
    func testSaveThenLoadRoundTrip() throws {
        let fileManager = FileManager.default
        let root = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: root, withIntermediateDirectories: true)

        let repository = LocalDrawingDataRepository(fileManager: fileManager)
        let data = Data([0xCA, 0x0A, 0x00])
        let fileURL = root.appendingPathComponent("page.bin")

        _ = try repository.save(data: data, at: fileURL)
        let loaded = try repository.load(from: fileURL)

        XCTAssertEqual(loaded, data)
    }

    func testLoadMissingFileThrowsFileNotFound() {
        let repository = LocalDrawingDataRepository(fileManager: .default)
        let missing = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

        XCTAssertThrowsError(try repository.load(from: missing)) { error in
            XCTAssertEqual(error as? DrawingDataRepositoryError, .fileNotFound)
        }
    }
}
