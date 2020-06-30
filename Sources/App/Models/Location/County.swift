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

    init(fips: String?, name: String?, state: String?) throws {
        guard let fips = fips,
            let name = name,
            let state = state else {
                throw "Attempted incomplete initialization of County"
        }
        self.fips = fips
        self.name = name
        self.state = state
    }
}

extension County: Codable {}

extension County: Equatable {}
