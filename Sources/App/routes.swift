import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("healthcheck") { req in
        return "😃"
    }

    let stateController = StateController()
    router.get("raw-states", use: stateController.index)

    let locationsController = LocationsController()
    router.get("states", use: locationsController.index)

    let seriesController = SeriesController()
    router.get("series", use: seriesController.index)
}
