import Mapbox
import SwiftUI

// MARK: - MapView
struct MapView: UIViewRepresentable {
    
    // MARK: - property
    
    private let mapView: MGLMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        MGLAccountManager.accessToken = "pk.eyJ1Ijoia2VuemFuODAwMCIsImEiOiJja2Rva2R5aHgxdDYxMndxM2p4d20wMDRwIn0.waANNEC_jYG1_Hk5OExA3A"
        mapView.showsUserLocation = true
        mapView.zoomLevel = 15
        mapView.compassView.isHidden = true
        mapView.delegate = context.coordinator
        mapView.tintColor = .systemBlue
        mapView.isUserInteractionEnabled = false
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    static func dismantleUIView(_ uiView: MapView.UIViewType, coordinator: MapView.Coordinator) {
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
        
        // MARK: - MGLMapViewDelegate
        
        func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
            if control.mapView.userTrackingMode == .followWithHeading {
                return
            }
            if let coordinate = userLocation?.coordinate {
                control.mapView.setCenter(coordinate, animated: false)
            }
            if let heading = userLocation?.heading?.trueHeading {
                control.mapView.setDirection(heading, animated: false)
            }
            control.mapView.userTrackingMode = .followWithHeading
        }
    }
    
}

// MARK: - MapView_Previews
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
