import ARKit_CoreLocation
import CoreLocation
import Euclid
import GEOSwift
import iGeometry
import iShapeTriangulation
import SceneKit

// MARK: - ARBathymetryNode
open class ARBathymetryNode: LocationNode {

    // MARK: - initialization

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Inits
    /// - Parameters:
    ///   - bathymetryTile: BathymetryTile
    init(bathymetryTile: BathymetryTile) {
        let location = CLLocation(coordinate: bathymetryTile.sw, altitude: 0)
        super.init(location: location)
        
        // get positions of polygon's vertices
        let positionsList = bathymetryTile.features
            .compactMap { feature -> MultiPolygon? in
                guard case let .multiPolygon(multiPolygon) = feature.geometry else {
                    return nil
                }
                return multiPolygon
            }
            .map { $0.polygons }
            .map { polygons -> [[Euclid.Vector]] in
                polygons.map { polygon -> [Euclid.Vector] in
                    var vectors = polygon.exterior.points.map { point -> Euclid.Vector in
                        let lngDistance = CLLocation(coordinate: bathymetryTile.sw, altitude: 0).distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: bathymetryTile.sw.latitude, longitude: point.x), altitude: 0))
                        let latDistance = CLLocation(coordinate: bathymetryTile.sw, altitude: 0).distance(from: CLLocation(coordinate: CLLocationCoordinate2D(latitude: point.y, longitude: bathymetryTile.sw.longitude), altitude: 0))
                        return Euclid.Vector(lngDistance, 0, -latDistance)
                    }
                    vectors.removeLast()
                    return vectors
                }
            }
        
        // divide plygons into triangles
        let triangulator = Triangulator()
        let indicesList = positionsList
            .map { polygons -> [[iGeometry.Point]] in
                polygons.map { vectors -> [iGeometry.Point] in
                    vectors.map { iGeometry.Point(x: Float($0.x), y: Float($0.z)) }
                }
            }
            .map {
                $0.map { triangulator.triangulateDelaunay(points: $0) }
            }
        
        let normal = Euclid.Vector(0, -1, 0)
        for i in 0..<indicesList.count {
            for j in 0..<indicesList[i].count {
                for k in 0..<indicesList[i][j].count where k % 3 == 0 {
                    if let polygon = Euclid.Polygon([
                        Euclid.Vertex(positionsList[i][j][indicesList[i][j][k + 0]], normal),
                        Euclid.Vertex(positionsList[i][j][indicesList[i][j][k + 1]], normal),
                        Euclid.Vertex(positionsList[i][j][indicesList[i][j][k + 2]], normal),
                    ]) {
                        addChildNode(SCNNode(geometry: SCNGeometry(Mesh([polygon]).replacing(nil, with: UIColor.blue.withAlphaComponent(0.8)))))
                    }
                }
            }
        }
    }
    
}
