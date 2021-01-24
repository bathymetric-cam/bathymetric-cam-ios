import Combine
import GEOSwift
import Mapbox
import SwiftUI

// MARK: - UIMapboxMapViewFactory
final class UIMapboxMapViewFactory: UIMapViewFactory {
    
    static func createMapView() -> UIMapView {
        if let path = Bundle.main.path(forResource: "Mapbox-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let accessToken = plist["MGLMapboxAccessToken"] {
            MGLAccountManager.accessToken = "\(accessToken)"
        }
        let uiMapView = MGLMapView(frame: .zero, styleURL: MGLStyle.lightStyleURL)
        uiMapView.styleURL = uiMapView.traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL : MGLStyle.lightStyleURL
        uiMapView.showsUserLocation = true
        uiMapView.zoomLevel = 16
        uiMapView.isZoomEnabled = false
        uiMapView.isScrollEnabled = false
        uiMapView.isRotateEnabled = false
        uiMapView.isPitchEnabled = false
        uiMapView.compassView.isHidden = true
        return uiMapView
    }
    
}

// MARK: - MapboxMapView
struct MapboxMapView: MapView {
    
    // MARK: - property
    
    @Binding var bathymetryTiles: [BathymetryTile]
    let regionDidChangePublisher = PassthroughSubject<Region, Never>()
    
    // MARK: - MapView (UIViewRepresentable)
    
    func makeUIView(context: UIViewRepresentableContext<MapboxMapView>) -> MGLMapView {
        guard let mapView = UIMapboxMapViewFactory.createMapView() as? MGLMapView else {
            return MGLMapView(frame: .zero, styleURL: MGLStyle.lightStyleURL)
        }
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapboxMapView>) {
        updateBathymetryLayers(mapView: uiView)
    }
    
    static func dismantleUIView(_ uiView: MapboxMapView.UIViewType, coordinator: MapboxMapView.Coordinator) {
    }
    
    func makeCoordinator() -> MapboxMapView.Coordinator {
        Coordinator(self)
    }
    
    // MARK: - MapView
    
    func regionDidChange(perform action: @escaping (_ region: Region) -> Void) -> some View {
        onReceive(regionDidChangePublisher) { action($0) }
    }
    
    // MARK: - internal api
    
    /// Called when user location is updated
    /// - Parameters:
    ///   - mapView: MGLMapView
    ///   - userLocation: MGLUserLocation
    internal func didUpdateUserLocation(mapView: MGLMapView, userLocation: MGLUserLocation?) {
        if mapView.userTrackingMode == .followWithHeading {
            return
        }
        if let coordinate = userLocation?.coordinate {
            mapView.setCenter(coordinate, animated: false)
        }
        if let heading = userLocation?.heading?.trueHeading {
            mapView.setDirection(heading, animated: false)
        }
        mapView.userTrackingMode = .followWithHeading
    }
    
    /// Called when region is changed
    /// - Parameters:
    ///   - mapView: MGLMapView
    ///   - animated: bool flag if animated when changing the region
    internal func regionDidChangeAnimated(mapView: MGLMapView, animated: Bool) {
        if mapView.userLocation?.location == nil {
            return
        }
        let coordinates = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: mapView.frame.width, y: 0),
            CGPoint(x: 0, y: mapView.frame.height),
            CGPoint(x: mapView.frame.width, y: mapView.frame.height),
        ]
            .map { mapView.convert($0, toCoordinateFrom: nil) }
        guard let maxLat = coordinates.min(by: { $0.latitude > $1.latitude })?.latitude,
              let maxLng = coordinates.min(by: { $0.longitude > $1.longitude })?.longitude,
              let minLat = coordinates.max(by: { $0.latitude > $1.latitude })?.latitude,
              let minLng = coordinates.max(by: { $0.longitude > $1.longitude })?.longitude else {
            return
        }
        let zoom = Int(mapView.zoomLevel)
        let swTile = RegionTile(coordinate: CLLocationCoordinate2D(latitude: minLat, longitude: minLng), zoom: zoom)
        let neTile = RegionTile(coordinate: CLLocationCoordinate2D(latitude: maxLat, longitude: maxLng), zoom: zoom)
        regionDidChangePublisher.send(Region(swTile: swTile, neTile: neTile))
    }
    
    /// Updates bathymetry layers
    /// - Parameter mapView: UIKit MapView that inherits MGLMapView
    internal func updateBathymetryLayers(mapView: MGLMapView) {
        mapView.style?.layers
            .compactMap { $0.identifier.starts(with: "\(Bundle.main.bundleIdentifier ?? "")") ? $0 : nil }
            .forEach { mapView.style?.removeLayer($0) }
        mapView.style?.sources
            .compactMap { $0.identifier.starts(with: "\(Bundle.main.bundleIdentifier ?? "")") ? $0 : nil }
            .forEach { mapView.style?.removeSource($0) }
        bathymetryTiles.forEach { bathymetryTile in
            bathymetryTile.getFeatures(minDepth: 0, maxDepth: 1)
                .forEach {
                    let source = MGLShapeSource(identifier: "\(Bundle.main.bundleIdentifier ?? "").source.\(bathymetryTile.name).\(1)", feature: $0)
                    mapView.style?.addSource(source)
                    let mapboxLayer = MGLFillStyleLayer(identifier: "\(Bundle.main.bundleIdentifier ?? "").layer.\(bathymetryTile.name).\(1)", source: source)
                    mapboxLayer.fillColor = NSExpression(forConstantValue: UIColor.systemBlue.withAlphaComponent(0.3))
                    mapboxLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.systemBlue)
                    mapView.style?.addLayer(mapboxLayer)

                }
        }
    }
}

// MARK: - MapboxMapView+Coordinator
extension MapboxMapView {
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapboxMapView
        
        init(_ control: MapboxMapView) {
            self.control = control
        }
        
        // MARK: - MGLMapViewDelegate
        
        func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
            control.didUpdateUserLocation(mapView: mapView, userLocation: userLocation)
        }
        
        func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
            control.regionDidChangeAnimated(mapView: mapView, animated: animated)
        }
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            control.updateBathymetryLayers(mapView: mapView)
        }
    }
}

// MARK: - MapboxMapView_Previews
struct MapboxMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapboxMapView(
            bathymetryTiles: Binding<[BathymetryTile]>(
                get: { [] },
                set: { _ in }
            )
        )
    }
}
