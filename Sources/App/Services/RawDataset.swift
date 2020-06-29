import Foundation
import SwiftCSV

protocol RawDataset: Dataset {
    var stateRows: [RawLoadableRow] { get }
}

class NytDataset: RawDataset {
    private typealias Class = NytDataset
    private(set) var stateRows: [RawLoadableRow] = []

    private let sourceFile: URL

    public init(locations: LocationsDataset,
                seriesDataset: SeriesDataset,
                sourceFile customUrl: URL? = nil) throws {
        self.sourceFile = customUrl ?? Class.resourceFileURL(forFilename: "us-states.csv")
        self.stateRows = loadStates(from: sourceFile, intoLocations: locations, intoSeries: seriesDataset)
    }

    private func loadStates(from sourceUrl: URL,
                            intoLocations locations: LocationsDataset,
                            intoSeries seriesDataset: SeriesDataset) -> [RawLoadableRow] {
        guard let csv = try? CSV(url: sourceUrl) else {
            return []
        }
        let rows = csv.namedRows.compactMap(rawLoadableRow)

        rows.forEach { row in
            locations.add(self.location(from: row))
        }
        seriesDataset.build(from: rows)
        return rows
    }

    private func rawLoadableRow(from csvRow: [String: String]) -> RawLoadableRow? {
        let date = IsoDate(isoString: csvRow["date"])
        let state = csvRow["state"]
        let fips = csvRow["fips"]
        let cases = Int(csvRow["cases"])
        let deaths = Int(csvRow["deaths"])

        return RawLoadableRow(date: date,
                              state: state,
                              fips: fips,
                              cases: cases,
                              deaths: deaths)
    }

    private func location(from rawLoadableRow: RawLoadableRow) -> Location {
        switch rawLoadableRow.locationType {
        case .state:
            return State(fips: rawLoadableRow.fips, name: rawLoadableRow.state)
        }
    }
}
