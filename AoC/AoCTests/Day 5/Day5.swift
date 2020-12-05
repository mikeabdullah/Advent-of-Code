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
    
    func testBoardingPassCode() {
        let seat = SeatCoordinate(boardingPassCode: "FBFBBFFRLR")
        XCTAssertEqual(seat, SeatCoordinate(row: 44, column: 5))
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}



struct SeatCoordinate : Equatable {
    let row: Int
    let column: Int
    
    init(row: Int, column: Int) {
        assert((0...127).contains(row))
        assert((0...7).contains(column))
        
        self.row = row
        self.column = column
    }
    
    init?(boardingPassCode: String) {
        
        
        return nil
    }
    
    var seatID: Int {
        row * 8 + column
    }
}
