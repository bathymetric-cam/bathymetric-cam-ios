import ComposableArchitecture
import Combine

// MARK: - BathymetryTileClient
protocol BathymetryTileClient {
  // MARK: property
  func loadBathymetryTile(_ region: MapRegion) -> Effect<[BathymetryTile], Error>
}
