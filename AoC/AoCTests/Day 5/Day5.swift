//
//  Day5.swift
//  AoCTests
//
//  Created by Mike on 05/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day5: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSeatID() {
        let seat = SeatCoordinate(row: 44, column: 5)
        XCTAssertEqual(seat.seatID, 357)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}



struct SeatCoordinate {
    let row: Int
    let column: Int
    
    var seatID: Int {
        row * 8 + column
    }
}
