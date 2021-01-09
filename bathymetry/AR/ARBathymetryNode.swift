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
        
        /*
        let polygons = Array(
            bathymetryTile.features
                .compactMap { feature -> MultiPolygon? in
                    guard case let .multiPolygon(multiPolygon) = feature.geometry else {
                        return nil
                    }
                    return multiPolygon
                }
                .map { $0.polygons }
                .joined()
        )
        polygons.forEach {
            let node = SCNNode(geometry: SCNGeometry(
                sources: [SCNGeometrySource(vertices:
                    $0.exterior.points.map { SCNVector3($0.x - bathymetryTile.sw.longitude, $0.y - bathymetryTile.sw.latitude, 0) }
                )],
                elements: [SCNGeometryElement(indices: $0.exterior.points.enumerated().map { i, _ in i }, primitiveType: .triangles)]
            ))
            addChildNode(node)
        }
        */
        let node = SCNNode()
        let cube = Mesh.cube(size: 10, material: UIColor.red)
        node.geometry = SCNGeometry(cube)
        addChildNode(node)
    }
    
}
