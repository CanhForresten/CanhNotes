#if canImport(SwiftUI) && canImport(PencilKit)
import SwiftUI
import PencilKit

public struct PencilCanvasView: UIViewRepresentable {
    @ObservedObject var viewModel: CanhNotesViewModel

    public init(viewModel: CanhNotesViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = viewModel.currentCanvasTool()
        canvasView.backgroundColor = .systemBackground
        canvasView.drawing = viewModel.makeDrawingForCanvas()
        return canvasView
    }

    public func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = viewModel.currentCanvasTool()
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    public final class Coordinator: NSObject, PKCanvasViewDelegate {
        private let viewModel: CanhNotesViewModel

        init(viewModel: CanhNotesViewModel) {
            self.viewModel = viewModel
        }

        public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let didRestoreInkTool = viewModel.handleCanvasDrawingDidChange(
                canvasView.drawing,
                gestureState: canvasView.drawingGestureRecognizer.state
            )

            if didRestoreInkTool {
                canvasView.tool = viewModel.currentCanvasTool()
            }
        }
    }
}
#endif
