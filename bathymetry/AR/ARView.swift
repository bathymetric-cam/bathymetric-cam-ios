import ARKit_CoreLocation
import CoreLocation
import SceneKit
import SwiftUI

// MARK: - ARView
struct ARView: UIViewRepresentable {
    
    // MARK: property
    
    @Binding var bathymetryTiles: [BathymetryTile]
    var altitude: Double = 0
    
    // MARK: UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<ARView>) -> UIARView {
        let sceneLocationView = UIARView()
        sceneLocationView.locationEstimateDelegate = context.coordinator
        sceneLocationView.run()
        return sceneLocationView
    }
    
    func updateUIView(_ uiView: UIARView, context: UIViewRepresentableContext<ARView>) {
        uiView.updateLocationNodes(bathymetryTiles: bathymetryTiles, altitude: altitude)
    }
    
    static func dismantleUIView(_ uiView: ARView.UIViewType, coordinator: ARView.Coordinator) {
        uiView.pause()
    }
    
    func makeCoordinator() -> ARView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: Coordinator
    
    final class Coordinator: NSObject, SceneLocationViewEstimateDelegate {
        var control: ARView
        
        init(_ control: ARView) {
            self.control = control
        }
        
        // MARK: SceneLocationViewEstimateDelegate
        
        func didAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
            if abs(control.altitude - location.altitude) < 1 {
                return
            }
            control.altitude = location.altitude
            guard let uiArView = sceneLocationView as? UIARView else {
                return
            }
            uiArView.updateLocationNodes(bathymetryTiles: control.bathymetryTiles, altitude: control.altitude - 1)
        }
        
        func didRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        }
    }
}

// MARK: - UIARView
final class UIARView: SceneLocationView {

    // MARK: public api
    
    /// Updates location nodes
    /// - Parameters:
    ///   - bathymetryTiles: Array of BathymetryTile
    ///   - altitude: altitude of node
    func updateLocationNodes(bathymetryTiles: [BathymetryTile], altitude: Double) {
        locationNodes.forEach {
            removeLocationNode(locationNode: $0)
        }
        bathymetryTiles.forEach {
            addLocationNodeWithConfirmedLocation(locationNode: ARBathymetryNode(bathymetryTile: $0, altitude: altitude))
        }
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
