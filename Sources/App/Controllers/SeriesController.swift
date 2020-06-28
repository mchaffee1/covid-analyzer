import Vapor

class SeriesController {
    func index(_ req: Request) throws -> SeriesResponse {
        let fips = try req.query.getFips()
        let dataset = try req.make(SeriesDataset.self)

        guard let series = dataset.getSeries(forFips: fips) else {
            throw Abort(.notFound, reason: "Could not retrieve series for fips \(fips)")
        }
        let filter: (DatePointResponse)->(Bool) = {
            guard let startDate = IsoDate(isoString: req.query[String.self, at: "startDate"]) else {
                return { _ in true }
            }
            return { datePointResponse in
                datePointResponse.date >= startDate
            }
        }()
        let response = SeriesResponse(series).filtered(with: filter)
        return response
    }
}

struct SeriesResponse: Content {
    let location: LocationResponse
    var days: [DatePointResponse]

    init(_ series: Series) {
        self.location = LocationResponse(location: series.location)
        self.days = series.days
            .keys.sorted()
            .compactMap { date in
                DatePointResponse(date: date, values: series.days[date])
        }
    }

    init(location: LocationResponse, datePoints: [DatePointResponse]) {
        self.location = location
        self.days = datePoints
    }

    func filtered(with filter: (DatePointResponse)->(Bool)) -> SeriesResponse {
        let filteredPoints = self.days.filter(filter)
        return SeriesResponse(location: self.location, datePoints: filteredPoints)
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

extension QueryContainer {
    func getFips() throws -> String {
        guard let result = self[String.self, at: "fips"] else {
            throw Abort(.badRequest, reason: "fips parameter is required")
        }
        return result
    }
}
