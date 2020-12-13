//
//  Day13.swift
//  AoCTests
//
//  Created by Mike on 13/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest
import BigInt

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
        var offsetsAndBusNumbers = inputs.enumerated().compactMap { offset, bus -> (bus: Int, offset: Int)? in
            guard let number = Int(bus) else { return nil }
            return (number, offset)
        }
        
        // Sort to put the biggest first since those are hardest to calculate
        offsetsAndBusNumbers.sort(by: { $0.bus > $1.bus })
        
        var iterator = offsetsAndBusNumbers.makeIterator()
        var a = iterator.next()!
        var b = iterator.next()!
        
        var time = firstTime(that: b.bus, arrives: b.offset, after: a.bus, offset: a.offset)
        
        while let next = iterator.next() {
            let multiplied = a.bus * b.bus
            
            // Compute an equivalent bus schedule for the result so far, so can combine with the
            // next requirement
            a = (multiplied, multiplied - time)
            
            b = next
            time = firstTime(that: b.bus, arrives: b.offset, after: a.bus, offset: a.offset)
        }

        XCTAssertEqual(time, 106845)
    }
    
    func testPairOfBuses() {
        
        XCTAssertEqual(firstTime(that: 37, arrives: 11, after: 17), 544)
    }
    
    func testBezoutCoeffecients() {
        let coefficients = BezoutCoefficients(of: 17, 37)
        XCTAssertEqual(coefficients.x, -13)
        XCTAssertEqual(coefficients.y, 6)
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
    
    func firstTime(that busB: Int, arrives offsetB: Int, after busA: Int, offset offsetA: Int = 0) -> Int {
        
        let multiplied = busA * busB
        
        let coefficients = BezoutCoefficients(of: busA, busB).minimal()
        
        let occurrence = -( (offsetB * coefficients.x) * busA + offsetA * coefficients.y * busB)
        let first = occurrence.mod(multiplied)
        return first
    }
}


struct BezoutCoefficients {
    
    let a: Int, b: Int
    
    init(of a: Int, _ b: Int) {
        self.a = a
        self.b = b
        
        var (old_r, r) = (a, b)
        var (old_s, s) = (1, 0)
        var (old_t, t) = (0, 1)
        
        while r != 0 {
            let quotient = old_r / r
            (old_r, r) = (r, old_r - quotient * r)
            (old_s, s) = (s, old_s - quotient * s)
            (old_t, t) = (t, old_t - quotient * t)
        }
        
        self.x = old_s
        self.y = old_t
    }
    
    var x: Int
    var y: Int
    
    func coeffecients(for k: Int) -> BezoutCoefficients {
        var result = self
        result.x = x - k * b
        result.y = y + k * a
        return result
    }
    
    func minimal() -> BezoutCoefficients {
        let k = Int((Float(x) / Float(b)).rounded())
        return coeffecients(for: k)
    }
}


extension Int {
    
    func mod(_ mod: Int) -> Int {
        let result = self % mod
        return result >= 0 ? result : result + mod
    }
}
