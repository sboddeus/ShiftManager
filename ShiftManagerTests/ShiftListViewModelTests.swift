//
//  ShiftListViewModelTests.swift
//  ShiftManagerTests
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation

import XCTest
@testable import ShiftManager

class ShiftListTestHelper: ShiftListViewModelDelegate {
    var didCallNewShift = false
    func startedNewShift() {
        didCallNewShift = true
    }

    var didCallSelected = false
    func selected(shift: ShiftType) {
        didCallSelected = true
    }
}

class ShiftListViewModelTests: XCTestCase {

    var shift = Shift(id: 1, start: "20200701T175220+1000", end: "20200701T175250+1000", startLatitude: "12", endLatitude: "12", startLongitude: "12", endLongitude: "12", image: URL(string: "http://google.com")!)

    var shifts: [ShiftType] {
        return [ShiftType.ended(Shift(id: 1, start: "20200701T175220+1000", end: "20200701T175250+1000", startLatitude: "12", endLatitude: "12", startLongitude: "12", endLongitude: "12", image: URL(string: "http://google.com")!)),ShiftType.ended(Shift(id: 1, start: "20200701T175220+1000", end: "20200701T175250+1000", startLatitude: "12", endLatitude: "12", startLongitude: "12", endLongitude: "12", image: URL(string: "http://google.com")!)),ShiftType.ongoing(ShiftRequest(time: "20200701T175220+1000", latitude: "12", longitude: "12"))]
    }

    func testStartDisabled() throws {
        let helper = ShiftListTestHelper()
        let test = ShiftListViewModel(shifts: shifts, delegate: helper)

        XCTAssertTrue(test.startShiftDisabled)
    }

    func testStartEnabled() throws {
           let helper = ShiftListTestHelper()
           let test = ShiftListViewModel(shifts: [ShiftType.ended(Shift(id: 1, start: "20200701T175220+1000", end: "20200701T175250+1000", startLatitude: "12", endLatitude: "12", startLongitude: "12", endLongitude: "12", image: URL(string: "http://google.com")!))], delegate: helper)

           XCTAssertFalse(test.startShiftDisabled)
       }


    func testDelegate() throws {
        let helper = ShiftListTestHelper()
        let test = ShiftListViewModel(shifts: shifts, delegate: helper)

        test.startedNewShift()
        test.selected(shift: 1)

        XCTAssertTrue(helper.didCallNewShift)
        XCTAssertTrue(helper.didCallSelected)
    }
}

