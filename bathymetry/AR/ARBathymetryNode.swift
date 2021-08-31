import ARKit_CoreLocation
import CoreLocation
import Euclid
import SceneKit

// MARK: - ARBathymetryNode
open class ARBathymetryNode: LocationNode {

  // MARK: initializer

  @available(*, unavailable)
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Inits
  /// - Parameters:
  ///   - bathymetryTile: BathymetryTile
  ///   - altitude: altitude of node
  ///   - waterSurface: offset altitude of water surface
  init(
    bathymetryTile: BathymetryTile,
    altitude: Double,
    waterSurface: Double
  ) {
    super.init(location: CLLocation(coordinate: bathymetryTile.sw, altitude: altitude))
    guard let image = bathymetryTile.image else {
      return
    }
    let positions: [Vector] = [
      .init(latitude: bathymetryTile.ne.latitude, longitude: bathymetryTile.sw.longitude),
      bathymetryTile.sw,
      .init(latitude: bathymetryTile.sw.latitude, longitude: bathymetryTile.ne.longitude),
      bathymetryTile.ne,
    ]
      .map { (coord: CLLocationCoordinate2D) -> Vector in
        let latDistance = CLLocation(coordinate: bathymetryTile.sw, altitude: 0).distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: coord.latitude, longitude: bathymetryTile.sw.longitude), altitude: 0))
        let lngDistance = CLLocation(coordinate: bathymetryTile.sw, altitude: 0).distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: bathymetryTile.sw.latitude, longitude: coord.longitude), altitude: 0))
        return Vector(lngDistance, waterSurface, latDistance)
      }
    let texCoords: [Vector] = [
      .init(0, 0),
      .init(0, 1),
      .init(1, 1),
      .init(1, 0)
    ]
    guard let polygon = Polygon(zip(positions, texCoords).map { Vertex($0.0, Vector(0, -1, 0), $0.1) }),
          let mesh = Mesh(SCNGeometry(Mesh([polygon])), material: .init(image)) else {
      return
    }
    addChildNode(SCNNode(geometry: SCNGeometry(mesh)))
  }
}
