import Foundation

enum LocationType: String {
    case state
}

extension LocationType: Codable {}

protocol Location: Codable {
    var type: LocationType { get }
    var fips: String { get }
    var name: String { get }
}
