#if canImport(SwiftUI) && canImport(PencilKit)
import Foundation
import SwiftUI
import PencilKit
import CanhNotesCore

@MainActor
public final class CanhNotesViewModel: ObservableObject {
    public enum ToolSelection: Equatable {
        case pen
        case highlighter
        case vectorEraser
        case bitmapEraser
    }

    @Published public var currentDrawingData: Data
    @Published public private(set) var activeTool: ToolSelection

    public var penInk = PKInkingTool(.pen, color: .label, width: 3)
    public var highlighterInk = PKInkingTool(.marker, color: .systemYellow.withAlphaComponent(0.45), width: 10)
    private(set) var previousInkTool: ToolSelection = .pen

    private let repository: DrawingDataRepository

    public init(repository: DrawingDataRepository = LocalDrawingDataRepository()) {
        self.repository = repository
        self.currentDrawingData = PKDrawing().dataRepresentation()
        self.activeTool = .pen
    }

    public func selectTool(_ selection: ToolSelection) {
        if selection == .vectorEraser || selection == .bitmapEraser {
            previousInkTool = (activeTool == .highlighter) ? .highlighter : .pen
        }
        activeTool = selection
    }

    public func currentCanvasTool() -> PKTool {
        switch activeTool {
        case .pen:
            return penInk
        case .highlighter:
            return highlighterInk
        case .vectorEraser:
            return PKEraserTool(.vector)
        case .bitmapEraser:
            return PKEraserTool(.bitmap)
        }
    }

    public func handleCanvasDrawingDidChange(_ drawing: PKDrawing, gestureState: UIGestureRecognizer.State) {
        currentDrawingData = drawing.dataRepresentation()

        guard activeTool == .vectorEraser, gestureState == .ended else {
            return
        }

        activeTool = previousInkTool
    }

    public func save(fileName: String) throws {
        _ = try repository.save(data: currentDrawingData, fileName: fileName)
    }

    public func load(fileName: String) throws {
        currentDrawingData = try repository.load(fileName: fileName)
    }
}
#endif
