import Contentful
import GEOSwift
import Foundation

// MARK: - BathymetryEntity
protocol BathymetryEntity {
    // MARK: property
    var zoom: Int? { get }
    var x: Int? { get }
    var y: Int? { get }
    var geoJSON: GeoJSON? { get }
}
