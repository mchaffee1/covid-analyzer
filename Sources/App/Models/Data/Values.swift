import Foundation

typealias Values = [ValueType: Int]

enum ValueType: String {
    case cases
    case deaths
    case newCases
    case newCases7dayAverage
    case newCases7dayTotal
    case newDeaths
    case population
}

extension ValueType: Codable {}
