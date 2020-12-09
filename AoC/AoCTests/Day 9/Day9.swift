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
            
            // Use a sliding window of the preamble before an element, and a set of the elements
            // within that window
            var window = input[...25]
            var windowValues = Set(window)
            
            repeat {
                let target = input[window.endIndex]
                
                // Stop once we find the value that isn't in the window
                if windowValues.firstCombination(summingTo: target) == nil {
                    XCTAssertEqual(target, 27911108)
                    break
                }
                
                // Slide the window along
                windowValues.remove(window.first!)
                window = input[window.startIndex + 1 ... window.endIndex]
                windowValues.insert(window.last!)
                
            } while true
        }
    }

    func testPart2() {
        measure {
//            let index = 509
            let target = 27911108
            // Find a prior range that adds up to this.
            
            var window = input.prefix(upTo: 2)
            var sum = window.sum
            
            repeat {
                
                // If the sum is too low, extend the window
                // If it's too high, contract the window
                if sum == target {
                    break
                }
                else if sum < target {
                    window = input[window.startIndex ..< window.endIndex + 1]
                    sum += window.last!
                }
                else if sum > target {
                    sum -= window.first!
                    window = input[window.startIndex + 1 ..< window.endIndex]
                }
                
            } while true
            
                        
            let min = window.min()!
            let max = window.max()!
            XCTAssertEqual(min + max, 4023754)
        }
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
