// MARK: - BathymetryRegion
struct BathymetryRegion {
    
    // MARK: property
    
    var swTile: RegionTile
    var neTile: RegionTile
    var zoom: Int
    
    // MARK: public api
    
    /// Returns if region contains another region
    /// - Parameter region: another region
    /// - Returns: bool value if containing or not
    func contains(region: BathymetryRegion) -> Bool {
        swTile.x <= region.swTile.x &&
        swTile.y >= region.swTile.y &&
        neTile.x >= region.neTile.x &&
        neTile.y <= region.neTile.y
    }
    
    /// Returns larger region
    /// - Returns: larger region
    func largerRegion() -> BathymetryRegion {
        BathymetryRegion(
            swTile: RegionTile(x: swTile.x - 4, y: swTile.y + 4),
            neTile: RegionTile(x: neTile.x + 4, y: neTile.y - 4),
            zoom: zoom
        )
    }
}

// MARK: - BathymetryRegion + Equatable
extension BathymetryRegion: Equatable {
    static func == (lhs: BathymetryRegion, rhs: BathymetryRegion) -> Bool {
        lhs.swTile == rhs.swTile && lhs.neTile == rhs.neTile
    }
}
