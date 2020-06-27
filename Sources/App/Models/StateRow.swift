import Foundation
import SwiftCSV

struct StateRow {
    let date: DateComponents
    let state: String
    let fips: String
    let cases: Int
    let deaths: Int

    init?(date: DateComponents?, state: String?, fips: String?, cases: Int?, deaths: Int?) {
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
}

extension StateRow: Equatable {}
