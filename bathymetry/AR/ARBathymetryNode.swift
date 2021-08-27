import ARKit_CoreLocation
import CoreLocation
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
  ///   - bathymetries: Bathymetries
  ///   - altitude: altitude of node
  ///   - waterSurface: offset altitude of water surface
  init(
    bathymetryTile: BathymetryTile,
    bathymetries: Bathymetries,
    altitude: Double,
    waterSurface: Double
  ) {
    let location = CLLocation(coordinate: bathymetryTile.sw, altitude: altitude)
    super.init(location: location)
  }
}
