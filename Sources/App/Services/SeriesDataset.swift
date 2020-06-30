import Foundation

protocol SeriesDataset {
    func importRows(from: [RawLoadableRow])
    func getSeries(forFips: String) -> SimpleSeries?
}

class InMemorySeriesDataset: SeriesDataset {
    let locations: LocationsDataset

    init(locations: LocationsDataset) {
        self.locations = locations
    }

    private var seriesByFips: [String: SimpleSeries] = [:]

    func importRows(from rows: [RawLoadableRow]) {
        rows.forEach(importRow)

        seriesByFips.forEach { fips, series in // TODO this could still be nicer
            seriesByFips[fips] = series
                .transform(with: self.enrichWithNewCases)
                .transform(with: self.enrichWithNewCaseAverage)
        }
    }

    private func getSeries(for location: Location) -> SimpleSeries {
        return seriesByFips[location.fips] ?? SimpleSeries(location: location)
    }

    private func importRow(rawLoadableRow: RawLoadableRow) {
        guard let location = locations.location(forFips: rawLoadableRow.fips) else {
            return
        }

        let date = rawLoadableRow.date
        let cases = rawLoadableRow.cases
        let deaths = rawLoadableRow.deaths

        var series = getSeries(for: location)
        series.days[date] = [.cases: cases, .deaths: deaths]
        seriesByFips[location.fips] = series
    }

    func getSeries(forFips fips: String) -> SimpleSeries? {
        return seriesByFips[fips] ?? SimpleSeries(location: locations.location(forFips: fips))
    }

    private func enrichWithNewCases(series: SimpleSeries) -> SimpleSeries {
        var result = series
        let dates = series.days.keys.sorted()
        var lastCount = 0
        dates.forEach { date in
            guard let currentCount = series.days[date]?[.cases] else {
                return
            }
            result.days[date]?[.newCases] = currentCount - lastCount
            lastCount = currentCount
        }
        return result
    }

    private func enrichWithNewCaseAverage(series: SimpleSeries) -> SimpleSeries {
        var result = series
        let dateSet = series.days.keys.sorted().map { date in
            (date: date, newCases: series.days[date]?[.newCases] ?? 0)
        }.enumerated()
        dateSet.forEach {
            let minOffset = $0.offset - 6
            let maxOffset = $0.offset
            let sevenSet = dateSet.filter { day in
                day.offset >= minOffset && day.offset <= maxOffset
            }
            guard sevenSet.count == 7 else {
                return
            }
            let average = sevenSet
                .map { $0.element.newCases }
                .sum() / 7
            result.days[$0.element.date]?[.newCases7day] = average
        }
        return result
    }
}

protocol RawDatapoint {
    
}
