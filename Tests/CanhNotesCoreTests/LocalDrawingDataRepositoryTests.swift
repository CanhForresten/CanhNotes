import XCTest
@testable import CanhNotesCore

final class LocalDrawingDataRepositoryTests: XCTestCase {
    func testSaveThenLoadRoundTrip() throws {
        let fileManager = FileManager.default
        let root = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? fileManager.removeItem(at: root) }
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

    func testSaveAndLoadByFileNameUsesDocumentsDirectory() throws {
        let repository = LocalDrawingDataRepository(fileManager: .default)
        let fileName = "test-\(UUID().uuidString).bin"
        let data = Data([0x01, 0x02, 0x03])
        defer { try? repository.delete(fileName: fileName) }

        _ = try repository.save(data: data, fileName: fileName)
        let loaded = try repository.load(fileName: fileName)

        XCTAssertEqual(loaded, data)
    }

    func testDeleteRemovesFile() throws {
        let repository = LocalDrawingDataRepository(fileManager: .default)
        let fileName = "delete-\(UUID().uuidString).bin"
        _ = try repository.save(data: Data([0x05]), fileName: fileName)

        try repository.delete(fileName: fileName)

        XCTAssertThrowsError(try repository.load(fileName: fileName)) { error in
            XCTAssertEqual(error as? DrawingDataRepositoryError, .fileNotFound)
        }
    }
}
