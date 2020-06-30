import Foundation

struct Nation: Location {
    let type: LocationType = .nation

    let fips: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case fips
        case name
    }
}

extension Nation: Codable {}

extension Nation: Equatable {}
