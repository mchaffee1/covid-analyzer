import Vapor

/// Called before the application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let locations = InMemoryLocationsDataset()
    services.register(locations, as: LocationsDataset.self)

    let seriesDataset = InMemorySeriesDataset(locations: locations)
    services.register(seriesDataset, as: SeriesDataset.self)

    services.register(try NytDataset(locations: locations, seriesDataset: seriesDataset),
                      as: RawDataset.self)
}

/// MARK: - Service Conformance
/// We do this here instead of in the source files, so we can keep the service classes
/// free of Vapor dependencies.
extension NytDataset: Service {}

extension InMemoryLocationsDataset: Service {}

extension InMemorySeriesDataset: Service {}
