import Foundation
//import SwiftCSV

struct RawLoadableRow {
    let date: IsoDate
    let state: String
    let fips: String
    let cases: Int
    let deaths: Int
    let locationType = LocationType.state

    init?(date: IsoDate?,
          state: String?,
          fips: String?,
          cases: Int?,
          deaths: Int?) {
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

extension RawLoadableRow: Codable {}

extension RawLoadableRow: Equatable {}

extension RawLoadableRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fips)
    }
}
