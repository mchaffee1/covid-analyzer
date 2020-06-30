import Foundation

enum LocationType: String {
    case nation
    case state
    case county
}

extension LocationType: Codable {}

protocol Location: Encodable {
    var type: LocationType { get }
    var fips: String { get }
    var name: String { get }
}
