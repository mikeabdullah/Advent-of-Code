//
//  Day10.swift
//  AoCTests
//
//  Created by Mike on 10/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

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
            let device = sorted.last! + 3
            
            let count = sorted.numberOfPossibleValidAdaptorChains(from: 0, to: device)
            XCTAssertEqual(count, 8)
        }
    }

    func testSample2Big() throws {
        
        let location = Bundle(for: Self.self).url(forResource: "sample-input-10", withExtension: "txt")!
        let input = try String(contentsOf: location)
        let jolts = input.lines.map { Int($0)! }
        
        measure {
            let sorted = jolts.sorted()
            let device = sorted.last! + 3
            
            let count = sorted.numberOfPossibleValidAdaptorChains(from: 0, to: device)
            XCTAssertEqual(count, 19208)
        }
    }

    func testPart2() {
        
        var sorted = input.sorted()
        let device = sorted.last! + 3
        XCTAssertTrue(sorted.isValidAdaptorChain(from: 0, to: device))
        
        sorted.insert(0, at: 0)     // the charging port
        sorted.append(device) // the device
        
        let adaptors = sorted.dropFirst().dropLast()
        
        let validCombos = adaptors.numberOfPossibleValidAdaptorChains(from: 0, to: device)
        
        XCTAssertEqual(validCombos, 0)
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


extension Sequence where Element == Int {
    
    /// Checks that no step in the chain is greater than 3
    /// - Complexity: O(n)
    func isValidAdaptorChain(from previous: Int, to next: Int) -> Bool {
        
        var previous = previous
        for value in self {
            let step = value - previous
            guard step <= 3 else { return false }
            
            previous = value
        }
        
        let step = next - previous
        guard step <= 3 else { return false }
        
        return true
    }
}
 
extension BidirectionalCollection where Element == Int {

    func numberOfPossibleValidAdaptorChains(from previous: Int, to next: Int) -> Int {
        
        guard self.isValidAdaptorChain(from: previous, to: next) else {
            return 0
        }
        
        // Try all possible locations to split the chain once and see if still valid
        var validCombos = 1
        for i in indices {
            
            let (left, right) = split(at: i)
            
            // See if the split is valid, and then number of other valid splits within that chain!
            guard left.isValidAdaptorChain(from: previous, to: right.first ?? next)
                else { continue }
                        
            // Find every further valid split of the right chain
            validCombos += right.numberOfPossibleValidAdaptorChains(from: left.last ?? previous, to: next)
        }
        
        return validCombos
    }
    
    /// Performs a single split to give two subsequences, either side of the index, not including the index itself.
    func split(at index: Index) -> (before: SubSequence, after: SubSequence) {
        return (prefix(upTo: index),
                suffix(from: self.index(after: index)))
    }
}
