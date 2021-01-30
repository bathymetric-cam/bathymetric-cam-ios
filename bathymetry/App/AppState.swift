import GEOSwift
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
    // MARK: property
    
    var bathymetryTiles: [BathymetryTile] = []
    var region: Region?
}
