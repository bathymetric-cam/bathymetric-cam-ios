import GEOSwift
import SwiftUI

// MARK: - AppState
struct AppState: Equatable {
    // MARK: - property
    
    var geoJSON: GeoJSON?
    /*
    var _geoJSON: GeoJSON?
    var geoJSON: Binding<GeoJSON?> {
        Binding<GeoJSON?>(
            get: { _geoJSON },
            set: { _ in }
        )
    }
    */
}
