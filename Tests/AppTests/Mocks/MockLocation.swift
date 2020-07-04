import Foundation

@testable import App

struct MockLocation: Location {
    var type: LocationType = .state

    let fips: String
    let name: String
}

extension MockLocation: Equatable {}
