import Vapor

class StateController {
    func index(_ req: Request) throws -> [StateRow] {
        let dataset = try req.make(StateFileDataset.self)

        return dataset.stateRows
    }
}

