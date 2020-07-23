import Foundation
import Vapor

class SingleSeriesController {
    func index(_ request: Request) throws -> SingleSeriesResponse {
        let seriesDataset = try request.make(SeriesDataset.self)
        guard let series = try seriesDataset.getSeries(forFips: request.query.getFips()),
            let valueType = try request.query.getValueType(required: true) else {
                return .empty
        }

        var dates: [SingleSeriesDateResponse] = []
        series.dates.sorted().forEach {
            if let dateResponse = SingleSeriesDateResponse(date: $0, value: series[valueType, on: $0]) {
                dates.append(dateResponse)
            }
        }
        let locationResponse = LocationResponse(location: series.location)

        return SingleSeriesResponse(location: locationResponse, valueType: valueType, dates: dates)
    }
}

struct SingleSeriesResponse: Content {
    let location: LocationResponse
    let valueType: ValueType
    let dates: [SingleSeriesDateResponse]

    static let empty = SingleSeriesResponse(location: .empty, valueType: .cases, dates: [])
}

struct SingleSeriesDateResponse: Content {
    let date: IsoDate
    let value: Int

    init?(date: IsoDate?, value: Int?) {
        guard let date = date,
            let value = value else {
                return nil
        }
        self.date = date
        self.value = value
    }
}
