import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("healthcheck") { req in
        return "😃"
    }

    let locationsController = LocationsController()
    router.get("locations", use: locationsController.index)

    let seriesController = SeriesController()
    router.get("series", use: seriesController.index)

    let singleSeriesController = SingleSeriesController()
    router.get("singleSeries", use: singleSeriesController.index)
}
