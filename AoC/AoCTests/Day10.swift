//
//  Day10.swift
//  AoCTests
//
//  Created by Mike on 10/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest
import Algorithms

class Day10: XCTestCase {

    var input: [Int]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-10", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines.map { Int($0)! }
    }
    
    func testSample1() throws {
        
        let location = Bundle(for: Self.self).url(forResource: "sample-input-10", withExtension: "txt")!
        let input = try String(contentsOf: location)
        let jolts = input.lines.map { Int($0)! }
        
        var sorted = jolts.sorted()
        sorted.insert(0, at: 0) // the charging port
        
        let (stepsOf1, stepsOf3) = sorted.stepsOf1And3()
        
        XCTAssertEqual(stepsOf1, 22)
        XCTAssertEqual(stepsOf3 + 1, 10)    // extra one for device
    }

    func testPart1() {
        
        var sorted = input.sorted()
        sorted.insert(0, at: 0) // the charging port
        
        let (stepsOf1, stepsOf3) = sorted.stepsOf1And3()
        
        XCTAssertEqual(stepsOf1 * (stepsOf3 + 1), 2343)
    }

    func testSample2Small() throws {
        
        let location = Bundle(for: Self.self).url(forResource: "sample-input-10-1", withExtension: "txt")!
        let input = try String(contentsOf: location)
        let jolts = input.lines.map { Int($0)! }
        
        measure {
            let sorted = jolts.sorted()
            XCTAssertEqual(sorted.numberOfPossibleValidAdaptorChains(), 8)
        }
    }

    func testSample2Big() throws {
        
        let location = Bundle(for: Self.self).url(forResource: "sample-input-10", withExtension: "txt")!
        let input = try String(contentsOf: location)
        let jolts = input.lines.map { Int($0)! }
        
        measure {
            let sorted = jolts.sorted()
            XCTAssertEqual(sorted.numberOfPossibleValidAdaptorChains(), 19208)
        }
    }

    func testPart2() {
        measure {
            let sorted = input.sorted()
            XCTAssertEqual(sorted.numberOfPossibleValidAdaptorChains(), 31581162962944)
        }
    }
}


extension Array where Element == Int {
    
    func stepsOf1And3() -> (Int, Int) {
        
        let pairs = zip(self, self.dropFirst())
        let steps = pairs.map { pair in
            return pair.1 - pair.0
        }
        
        let stepsOf1 = steps.count(of: 1)
        let stepsOf3 = steps.count(of: 3)
        return (stepsOf1, stepsOf3)
    }
}
 
extension Array where Element == Int {

    func numberOfPossibleValidAdaptorChains() -> Int {
        
        // Find the number of connections each element can legitimately make
        var lowerCursor = -1
        var lowerValue = 0
        
        var validConnectionCounts = self.enumerated().map { i, value -> Int in
            while lowerValue < value - 3 {
                lowerCursor += 1
                lowerValue = self[lowerCursor]
            }
            
            return i - lowerCursor
        }
        
        // Walk along totalling up the possible combos of connections
        for i in validConnectionCounts.indices.dropFirst() {
            
            // The count currently in the slot tells us how many of the prior values to sum
            let count = validConnectionCounts[i]
            validConnectionCounts[i] = validConnectionCounts[i - 1]
            if count >= 2 {
                validConnectionCounts[i] += validConnectionCounts[lowerProtected: i - 2] ?? 1
            }
            if count >= 3 {
                validConnectionCounts[i] += validConnectionCounts[lowerProtected: i - 3] ?? 1
            }
        }
        
        return validConnectionCounts.last!
    }
}

extension BidirectionalCollection where Element == Int {
    
    /// Performs a single split to give two subsequences, either side of the index, not including the index itself.
    func split(at index: Index) -> (before: SubSequence, after: SubSequence) {
        return (prefix(upTo: index),
                suffix(from: self.index(after: index)))
    }
}


extension Array {
    
    subscript(lowerProtected index: Index) -> Element? {
        guard index >= startIndex else { return nil }
        return self[index]
    }
}
