import ARKit_CoreLocation
import CoreLocation
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
}

// MARK: - ARView_Previews
struct ARView_Previews: PreviewProvider {
    
    static var previews: some View {
        ARView()
    }
}
