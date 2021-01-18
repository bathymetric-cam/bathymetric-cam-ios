import GEOSwift
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
    // MARK: - property
    
    var bathymetryTiles: [BathymetryTile] = []
    var swTile: RegionTile? // south and west Tile
    var neTile: RegionTile? // north and east Tile
}
