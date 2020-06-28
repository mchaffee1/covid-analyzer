import Foundation
import SwiftCSV

struct RawStateRow {
    let date: IsoDate
    let state: String
    let fips: String
    let cases: Int
    let deaths: Int

    init?(date: IsoDate?, state: String?, fips: String?, cases: Int?, deaths: Int?) {
        guard let date = date,
            let state = state,
            let fips = fips,
            let cases = cases,
            let deaths = deaths else {
                return nil
        }
        self.date = date
        self.state = state
        self.fips = fips
        self.cases = cases
        self.deaths = deaths
    }

    var location: Location {
        State(fips: fips, name: state)
    }
}

extension RawStateRow: Codable {}

extension RawStateRow: Equatable {}

extension RawStateRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fips)
    }
}
