import ARKit_CoreLocation
import Combine
import CoreLocation
import SceneKit
import SwiftUI

// MARK: - ARView
struct ARView: UIViewRepresentable {

  // MARK: property
  
  @Binding var isOn: Bool
  @Binding var bathymetryTiles: [BathymetryTile]
  @Binding var bathymetryColors: BathymetryColors

  // MARK: UIViewRepresentable
  
  func makeUIView(context: UIViewRepresentableContext<ARView>) -> UIARView {
    let uiArView = UIARView(trackingType: .orientationTracking)
    uiArView.locationEstimateDelegate = context.coordinator
    uiArView.run()
    return uiArView
  }
  
  func updateUIView(_ uiView: UIARView, context: UIViewRepresentableContext<ARView>) {
    uiView.locationNodes.forEach {
      uiView.removeLocationNode(locationNode: $0)
    }
    if !isOn {
      return
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
  // MARK: property
  
  var cancellables = Set<AnyCancellable>()
  
  // MARK: initialization
  
  // swiftlint:disable discouraged_optional_collection
  override private init(frame: CGRect, options: [String: Any]? = nil) {
    super.init(frame: frame, options: options)
  
    NotificationCenter
      .default
      .publisher(for: UIApplication.didBecomeActiveNotification)
      .sink { [weak self] _ in
        DispatchQueue.main.async { [weak self] in
          self?.run()
        }
      }
      .store(in: &cancellables)
    NotificationCenter
      .default
      .publisher(for: UIApplication.willResignActiveNotification)
      .sink { [weak self] _ in
        DispatchQueue.main.async { [weak self] in
          self?.pause()
        }
      }
      .store(in: &cancellables)
  }
  // swiftlint:enable discouraged_optional_collection
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: destruction
  
  deinit {
    cancellables.forEach { $0.cancel() }
  }
}

// MARK: - ARView_Previews
struct ARView_Previews: PreviewProvider {
  
  static var previews: some View {
    ARView(
      isOn: Binding<Bool>(
        get: { true },
        set: { _ in }
      ),
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
