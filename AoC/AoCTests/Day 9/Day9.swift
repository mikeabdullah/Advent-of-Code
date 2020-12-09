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

    func testPart1() {
        measure {
            let value = input.firstWhereNotSumOfPairInPrecedingElements(25)
            XCTAssertEqual(value, 27911108)
        }
    }

    func testPart2() {
        let target = input.firstWhereNotSumOfPairInPrecedingElements(25)!
        
        measure {
            // Find a prior range that adds up to this.
            let window = input.firstSubsequenceWithSum(target)!
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
}

extension Array where Element == Int {
    
    /// Looks for the first value in the array where, in the `prefixCount` number of elements _before_ it, two of those value
    /// add together to give the value itself.
    /// - Complexity: O(n + k) where `n` is the number of elements in the array, `k` the number of preceding elements to search
    func firstWhereNotSumOfPairInPrecedingElements(_ prefixCount: Int) -> Element? {
        
        // Use a sliding window of the preamble before an element, and a set of the elements
        // within that window
        var window = self[...prefixCount]
        var windowValues = Set(window)
        
        repeat {
            // Stop if we find the value that isn't in the window
            let value = self[window.endIndex]
            if windowValues.firstCombination(summingTo: value) == nil {
                return value
            }
            
            // Slide the window along if we still can
            guard window.endIndex < self.endIndex else {
                return nil
            }
            
            windowValues.remove(window.first!)
            window = self[window.startIndex + 1 ... window.endIndex]
            windowValues.insert(window.last!)
            
        } while true
    }
    
    /// Finds the first subsequence whose elements sum to `total`
    /// - Complexity: O(n). I think 😄
    func firstSubsequenceWithSum(_ total: Int) -> SubSequence? {
        
        var window = self.prefix(upTo: 2)
        var windowSum = window.sum
        
        repeat {
            
            // If the sum is too low, extend the window
            // If it's too high, contract the window
            if windowSum == total {
                return window
            }
            else if windowSum < total {
                guard window.endIndex < self.endIndex   // stop at the end
                    else { return nil }
                
                window = self[window.startIndex ..< window.endIndex + 1]
                windowSum += window.last!
            }
            else if windowSum > total {
                windowSum -= window.first!
                window = self[window.startIndex + 1 ..< window.endIndex]
            }
            
        } while true
    }
}
