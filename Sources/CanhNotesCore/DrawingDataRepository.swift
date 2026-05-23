import Foundation

public enum DrawingDataRepositoryError: Error, Equatable {
    case fileNotFound
    case invalidDocumentsDirectory
}

public protocol DrawingDataRepository {
    func save(data: Data, fileName: String) throws -> URL
    func load(fileName: String) throws -> Data
    func delete(fileName: String) throws
}

public struct LocalDrawingDataRepository: DrawingDataRepository {
    private let fileManager: FileManager

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    public func save(data: Data, fileName: String) throws -> URL {
        let targetURL = try documentsDirectoryURL().appendingPathComponent(fileName)
        return try save(data: data, at: targetURL)
    }

    public func load(fileName: String) throws -> Data {
        let targetURL = try documentsDirectoryURL().appendingPathComponent(fileName)
        return try load(from: targetURL)
    }

    public func delete(fileName: String) throws {
        let targetURL = try documentsDirectoryURL().appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: targetURL.path) else {
            throw DrawingDataRepositoryError.fileNotFound
        }
        try fileManager.removeItem(at: targetURL)
    }

    public func save(data: Data, at destinationURL: URL) throws -> URL {
        let directoryURL = destinationURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: directoryURL.path) {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        try data.write(to: destinationURL, options: .atomic)
        return destinationURL
    }

    public func load(from sourceURL: URL) throws -> Data {
        guard fileManager.fileExists(atPath: sourceURL.path) else {
            throw DrawingDataRepositoryError.fileNotFound
        }
        return try Data(contentsOf: sourceURL)
    }

    public func documentsDirectoryURL() throws -> URL {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DrawingDataRepositoryError.invalidDocumentsDirectory
        }
        return documentsURL
    }
}
