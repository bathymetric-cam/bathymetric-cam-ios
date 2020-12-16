import ARKit_CoreLocation
import SwiftUI

// MARK: - ARView
struct ARView: UIViewRepresentable {
    
    // MARK: - property
    
    private let sceneLocationView = SceneLocationView()
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<ARView>) -> SceneLocationView {
        return sceneLocationView
    }
    
    func updateUIView(_ uiView: SceneLocationView, context: UIViewRepresentableContext<ARView>) {
    }
    
    static func dismantleUIView(_ uiView: ARView.UIViewType, coordinator: ARView.Coordinator) {
    }
    
    /*
    func makeCoordinator() -> ARView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: -
    
    final class Coordinator: NSObject {
        var control: ARView
        
        init(_ control: ARView) {
            self.control = control
        }
    }
    */
}

// MARK: - ARView_Previews
struct ARView_Previews: PreviewProvider {
    
    static var previews: some View {
        ARView()
    }
}
