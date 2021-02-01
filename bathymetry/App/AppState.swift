import CoreLocation
import GEOSwift
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
    // MARK: property
    
    var bathymetryTiles: [BathymetryTile] = []
    var bathymetryColors: BathymetryColors
    var zoomLevel = MapView.ZoomLevel.max
    var region = Region(
        swTile: RegionTile(x: 0, y: 0, zoom: Int(MapView.ZoomLevel.max)),
        neTile: RegionTile(x: 0, y: 0, zoom: Int(MapView.ZoomLevel.max))
    )
}
