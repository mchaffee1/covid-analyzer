import Foundation
import SwiftCSV
import Vapor

protocol StateFileDataset {
    var stateRows: [StateRow] { get }
}

class NytDataset: StateFileDataset {
    private(set) lazy var stateRows = loadStates(from: sourceFile)

    private let sourceFile: URL

    public init(sourceFile: URL? = nil) throws {
        if let sourceFile = sourceFile {
            self.sourceFile = sourceFile
        } else {
            let bundle = Bundle(for: type(of: self))
            guard let sourceFile = bundle.url(forResource: "us-states", withExtension: "csv") else {
                throw NSError(domain: "NytDataset", code: 404, userInfo: ["Message": "Could not resolve us-states.csv URL"])
            }
            self.sourceFile = sourceFile
        }
    }

    private func loadStates(from sourceUrl: URL) -> [StateRow] {
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

extension NytDataset: Service {}

extension Int {
    init?(_ string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string)
    }
}
