import Foundation
import SwiftCSV
import Vapor

protocol RawDataset: Dataset {
    var stateRows: [RawStateRow] { get }
}

class NytDataset: RawDataset {
    private typealias Class = NytDataset
    private(set) var stateRows: [RawStateRow] = []

    private let sourceFile: URL

    public init(locations: LocationsDataset, seriesDataset: SeriesDataset, sourceFile customUrl: URL? = nil) throws {
        self.sourceFile = customUrl ?? Class.resourceFileURL(forFilename: "us-states.csv")
        self.stateRows = loadStates(from: sourceFile, intoLocations: locations, intoSeries: seriesDataset)
    }

    private func loadStates(from sourceUrl: URL,
                            intoLocations locations: LocationsDataset,
                            intoSeries seriesDataset: SeriesDataset) -> [RawStateRow] {
        guard let csv = try? CSV(url: sourceUrl) else {
            return []
        }
        let rows = csv.namedRows
            .compactMap { row in
                RawStateRow(date: IsoDate(isoString: row["date"]),
                     state: row["state"],
                     fips: row["fips"],
                     cases: Int(row["cases"]),
                     deaths: Int(row["deaths"]))
        }
        rows.forEach {
            locations.add($0.location)
        }
        seriesDataset.build(from: rows)
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
