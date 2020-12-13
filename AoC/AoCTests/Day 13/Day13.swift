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
    
    func testPart2() {
        
        let inputs = input[1].split(separator: ",")
        let offsetsAndBusNumbers = inputs.enumerated().compactMap { offset, bus -> (bus: Int, offset: Int)? in
            guard let number = Int(bus) else { return nil }
            return (number, offset)
        }
        
        print(offsetsAndBusNumbers)
    }
    
    func testPairOfBuses() {
        
        XCTAssertEqual(firstTime(that: 37, arrives: 11, after: 17), 544)
    }
    
    func testBezoutCoeffecients() {
        let (u, v) = bezoutCoeffecients(of: 17, 37)
        XCTAssertEqual(u, -13)
        XCTAssertEqual(v, 6)
    }

    // MARK: -
    
    func nextDeparture(of bus: Int, after time: Int) -> Int {
        return time + waitTime(for: bus, after: time)
    }
    
    func waitTime(for bus: Int, after time: Int) -> Int {
        let previous = time % bus
        let next = bus - previous
        return next
    }
    
    func firstTime(that busB: Int, arrives offset: Int, after busA: Int) -> Int {
        
        let (u, v) = bezoutCoeffecients(of: busA, busB)
        
        let time = (-offset * u * busA) / (v * busB + u * busA)
        let first = time % (busA * busB)
        return first
    }
}


func bezoutCoeffecients(of a: Int, _ b: Int) -> (Int, Int) {
    
    var (old_r, r) = (a, b)
    var (old_s, s) = (1, 0)
    var (old_t, t) = (0, 1)
    
    while r != 0 {
        let quotient = old_r / r
        (old_r, r) = (r, old_r - quotient * r)
        (old_s, s) = (s, old_s - quotient * s)
        (old_t, t) = (t, old_t - quotient * t)
    }
    
//    assert(old_r == 1)
    return (old_s, old_t)
//    output "quotients by the gcd:", (t, s)
}
