import Foundation
import SwiftCSV

protocol RawDataset: Dataset {
    var rows: [RawLoadableRow] { get }
}

class NytDataset: RawDataset {
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
        ["us-states.csv", "us-counties.csv", "us.csv"]
            .compactMap(resourceFileURL)
            .flatMap { self.loadRows(from: $0, intoLocations: locations, intoSeries: seriesDataset) }
    }

    fileprivate func buildLocations(from rows: [RawLoadableRow], into locations: LocationsDataset) {
        rows.compactMap { try? self.location(from: $0) }
            .forEach(locations.add)
    }

    private func loadRows(from sourceUrl: URL,
                            intoLocations locations: LocationsDataset,
                            intoSeries seriesDataset: SeriesDataset) -> [RawLoadableRow] {
        print("Loading rows from \(sourceUrl)")

        guard let csv = try? CSV(url: sourceUrl) else {
            return []
        }

        let defaultFips = filenameFips(from: sourceUrl)

        let rows = csv.namedRows
            .compactMap { self.rawLoadableRow(from: $0, withDefaultFips: defaultFips) }

        buildLocations(from: rows, into: locations)

        seriesDataset.importRows(from: rows)
        return rows
    }

    private func rawLoadableRow(from csvRow: [String: String], withDefaultFips defaultFips: String? = nil) -> RawLoadableRow? {
        let date = IsoDate(isoString: csvRow["date"])
        let county = csvRow["county"]
        let state = csvRow["state"]
        let fips = getFips(for: csvRow, default: defaultFips)
        let cases = Int(csvRow["cases"])
        let deaths = Int(csvRow["deaths"])

        return RawLoadableRow(date: date,
                              county: county,
                              state: state,
                              fips: fips,
                              cases: cases,
                              deaths: deaths)
    }

    fileprivate func getFips(for csvRow: [String : String], default defaultFips: String?) -> String? {
        return specialFips(for: csvRow)
            ?? csvRow["fips"]
            ?? defaultFips
    }

    private func specialFips(for csvRow: [String: String]) -> String? {
        guard csvRow["fips"]?.isEmpty ?? true,
            let county = csvRow["county"],
            county == "New York City" else {
                return nil
        }
        return "nyc"
    }

    private func location(from rawLoadableRow: RawLoadableRow) throws -> Location {
        switch rawLoadableRow.locationType {
        case .state:
            return try State(fips: rawLoadableRow.fips, name: rawLoadableRow.state)
        case .county:
            return try County(fips: rawLoadableRow.fips, name: rawLoadableRow.county, state: rawLoadableRow.state)
        case .nation:
            return Nation(fips: rawLoadableRow.fips, name: rawLoadableRow.fips)
        }
    }

    private func filenameFips(from fileUrl: URL) -> String? {
        guard let fileName = fileUrl
            .lastPathComponent
            .split(separator: ".")
            .first?
            .uppercased() else {
            return nil
        }
        return String(fileName)
    }
}
