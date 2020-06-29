import Foundation
import XCTest

@testable import App

class StateRowTests: XCTestCase {
    func testShouldEmitProperLocation() {
        let stateRow = RawStateRow(date: IsoDate(isoString: "2020-04-24"),
                                state: "Illinois",
                                fips: "66",
                                cases: 1,
                                deaths: 2)

        XCTAssertEqual(stateRow?.location as? State, State(fips: "66", name: "Illinois"))
    }
}
