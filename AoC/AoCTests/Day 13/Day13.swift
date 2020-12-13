//
//  Day13.swift
//  AoCTests
//
//  Created by Mike on 13/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day13: XCTestCase {

    var input: [Substring]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-13", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines
    }

    func testPart1() throws {
        let now = Int(input[0])!
        let busNumbers = input[1].split(separator: ",").compactMap { Int($0) }
        
        // Find the bus whose schedule is closest to now
        let soonest = busNumbers.min(by: { a, b in
            return waitTime(for: a, after: now) < waitTime(for: b, after: now)
        })!
        
        XCTAssertEqual(soonest * waitTime(for: soonest, after: now), 3035)
    }

    func nextDeparture(of bus: Int, after time: Int) -> Int {
        return time + waitTime(for: bus, after: time)
    }
    
    func waitTime(for bus: Int, after time: Int) -> Int {
        let previous = time % bus
        let next = bus - previous
        return next
    }
}
