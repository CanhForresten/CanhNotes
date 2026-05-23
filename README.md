# CanhNotes

CanhNotes er en dokumentbaseret note-app struktur lavet med SwiftUI + PencilKit.

## Arkitektur

- **MVVM**: `CanhNotesView` + `CanhNotesViewModel`
- **Repository-lag**: `LocalDrawingDataRepository` gemmer/indlæser binære drawing-bytes lokalt i dokumentmappen
- **Canvas wrapper**: `PencilCanvasView` bruger `UIViewRepresentable` + `Coordinator` (`PKCanvasViewDelegate`)
- **Tilpasset toolbar**: egne SwiftUI-knapper til pen, highlighter, viskelæder og save

## Vigtig PencilKit-adfærd

I `canvasViewDrawingDidChange` overvåges stroke-ændringer. Hvis aktivt værktøj er **vector eraser**, og brugeren afslutter strøget (`drawingGestureRecognizer.state == .ended`), skiftes værktøjet automatisk tilbage til den sidst gemte pen/highlighter-konfiguration.