import Vapor

extension QueryContainer {
    func getFips() throws -> String {
        guard let result = self[String.self, at: "fips"] else {
            throw Abort(.badRequest, reason: "fips parameter is required")
        }
        return result
    }

    func getStartDate() throws -> IsoDate? {
        guard let isoString = self[String.self, at: "startDate"] else {
            return nil
        }
        guard let result = IsoDate(isoString: isoString) else {
            throw Abort(.badRequest, reason: "Could not parse IsoDate from '$\(isoString)'")
        }
        return result
    }

    func getValueType(required: Bool = false) throws -> ValueType? {
        guard let valueTypeString = self[String.self, at: "valueType"] else {
            if required { throw Abort(.badRequest, reason: "valueType parameter is required") }
            return nil
        }
        guard let valueType = ValueType(rawValue: valueTypeString) else {
            throw Abort(.badRequest, reason: "Could not parse ValueType from '$\(valueTypeString)'")
        }
        return valueType
    }
}
