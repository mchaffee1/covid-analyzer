import Foundation
import XCTest

@testable import App

class StateRowTests: XCTestCase {
    func testShouldEmitProperLocation() {
        let stateRow = StateRow(date: IsoDate(isoString: "2020-04-24"),
                                state: "Illinois",
                                fips: "66",
                                cases: 1,
                                deaths: 2)

        XCTAssertEqual(stateRow?.location, State(fips: "66", name: "Illinois"))
    }
}
