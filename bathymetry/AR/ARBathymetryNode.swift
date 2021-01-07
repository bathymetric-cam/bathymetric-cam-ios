import ARKit_CoreLocation
import CoreLocation
import SceneKit

// MARK: - ARBathymetryNode
open class ARBathymetryNode: LocationNode {
    
    // MARK: - property
    
    private let node: SCNNode

    // MARK: - initialization

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Inits
    /// - Parameters:
    ///   - bathymetryTile: BathymetryTile
    init(bathymetryTile: BathymetryTile) {
        /*
        let location = CLLocation(coordinate: bathymetryTile.sw, altitude: 0)
        let annotationImage = UIImage(systemName: "map.fill") ?? UIImage()
        let plane = SCNPlane(
            width: annotationImage.size.width / UIScreen.main.scale,
            height: annotationImage.size.height / UIScreen.main.scale
        )
        if let firstMaterial = plane.firstMaterial {
            firstMaterial.diffuse.contents = annotationImage
            firstMaterial.lightingModel = .constant
        }
        node = SCNNode()
        node.geometry = plane
         
        super.init(location: location)
         
        addChildNode(node)
        */
        
        /*
        SCNVector3(, , )
        SCNGeometryElement(
            data: <#T##Data?#>,
            primitiveType: T##SCNGeometryPrimitiveType,
            primitiveCount: <#T##Int#>,
            bytesPerIndex: <#T##Int#>
        )
        */
        let location = CLLocation(coordinate: bathymetryTile.sw, altitude: 0)
        
        node = SCNNode()
        
        super.init(location: location)
        
        addChildNode(node)
    }
    
}
