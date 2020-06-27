import Vapor

class NytProvider {

}

extension NytProvider: Provider {
    public func register(_ services: inout Services) throws {
        // TODO register NytLoader I guess
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }


}
