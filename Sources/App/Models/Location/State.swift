import Foundation

struct State: Location {
    let type: LocationType = .state

    let fips: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case fips
        case name
    }
}

extension State: Codable {}

extension State: Equatable {}
