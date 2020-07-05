import Foundation

struct CensusLocation: Decodable, Equatable {
    let fips: String
    let name: String
    private let pop: String

    init(fips: String, name: String, pop: String) {
        self.fips = fips
        self.name = name
        self.pop = pop
    }

    var population: Int? { Int(pop) }

    enum CodingKeys: String, CodingKey {
        case fips = "state"
        case name = "NAME"
        case pop = "POP"
    }
}
