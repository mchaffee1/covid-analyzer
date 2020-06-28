import Vapor

class RawDataController {
    func index(_ req: Request) throws -> [RawStateRow] {
        let rawDataset = try req.make(RawDataset.self)

        return rawDataset.stateRows
    }
}

