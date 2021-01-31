import CoreLocation
import GEOSwift
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
    // MARK: property
    
    var bathymetryTiles: [BathymetryTile] = []
    var bathymetryColors: BathymetryColors
    var region: Region?
}
