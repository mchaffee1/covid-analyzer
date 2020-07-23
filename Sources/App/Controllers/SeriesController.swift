import Vapor

class SeriesController {
    func index(_ request: Request) throws -> SeriesResponse {
        let fips = try request.query.getFips()
        let seriesDataset = try request.make(SeriesDataset.self)

        guard let series = seriesDataset.getSeries(forFips: fips) else {
            throw Abort(.notFound, reason: "Could not retrieve series for fips \(fips)")
        }

        let response = try SeriesResponse(series)
            .filtered(with: self.getFilters(for: request))
        return response
    }

    private typealias ResponseFilter = (DatePointResponse)->(Bool)

    private func getFilters(for request: Request) throws -> ResponseFilter {
        var filters: [ResponseFilter] = []
        if let startDate = try request.query.getStartDate() {
            filters.append({ $0.date >= startDate })
        }
        return { response in
            filters
                .map { filter in filter(response) }
                .reduce(true) { $0 && $1 }
        }
    }
}

struct SeriesResponse: Content {
    let location: LocationResponse
    var days: [DatePointResponse]

    init<SeriesType: Series>(_ series: SeriesType) {
        let location = LocationResponse(location: series.location)
        let days = series.dates
            .compactMap { date in
                DatePointResponse(date: date, values: series[date])
        }
        self.init(location: location, days: days)
    }

    init(location: LocationResponse, days: [DatePointResponse]) {
        self.location = location
        self.days = days
    }

    func filtered(with filter: (DatePointResponse)->(Bool)) -> SeriesResponse {
        let filteredPoints = self.days.filter(filter)
        return SeriesResponse(location: self.location, days: filteredPoints)
    }
}

struct DatePointResponse: Content {
    let date: IsoDate
    let values: [String: Int]

    init?(date: IsoDate?, values: Values?) {
        guard let date = date,
            let values = values else {
                return nil
        }
        self.date = date
        self.values = {
            var result = [String: Int]()
            values.forEach { key, value in
                result[key.rawValue] = value
            }
            return result
        }()
    }
}
