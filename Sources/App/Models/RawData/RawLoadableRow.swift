import Foundation

struct RawLoadableRow {
    let date: IsoDate
    let county: String?
    let state: String
    let fips: String
    let cases: Int
    let deaths: Int
    let locationType: LocationType

    init?(date: IsoDate?,
          county: String? = nil,
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
        self.county = county
        self.state = state
        self.fips = fips
        self.cases = cases
        self.deaths = deaths
        self.locationType = county == nil ? .state : .county
    }
}

extension RawLoadableRow: Codable {}

extension RawLoadableRow: Equatable {}

extension RawLoadableRow: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fips)
    }
}
