import Combine
import Mapbox
import SwiftUI

// MARK: - UIMapboxMapViewFactory
final class UIMapboxMapViewFactory: UIMapViewFactory {
  
  static func createMapView(zoomLevel: BathymetryZoomLevel) -> UIMapView {
    guard let path = Bundle.main.path(forResource: "Mapbox-Info", ofType: "plist") else {
      fatalError("Cannot open Mapbox-Info.plist")
    }
    guard let plist = NSDictionary(contentsOfFile: path),
          let accessToken = plist["MGLMapboxAccessToken"] else {
      fatalError("Invalid Mapbox-Info.plist")
    }
    MGLAccountManager.accessToken = "\(accessToken)"
    let uiMapView = UIMapboxMapView(frame: .zero, styleURL: MGLStyle.lightStyleURL)
    uiMapView.styleURL = uiMapView.traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL : MGLStyle.lightStyleURL
    uiMapView.showsUserLocation = true
    uiMapView.zoomLevel = zoomLevel
    uiMapView.isZoomEnabled = false
    uiMapView.isScrollEnabled = false
    uiMapView.isRotateEnabled = false
    uiMapView.isPitchEnabled = false
    uiMapView.compassView.isHidden = true
    return uiMapView
  }
  
}

// MARK: - UIMapboxMapView
class UIMapboxMapView: MGLMapView {
  // MARK: property
  
  private var sources = [MGLSource]()
  private var layers = [MGLStyleLayer]()
  
  // MARK: deinit
  
  deinit {
    layers.forEach { [weak self] in self?.style?.removeLayer($0) }
    sources.forEach { [weak self] in self?.style?.removeSource($0) }
  }
  
  // MARK: life cycle
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    styleURL = traitCollection.userInterfaceStyle == .dark ? MGLStyle.darkStyleURL(withVersion: 9) : MGLStyle.lightStyleURL(withVersion: 9)
  }
  
  // MARK: public api
  
  func updateBathymetryLayers(bathymetryTiles: [BathymetryTile]) {
    let newSources = bathymetryTiles
      .compactMap { [weak self] (tile: BathymetryTile) -> MGLImageSource? in
        guard let self = self,
              !self.sources.contains(where: { $0.identifier == tile.identifier }),
              let image = tile.image else {
          return nil
        }
        let quad = MGLCoordinateQuad(
          topLeft: .init(latitude: tile.ne.latitude, longitude: tile.sw.longitude),
          bottomLeft: .init(latitude: tile.sw.latitude, longitude: tile.sw.longitude),
          bottomRight: .init(latitude: tile.sw.latitude, longitude: tile.ne.longitude),
          topRight: .init(latitude: tile.ne.latitude, longitude: tile.ne.longitude)
        )
        return MGLImageSource(identifier: tile.identifier, coordinateQuad: quad, image: image)
      }
    newSources.forEach { [weak self] in self?.style?.addSource($0) }
    let newLayers = newSources.map { MGLRasterStyleLayer(identifier: $0.identifier, source: $0) }
    newLayers.forEach { [weak self] in self?.style?.addLayer($0) }
    sources += newSources
    layers += newLayers
  }
}

// MARK: - UIMapView+Mapbox
extension UIMapView {
  // MARK: static constant
  static let mapbox = UIMapboxMapViewFactory.createMapView(zoomLevel: .max)
}

// MARK: - MapView+MGLMapView
extension MapView {
  
  // MARK: UIViewRepresentable
  
  func makeUIView(context: UIViewRepresentableContext<MapView>) -> UIMapView {
    if let mapboxMapView = internalMapView as? MGLMapView {
      mapboxMapView.delegate = context.coordinator
    }
    return internalMapView
  }
  
  func updateUIView(_ uiView: UIMapView, context: UIViewRepresentableContext<MapView>) {
    if let mapboxMapView = uiView as? MGLMapView {
      updateBathymetryLayers(mapView: mapboxMapView)
      mapboxMapView.setZoomLevel(zoomLevel, animated: false)
    }
  }
  
  // MARK: Coordinator
  
  final class Coordinator: NSObject, MGLMapViewDelegate {
    var control: MapView
  
    init(_ control: MapView) {
      self.control = control
    }
  
    // MARK: MGLMapViewDelegate
  
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
  
  // MARK: private api
  
  /// Called when user location is updated
  /// - Parameters:
  ///   - mapView: MGLMapView
  ///   - userLocation: MGLUserLocation
  private func didUpdateUserLocation(mapView: MGLMapView, userLocation: MGLUserLocation?) {
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
  private func regionDidChangeAnimated(mapView: MGLMapView, animated: Bool) {
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
    let swTile = BathymetryTile(zoom: zoom, coordinate: CLLocationCoordinate2D(latitude: minLat, longitude: minLng))
    let neTile = BathymetryTile(zoom: zoom, coordinate: CLLocationCoordinate2D(latitude: maxLat, longitude: maxLng))
    if let region = try? MapRegion(swTile: swTile, neTile: neTile) {
      regionDidChangePublisher.send(region)
    }
  }
  
  /// Updates bathymetry layers
  /// - Parameter mapView: UIKit MapView that inherits MGLMapView
  private func updateBathymetryLayers(mapView: MGLMapView) {
    guard let mapView = mapView as? UIMapboxMapView else {
      return
    }
    mapView.updateBathymetryLayers(bathymetryTiles: bathymetryTiles)
  }
}

// MARK: - MapView_Previews
struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(
      internalMapView: .mapbox,
      bathymetryTiles: Binding<[BathymetryTile]>(
        get: { [] },
        set: { _ in }
      ),
      bathymetries: Binding<[Bathymetry]>(
        get: { .default },
        set: { _ in }
      ),
      zoomLevel: Binding<BathymetryZoomLevel>(
        get: { BathymetryZoomLevel.max },
        set: { _ in }
      )
    )
  }
}
