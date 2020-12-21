import ARKit_CoreLocation
import SwiftUI

// MARK: - ARView
struct ARView: UIViewRepresentable {
    
    // MARK: - property
    
    private let sceneLocationView = SceneLocationView()
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<ARView>) -> SceneLocationView {
        sceneLocationView.run()
        return sceneLocationView
    }
    
    func updateUIView(_ uiView: SceneLocationView, context: UIViewRepresentableContext<ARView>) {
    }
    
    static func dismantleUIView(_ uiView: ARView.UIViewType, coordinator: ARView.Coordinator) {
        uiView.pause()
    }
    
    func makeCoordinator() -> ARView.Coordinator {
        Coordinator()
    }
    
    // MARK: - Coordinator
    
    final class Coordinator {
    }
}

// MARK: - ARView_Previews
struct ARView_Previews: PreviewProvider {
    
    static var previews: some View {
        ARView()
    }
}