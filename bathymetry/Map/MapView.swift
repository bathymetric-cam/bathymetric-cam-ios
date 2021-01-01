import GEOSwift
import Mapbox
import SwiftUI

// MARK: - UIMapView
final class UIMapView: MGLMapView {
    
    // MARK: - property
    
    // MARK: - initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, styleURL: URL?) {
        MGLAccountManager.accessToken = "pk.eyJ1Ijoia2VuemFuODAwMCIsImEiOiJja2Rva2R5aHgxdDYxMndxM2p4d20wMDRwIn0.waANNEC_jYG1_Hk5OExA3A"
        super.init(frame: frame, styleURL: styleURL)
        self.styleURL = traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL : MGLStyle.lightStyleURL
        showsUserLocation = true
        zoomLevel = 15
        /*
        isZoomEnabled = false
        isScrollEnabled = false
        isRotateEnabled = false
        isPitchEnabled = false
        compassView.isHidden = true
        */
    }
    
    // MARK: - destruction
    
    deinit {
    }
    
    // MARK: - life cycle
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        styleURL = traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL : MGLStyle.lightStyleURL
    }
    
    // MARK: - public api
    
    /// Updates annotations on the map
    /// - Parameter geoJSON: GeoJSON?
    /// - Returns: MapView
    func updateAnnotations(_ geoJSON: GeoJSON?) {
        removeAnnotations(annotations ?? [])
        guard case let .featureCollection(featureCollection) = geoJSON else {
            return
        }
        addAnnotations(
            featureCollection.features.compactMap { $0.geometry?.mapboxShape() as MGLShape? }
        )
    }
}

// MARK: - MapView
struct MapView: UIViewRepresentable {

    // MARK: - property
    
    private let mapView: UIMapView = UIMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    @Binding var geoJSON: GeoJSON?
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: UIMapView, context: UIViewRepresentableContext<MapView>) {
        uiView.updateAnnotations(geoJSON)
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
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "firebasestorage.googleapis.com"
            // components.path = "/v0/b/bathymetric-cam.appspot.com/o/countries.geojson"
            components.path = "/v0/b/bathymetric-cam.appspot.com/o/depth.geojson"
            components.queryItems = [
                URLQueryItem(name: "alt", value: "media"),
                // URLQueryItem(name: "token", value: "b48ca281-c969-4166-8440-91c2b3bc8382"),
                URLQueryItem(name: "token", value: "9b988f65-3f47-4106-826a-918a77456fc4"),
            ]
            guard let url = components.url else {
                return
            }
            let source = MGLShapeSource(identifier: "transit", url: url, options: nil)
            style.addSource(source)
            style.addPolygons(from: source)
        }
    }
}

// MARK: - MapView_Previews
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(geoJSON: Binding<GeoJSON?>(
            get: { nil },
            set: { _ in }
        ))
    }
}
