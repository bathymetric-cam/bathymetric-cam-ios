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
        if let path = Bundle.main.path(forResource: "Mapbox-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let accessToken = plist["MGLMapboxAccessToken"] {
            MGLAccountManager.accessToken = "\(accessToken)"
        }
        super.init(frame: frame, styleURL: styleURL)
        self.styleURL = traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL : MGLStyle.lightStyleURL
        showsUserLocation = true
        zoomLevel = 16
        isZoomEnabled = false
        isScrollEnabled = false
        isRotateEnabled = false
        isPitchEnabled = false
        compassView.isHidden = true
    }
    
    // MARK: - destruction
    
    deinit {
    }
    
    // MARK: - life cycle
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        styleURL = traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL : MGLStyle.lightStyleURL
    }
}

// MARK: - MapView
struct MapView: UIViewRepresentable {

    // MARK: - property
    
    private let mapView: UIMapView = UIMapView(frame: .zero, styleURL: MGLStyle.streetsStyleURL)
    @Binding var bathymetryTiles: [BathymetryTile]
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: UIMapView, context: UIViewRepresentableContext<MapView>) {
        uiView.style?.layers
            .compactMap { $0.identifier.starts(with: "\(Bundle.main.bundleIdentifier ?? "")") ? $0 : nil }
            .forEach { uiView.style?.removeLayer($0) }
        uiView.style?.sources
            .compactMap { $0.identifier.starts(with: "\(Bundle.main.bundleIdentifier ?? "")") ? $0 : nil }
            .forEach { uiView.style?.removeSource($0) }
        bathymetryTiles.forEach {
            let mapboxSource = MGLShapeSource(bathymetryTile: $0)
            uiView.style?.addSource(mapboxSource)
            let mapboxLayer = MGLFillStyleLayer(bathymetryTile: $0, source: mapboxSource)
            mapboxLayer.fillColor = NSExpression(forConstantValue: UIColor.systemBlue.withAlphaComponent(0.3))
            mapboxLayer.fillOutlineColor = NSExpression(forConstantValue: UIColor.systemBlue)
            uiView.style?.addLayer(mapboxLayer)
        }
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
            
        }
    }
}

// MARK: - MapView_Previews
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(bathymetryTiles: Binding<[BathymetryTile]>(
            get: { [] },
            set: { _ in }
        ))
    }
}
