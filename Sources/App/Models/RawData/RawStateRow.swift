import Foundation
import SwiftCSV
import Vapor

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

    var location: State {
        State(fips: fips, name: state)
    }
}

extension RawStateRow: Equatable {}

extension RawStateRow: Content {}

extension RawStateRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fips)
    }
}
