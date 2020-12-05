//
//  Day5.swift
//  AoCTests
//
//  Created by Mike on 05/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day5: XCTestCase {
    
    var input: [Substring]!

    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-5", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }
    
    func testSeatID() {
        let seat = SeatCoordinate(row: 44, column: 5)
        XCTAssertEqual(seat.seatID, 357)
    }
    
    func testBoardingPassCode() {
        let seat = SeatCoordinate(boardingPassCode: "FBFBBFFRLR")
        XCTAssertEqual(seat, SeatCoordinate(row: 44, column: 5))
    }

    func testPart1() throws {
        measure {
            let seats = input.lazy.map { SeatCoordinate(boardingPassCode: $0)! }
            let seatIDs = seats.map(\.seatID)
            let max = seatIDs.max()!
            XCTAssertEqual(max, 842)
        }
    }

    func testPart2() throws {
        measure {
            
            let seats = input.lazy.map { SeatCoordinate(boardingPassCode: $0)! }
            let seatIDs = Set(seats.map(\.seatID))
            
            let possibleIDs = 0..<1024
            
            let missing = possibleIDs.first(where: {
                !seatIDs.contains($0) && seatIDs.contains($0 - 1) && seatIDs.contains($0 + 1)
            })
            
            XCTAssertEqual(missing, 617)
        }
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
    
    init?<S>(boardingPassCode: S) where S : StringProtocol {
        
        var rowRange = 0..<128
        for char in boardingPassCode.prefix(7) {
            switch char {
            case "F": rowRange = rowRange.binarySpacePartition(.lower)
            case "B": rowRange = rowRange.binarySpacePartition(.higher)
            default: return nil
            }
        }
        assert(rowRange.lowerBound == rowRange.upperBound - 1)
        
        var columnRange = 0..<8
        for char in boardingPassCode.suffix(3) {
            switch char {
            case "L": columnRange = columnRange.binarySpacePartition(.lower)
            case "R": columnRange = columnRange.binarySpacePartition(.higher)
            default: return nil
            }
        }
        assert(columnRange.lowerBound == columnRange.upperBound - 1)
        
        self = SeatCoordinate(row: rowRange.lowerBound, column: columnRange.lowerBound)
    }
    
    var seatID: Int {
        row * 8 + column
    }
}


extension Range where Bound == Int {
    
    var mid: Bound {
        lowerBound + (upperBound - lowerBound) / 2
    }
    
    /// Returns the lower of higher half of the range, according to `half`.
    func binarySpacePartition(_ half: BinarySpacePartitionHalf) -> Self {
        switch half {
        case .lower: return self.lowerBound..<self.mid
        case .higher: return self.mid..<self.upperBound
        }
    }
}

enum BinarySpacePartitionHalf {
    case lower
    case higher
}
