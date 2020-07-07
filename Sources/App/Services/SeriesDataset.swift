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
                .transform(with: self.enrichWithSevenDayValues)
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
        series.set(values: [.cases: cases, .deaths: deaths], on: date)
        seriesByFips[location.fips] = series
    }

    func getSeries(forFips fips: String) -> SimpleSeries? {
        return seriesByFips[fips] ?? SimpleSeries(location: locations.location(forFips: fips))
    }

    private func enrichWithNewCases(series: SimpleSeries) -> SimpleSeries {
        var result = series
        var lastCount = 0
        series.dates.forEach { date in
            guard let currentCount = series[.cases, on: date] else {
                return
            }
            result.set(.newCases, to: currentCount - lastCount, on: date)

            lastCount = currentCount
        }
        return result
    }

    private func enrichWithSevenDayValues(series: SimpleSeries) -> SimpleSeries {
        var result = series
        var lastSeven = Queue<Int>(capacity: 7)

        series.dates.forEach { date in
            guard let currentCount = series[.newCases, on: date] else {
                return
            }
            lastSeven.enqueue(currentCount)

            guard lastSeven.count == 7 else { return }

            let total = lastSeven.values.sum()
            let average = total / 7

            result.set(.newCases7dayAverage, to: average, on: date)
            result.set(.newCases7dayTotal, to: total, on: date)
        }
        return result
    }
}

protocol RawDatapoint {
    
}
