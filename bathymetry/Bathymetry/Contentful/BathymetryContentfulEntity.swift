import Contentful
import GEOSwift
import Foundation

// MARK: - BathymetryContentfulEntity
final class BathymetryContentfulEntity: BathymetryEntity, EntryDecodable, FieldKeysQueryable {
    
    // MARK: - static constant
    
    static let contentTypeId = "bathymetry"
    
    // MARK: - enum
    
    enum FieldKeys: String, CodingKey {
        case zoom, x, y
        case geoJSON
    }

    // MARK: - property
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let zoom: Int?
    let x: Int?
    let y: Int?
    let geoJSON: GeoJSON?

    // MARK: - initialization
    
    required init(from decoder: Decoder) throws {
        let sys = try decoder.sys()
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        let fields = try decoder.contentfulFieldsContainer(keyedBy: BathymetryContentfulEntity.FieldKeys.self)
        zoom = try fields.decodeIfPresent(Int.self, forKey: .zoom)
        x = try fields.decodeIfPresent(Int.self, forKey: .x)
        y = try fields.decodeIfPresent(Int.self, forKey: .y)
        geoJSON = try fields.decodeIfPresent(GeoJSON.self, forKey: .geoJSON)
    }
}

// MARK: - Equatable
extension BathymetryContentfulEntity: Equatable {
    static func == (lhs: BathymetryContentfulEntity, rhs: BathymetryContentfulEntity) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y && lhs.zoom == rhs.zoom
    }
}
