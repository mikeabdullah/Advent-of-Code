//
//  Day9.swift
//  AoCTests
//
//  Created by Mike on 09/12/2020.
//  Copyright © 2020 Mike Abdullah. All rights reserved.
//

import XCTest

class Day9: XCTestCase {

    var input: [Int]!
    
    override func setUpWithError() throws {
        let location = Bundle(for: Self.self).url(forResource: "input-9", withExtension: "txt")!
        let input = try String(contentsOf: location)
        self.input = input.lines.map { Int($0)! }
    }

    func testPart1() throws {
        measure {
            let firstInvalid = input.enumerated().dropFirst(25).first(where: { i, value in
                let preceding = input[i-25 ..< i]
                return !preceding.containsCombination(summingTo: value)
            })
            
            XCTAssertEqual(firstInvalid?.element, 27911108)
        }
    }

    func testPart2() {
        
        let index = 509
        let target = 27911108
        // Find a prior range that adds up to this.
        
        let preceding = input[..<index]
        
        let suffix = preceding.suffixes().first(where: {
            $0.prefixWithSum(greaterThanOrEqualTo: target).sum == target
        })!
        
        let slice = suffix.prefixWithSum(greaterThanOrEqualTo: target)
        XCTAssertEqual(slice.sum, target)
        
        let min = slice.min()!
        let max = slice.max()!
        XCTAssertEqual(min + max, 4023754)
    }
}


extension Collection where Element == Int {
    
    /// Convenience to total up values.
    var sum: Int {
        return self.reduce(0, +)
    }
    
    func prefixWithSum(greaterThanOrEqualTo total: Int) -> SubSequence {
        
        var runningTotal = 0
        return self.prefix(while: { value in
            defer { runningTotal += value }
            return runningTotal < total
        })
    }
    
    /// All possible suffixes within the collection
    func suffixes() -> [SubSequence] {
        return indices.map { i in
            return self[i...]
        }
    }
}
