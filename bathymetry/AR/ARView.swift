import ARKit_CoreLocation
import Combine
import CoreLocation
import SceneKit
import SwiftUI

// MARK: - ARView
struct ARView: UIViewRepresentable {

    // MARK: property
    
    @Binding var bathymetryTiles: [BathymetryTile]
    @Binding var bathymetryColors: BathymetryColors
    
    // MARK: UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<ARView>) -> UIARView {
        let sceneLocationView = UIARView(trackingType: .orientationTracking)
        sceneLocationView.locationEstimateDelegate = context.coordinator
        sceneLocationView.run()
        return sceneLocationView
    }
    
    func updateUIView(_ uiView: UIARView, context: UIViewRepresentableContext<ARView>) {
        uiView.locationNodes.forEach {
            uiView.removeLocationNode(locationNode: $0)
        }
        let altitude = uiView.sceneLocationManager.currentLocation?.altitude ?? 0
        bathymetryTiles.forEach {
            uiView.addLocationNodeWithConfirmedLocation(
                locationNode: ARBathymetryNode(
                    bathymetryTile: $0,
                    bathymetryColors: bathymetryColors,
                    altitude: altitude
                )
            )
        }
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
            let altitude = sceneLocationView.sceneLocationManager.currentLocation?.altitude ?? 0
            sceneLocationView.locationNodes.forEach {
                $0.location = CLLocation(coordinate: $0.location.coordinate, altitude: altitude)
            }
        }
        
        func didRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        }
    }
}

// MARK: - UIARView
final class UIARView: SceneLocationView {
    
    // MARK: initialization
    
    // swiftlint:disable discouraged_optional_collection
    override private init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveNotification(notification:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveNotification(notification:)),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
    // swiftlint:enable discouraged_optional_collection
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: destruction
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: notification
    
    @objc
    private func didReceiveNotification(notification: Notification) {
        switch notification.name {
        case UIApplication.didBecomeActiveNotification:
            DispatchQueue.main.async { [weak self] in
                self?.run()
            }
        case UIApplication.willResignActiveNotification:
            DispatchQueue.main.async { [weak self] in
                self?.pause()
            }
        default:
            break
        }
    }
}

// MARK: - ARView_Previews
struct ARView_Previews: PreviewProvider {
    
    static var previews: some View {
        ARView(
            bathymetryTiles: Binding<[BathymetryTile]>(
                get: { [] },
                set: { _ in }
            ),
            bathymetryColors: Binding<BathymetryColors>(
                get: { .defaultColors },
                set: { _ in }
            )
        )
    }
}
