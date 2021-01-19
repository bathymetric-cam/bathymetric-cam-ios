import Contentful
import GEOSwift
import Foundation

// MARK: - Bathymetry
final class Bathymetry: EntryDecodable, FieldKeysQueryable {

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
    
    public required init(from decoder: Decoder) throws {
        let sys = try decoder.sys()
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        let fields = try decoder.contentfulFieldsContainer(keyedBy: Bathymetry.FieldKeys.self)
        zoom = try fields.decodeIfPresent(Int.self, forKey: .zoom)
        x = try fields.decodeIfPresent(Int.self, forKey: .x)
        y = try fields.decodeIfPresent(Int.self, forKey: .y)
        geoJSON = try fields.decodeIfPresent(GeoJSON.self, forKey: .geoJSON)
    }

    init(x: Int, y: Int, zoom: Int) {
        id = ""
        localeCode = nil
        updatedAt = nil
        createdAt = nil
        self.x = x
        self.y = y
        self.zoom = zoom
        geoJSON = nil
    }
}

// MARK: - Equatable
extension Bathymetry: Equatable {
    static func == (lhs: Bathymetry, rhs: Bathymetry) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.zoom == rhs.zoom
    }
}
