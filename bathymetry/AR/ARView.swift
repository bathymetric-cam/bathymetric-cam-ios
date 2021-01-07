import ARKit_CoreLocation
import CoreLocation
import SwiftUI

// MARK: - ARView
struct ARView: UIViewRepresentable {
    
    // MARK: - property
    
    @Binding var bathymetryTiles: [BathymetryTile]
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<ARView>) -> SceneLocationView {
        let sceneLocationView = SceneLocationView()
        sceneLocationView.run()
        return sceneLocationView
    }
    
    func updateUIView(_ uiView: SceneLocationView, context: UIViewRepresentableContext<ARView>) {
        uiView.locationNodes.forEach {
            uiView.removeLocationNode(locationNode: $0)
        }
        bathymetryTiles.forEach {
            uiView.addLocationNodeWithConfirmedLocation(locationNode: ARBathymetryNode(bathymetryTile: $0))
        }
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
        ARView(bathymetryTiles: Binding<[BathymetryTile]>(
            get: { [] },
            set: { _ in }
        ))
    }
}
