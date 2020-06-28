import Foundation
import Vapor

protocol SeriesDataset {
    func build(from rawDataset: [StateRow])
    func getSeries(forFips: String) -> SimpleSeries?
}

class InMemorySeriesDataset: SeriesDataset {
    let locations: Locations

    init(locations: Locations) {
        self.locations = locations
    }

    private var seriesByFips: [String: SimpleSeries] = [:]

    func build(from rawDataset: [StateRow]) {
        rawDataset
            .compactMap { (stateRow)->(Location, IsoDate, Int, Int)? in
                guard let location = locations.location(forFips: stateRow.fips) else { return nil }
                return (location, stateRow.date, stateRow.cases, stateRow.deaths) }
            .forEach { (location, date, cases, deaths)->() in
                var series = seriesByFips[location.fips] ?? SimpleSeries(location: location)
                series.days[date] = [.cases: cases, .deaths: deaths]
                seriesByFips[location.fips] = series }
        seriesByFips.forEach { fips, series in
            seriesByFips[fips] = {
                var result = series
                result = self.enrichWithNewCases(series: result)
                result = self.enrichWithNewCaseAverage(series: result)
                return result
            }()
        }
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
                .reduce(0) { $0 + $1 }
                / 7
            result.days[$0.element.date]?[.newCases7day] = average
        }
        return result
    }
}

extension InMemorySeriesDataset: Service {}

protocol RawDatapoint {
    
}
