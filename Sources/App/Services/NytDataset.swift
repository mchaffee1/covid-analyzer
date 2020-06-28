import Foundation
import SwiftCSV
import Vapor

protocol StateFileDataset {
    var stateRows: [StateRow] { get }
}

class NytDataset: StateFileDataset {
    private typealias Class = NytDataset
    private(set) var stateRows: [StateRow] = []

    private let locations: Locations
    private let sourceFile: URL

    public init(locations: Locations, sourceFile customUrl: URL? = nil) throws {
        self.locations = locations
        self.sourceFile = try customUrl ?? Class.getStateUrl()

        self.stateRows = loadStates(from: sourceFile)
    }

    // TODO this better
    private static func getStateUrl() throws -> URL {
        let bundle = Bundle(for: Class.self)
        guard let sourceFile = bundle.url(forResource: "us-states", withExtension: "csv") else {
            throw NSError(domain: "NytDataset", code: 404, userInfo: ["Message": "Could not resolve us-states.csv URL"])
        }
        return sourceFile
    }

    private func loadStates(from sourceUrl: URL) -> [StateRow] {
        guard let csv = try? CSV(url: sourceUrl) else {
            return []
        }
        let rows = csv.namedRows
            .compactMap { row in
                StateRow(date: IsoDate(isoString: row["date"]),
                     state: row["state"],
                     fips: row["fips"],
                     cases: Int(row["cases"]),
                     deaths: Int(row["deaths"]))
        }
        rows.forEach { locations.add($0.location) }
        return rows
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
