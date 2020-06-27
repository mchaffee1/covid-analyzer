import Foundation
import SwiftCSV

protocol StateFileProvider {
    func loadStates(from: URL) -> [StateRow]
}

class NytLoader: StateFileProvider {
    func loadStates(from sourceUrl: URL) -> [StateRow] {
        guard let csv = try? CSV(url: sourceUrl) else {
            return []
        }
        return csv.namedRows
            .compactMap { row in
            StateRow(date: DateComponents(isoDay: row["date"]),
                     state: row["state"],
                     fips: row["fips"],
                     cases: Int(row["cases"]),
                     deaths: Int(row["deaths"]))
        }
    }
}

extension Int {
    init?(_ string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string)
    }
}
