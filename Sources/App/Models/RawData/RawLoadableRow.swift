import Foundation

protocol RawLoadableRow {
    var date: IsoDate { get }
    var fips: String { get }
    var cases: Int { get }
    var deaths: Int { get }
}
