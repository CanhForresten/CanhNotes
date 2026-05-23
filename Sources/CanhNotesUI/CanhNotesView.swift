#if canImport(SwiftUI) && canImport(PencilKit)
import SwiftUI

public struct CanhNotesView: View {
    @StateObject private var viewModel = CanhNotesViewModel()

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            PencilCanvasView(viewModel: viewModel)

            HStack(spacing: 12) {
                Button("Pen") {
                    viewModel.selectTool(.pen)
                }
                .buttonStyle(.borderedProminent)

                Button("Highlighter") {
                    viewModel.selectTool(.highlighter)
                }
                .buttonStyle(.bordered)

                Button("Eraser") {
                    viewModel.selectTool(.vectorEraser)
                }
                .buttonStyle(.bordered)

                Button("Save") {
                    viewModel.save(fileName: viewModel.currentFileName)
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(.ultraThinMaterial)

            if let lastErrorMessage = viewModel.lastErrorMessage {
                Text("Save failed: \(lastErrorMessage)")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }
}
#endif
