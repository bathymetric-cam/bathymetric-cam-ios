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
        zoom == region.zoom &&
        swTile.x <= region.swTile.x &&
        swTile.y >= region.swTile.y &&
        neTile.x >= region.neTile.x &&
        neTile.y <= region.neTile.y
    }
    
    /// Returns larger region
    /// - Returns: larger region
    func largerRegion() -> BathymetryRegion {
        let x = neTile.x - swTile.x <= 0 ? 1 : neTile.x - swTile.x
        let y = swTile.y - neTile.y <= 0 ? 1 : swTile.y - neTile.y
        return BathymetryRegion(
            swTile: RegionTile(x: swTile.x - x, y: swTile.y + y),
            neTile: RegionTile(x: neTile.x + x, y: neTile.y - y),
            zoom: zoom
        )
    }
}

// MARK: - BathymetryRegion + Equatable
extension BathymetryRegion: Equatable {
    static func == (lhs: BathymetryRegion, rhs: BathymetryRegion) -> Bool {
        lhs.zoom == rhs.zoom && lhs.swTile == rhs.swTile && lhs.neTile == rhs.neTile
    }
}
