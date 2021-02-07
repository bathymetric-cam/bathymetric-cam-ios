import ARKit_CoreLocation
import CoreLocation
import Euclid
import GEOSwift
import iGeometry
import iShapeTriangulation
import SceneKit

// MARK: - ARBathymetryNode
open class ARBathymetryNode: LocationNode {

    // MARK: initialization

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Inits
    /// - Parameters:
    ///   - bathymetryTile: BathymetryTile
    ///   - bathymetryColors: BathymetryColors
    ///   - altitude: altitude of node
    init(bathymetryTile: BathymetryTile, bathymetryColors: BathymetryColors, altitude: Double) {
        let location = CLLocation(coordinate: bathymetryTile.sw, altitude: altitude)
        super.init(location: location)
        
        let normal = Euclid.Vector(0, -1, 0)
        bathymetryColors.forEach { color in
            let positionsList = createPositionsList(bathymetryTile: bathymetryTile, depth: color.depth)
            let indicesList = createIndicesList(positionsList: positionsList)
            
            for i in 0..<indicesList.count {
                for j in 0..<indicesList[i].count {
                    for k in 0..<indicesList[i][j].count where k % 3 == 0 {
                        if let polygon = Euclid.Polygon([
                            Euclid.Vertex(positionsList[i][j][indicesList[i][j][k + 0]], normal),
                            Euclid.Vertex(positionsList[i][j][indicesList[i][j][k + 1]], normal),
                            Euclid.Vertex(positionsList[i][j][indicesList[i][j][k + 2]], normal),
                        ]) {
                            addChildNode(SCNNode(geometry: SCNGeometry(Mesh([polygon]).replacing(nil, with: color.uiColor.withAlphaComponent(0.8)))))
                        }
                    }
                }
            }
        }
    }
    
    // MARK: private api
    
    /// Creates positions of polygon's vertices
    /// - Parameters:
    ///   - bathymetryTile: BathymetryTile object
    ///   - depth: depth range
    /// - Returns: positions of polygon's vertices
    private func createPositionsList(bathymetryTile: BathymetryTile, depth: BathymetryDepth) -> [[[Euclid.Vector]]] {
        bathymetryTile
            .getFeatures(depth: depth)
            .compactMap { feature -> MultiPolygon? in
                switch feature.geometry {
                case let .polygon(polygon):
                    return MultiPolygon(polygons: [polygon])
                case let .multiPolygon(multiPolygon):
                    return multiPolygon
                default:
                    return nil
                }
            }
            .map { $0.polygons }
            .map { polygons -> [[Euclid.Vector]] in
                polygons.map { polygon -> [Euclid.Vector] in
                    var vectors = polygon.exterior.points.map { point -> Euclid.Vector in
                        let lngDistance = CLLocation(coordinate: bathymetryTile.sw, altitude: 0).distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: bathymetryTile.sw.latitude, longitude: point.x), altitude: 0))
                        let latDistance = CLLocation(coordinate: bathymetryTile.sw, altitude: 0).distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: point.y, longitude: bathymetryTile.sw.longitude), altitude: 0))
                        return Euclid.Vector(lngDistance, -1, latDistance)
                    }
                    var clockwise = 0.0
                    for i in 1...vectors.count - 1 {
                        clockwise += (vectors[i].x - vectors[i - 1].x) * (vectors[i].z + vectors[i - 1].z)
                    }
                    vectors.removeLast()
                    return clockwise > 0.0 ? vectors : vectors.reversed()
                }
            }
    }
    
    /// Divides plygons into triangles and returns the vertices index
    /// - Parameter positionsList: positions of polygon's vertices
    /// - Returns: trinangle indices
    private func createIndicesList(positionsList: [[[Euclid.Vector]]]) -> [[[Int]]] {
        let triangulator = Triangulator()
        return positionsList
            .map { polygons -> [[iGeometry.Point]] in
                polygons.map { vectors -> [iGeometry.Point] in
                    vectors.map { iGeometry.Point(x: Float($0.x), y: Float($0.z)) }
                }
            }
            .map {
                $0.map { triangulator.triangulateDelaunay(points: $0) }
            }
    }
    
}
