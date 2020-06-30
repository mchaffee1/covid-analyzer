import Foundation

struct County: Location {
    let type: LocationType = .county

    let fips: String
    let name: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case fips
        case name
        case state
    }
}

extension County: Codable {}

extension County: Equatable {}
