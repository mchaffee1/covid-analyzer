import Foundation
import SwiftCSV

protocol RawDataset: Dataset {
    var rows: [RawLoadableRow] { get }
}

class NytDataset: RawDataset {
    private typealias Class = NytDataset
    private(set) var rows: [RawLoadableRow] = []

    public init(locations: LocationsDataset,
                seriesDataset: SeriesDataset,
                sourceFile customUrl: URL? = nil) throws {
        if let customSourceFile = customUrl {
            self.rows = loadRows(from: customSourceFile, intoLocations: locations, intoSeries: seriesDataset)
        } else {
            self.rows = loadAllFiles(intoLocations: locations, intoSeries: seriesDataset)
        }
    }

    private func loadAllFiles(intoLocations locations: LocationsDataset,
                              intoSeries seriesDataset: SeriesDataset) -> [RawLoadableRow] {
        ["us-states.csv", "us-counties.csv"]
            .compactMap { self.resourceFileURL(forFilename: $0) }
            .flatMap { self.loadRows(from: $0, intoLocations: locations, intoSeries: seriesDataset) }
    }

    func loadRows(from sourceUrl: URL,
                            intoLocations locations: LocationsDataset,
                            intoSeries seriesDataset: SeriesDataset) -> [RawLoadableRow] {
        guard let csv = try? CSV(url: sourceUrl) else {
            return []
        }
        let rows = csv.namedRows.compactMap(rawLoadableRow)

        rows.compactMap { try? self.location(from: $0) }
            .forEach(locations.add)

        seriesDataset.importRows(from: rows)
        return rows
    }

    private func rawLoadableRow(from csvRow: [String: String]) -> RawLoadableRow? {
        let date = IsoDate(isoString: csvRow["date"])
        let county = csvRow["county"]
        let state = csvRow["state"]
        let fips = csvRow["fips"]
        let cases = Int(csvRow["cases"])
        let deaths = Int(csvRow["deaths"])

        return RawLoadableRow(date: date,
                              county: county,
                              state: state,
                              fips: fips,
                              cases: cases,
                              deaths: deaths)
    }

    private func location(from rawLoadableRow: RawLoadableRow) throws -> Location {
        switch rawLoadableRow.locationType {
        case .state:
            return State(fips: rawLoadableRow.fips, name: rawLoadableRow.state)
        case .county:
            return try County(fips: rawLoadableRow.fips, name: rawLoadableRow.county, state: rawLoadableRow.state)
        }
    }
}
