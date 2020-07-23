import Foundation

struct State: Location {
    let type: LocationType = .state

    static let empty = State(fips: "xx", name: "No Location")

    let fips: String
    let name: String
    let population: Int?

    init(fips: String?, name: String?, population: Int? = nil) throws {
        guard let fips = fips, let name = name else {
            throw "Attempted incomplete initialization of State"
        }
        self.init(fips: fips, name: name, population: population)
    }

    init(fips: String, name: String, population: Int? = nil) {
        self.fips = fips
        self.name = name
        self.population = population
    }

    enum CodingKeys: String, CodingKey {
        case fips
        case name
        case population
    }

    func with(population: Int) -> State {
        return State(fips: self.fips, name: self.name, population: population)
    }
}

extension State: Codable {}

extension State: Equatable {}
