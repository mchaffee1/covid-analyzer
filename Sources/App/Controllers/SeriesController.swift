import Vapor

class SeriesController {
    func index(_ req: Request) throws -> SeriesResponse {
        guard let fips = req.query[String.self, at: "fips"] else {
            throw NSError(domain: "SeriesController", code: 404, userInfo: ["Message": "Could not extract FIPS parameter"])
        }
        let dataset = try req.make(SeriesDataset.self)
        guard let series = dataset.getSeries(forFips: fips) else {
            throw NSError(domain: "SeriesController", code: 404, userInfo: ["Message": "Could not retrieve series from dataset"])
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
    var datePoints: [DatePointResponse]

    init(_ series: Series) {
        self.location = LocationResponse(location: series.location)
        self.datePoints = series.datePoints
            .keys.sorted()
            .compactMap { date in
                DatePointResponse(date: date, values: series.datePoints[date])
        }
    }

    init(location: LocationResponse, datePoints: [DatePointResponse]) {
        self.location = location
        self.datePoints = datePoints
    }

    func filtered(with filter: (DatePointResponse)->(Bool)) -> SeriesResponse {
        let filteredPoints = self.datePoints.filter(filter)
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
