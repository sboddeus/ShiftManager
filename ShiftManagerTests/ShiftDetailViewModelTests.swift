//
//  ShiftDetailViewModelTests.swift
//  ShiftManagerTests
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import XCTest
@testable import ShiftManager

class ShiftDetailTestHelper: ShiftDetailViewModelDelegate {
    var didCall = false
    func end(shift: ShiftRequest) {
        didCall = true
    }
}

class ShiftDetailViewModelTests: XCTestCase {

    func testOngoingType() throws {
        let request = ShiftRequest(time: "20200701T175220+1000", latitude: "12", longitude: "12")
        let helper = ShiftDetailTestHelper()
        let test = ShiftDetailViewModel(kind: .ongoing(request), delegate: helper)

        XCTAssertNil(test.image)
        XCTAssertEqual(test.title, "Current Shift")
        XCTAssertEqual(test.button, "End")
    }

    func testEndedType() throws {
        let request = Shift(id: 1, start: "20200701T175220+1000", end: "20200701T175250+1000", startLatitude: "12", endLatitude: "12", startLongitude: "12", endLongitude: "12", image: URL(string: "http://google.com")!)
        let helper = ShiftDetailTestHelper()
        let test = ShiftDetailViewModel(kind: .ended(request), delegate: helper)

        XCTAssertNotNil(test.image)
        XCTAssertNotNil(test.title)
        XCTAssertNotNil(test.startLocation)
        XCTAssertNotNil(test.endLocation)
        XCTAssertNil(test.button)
    }

    func testDelegate() throws {
        let request = ShiftRequest(time: "20200701T175220+1000", latitude: "12", longitude: "12")
        let helper = ShiftDetailTestHelper()
        let test = ShiftDetailViewModel(kind: .ongoing(request), delegate: helper)

        test.end()

        XCTAssertTrue(helper.didCall)
    }
}
