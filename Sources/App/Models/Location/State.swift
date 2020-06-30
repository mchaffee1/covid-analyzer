import Foundation

struct State: Location {
    let type: LocationType = .state

    let fips: String
    let name: String

    init(fips: String?, name: String?) throws {
        guard let fips = fips, let name = name else {
            throw "Attempted incomplete initialization of State"
        }
        self.fips = fips
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case fips
        case name
    }
}

extension State: Codable {}

extension State: Equatable {}
