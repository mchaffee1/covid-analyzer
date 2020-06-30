import Vapor

class RawDataController {
    func index(_ req: Request) throws -> [RawLoadableRow] {
        let rawDataset = try req.make(RawDataset.self)

        return rawDataset.rows
    }
}

extension RawLoadableRow: Content {}
