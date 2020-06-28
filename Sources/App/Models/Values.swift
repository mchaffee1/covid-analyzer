import Foundation

typealias Values = [ValueType: Int]

enum ValueType: String {
    case cases
    case deaths
    case newCases
    case newCases7day
}

extension ValueType: Codable {}

